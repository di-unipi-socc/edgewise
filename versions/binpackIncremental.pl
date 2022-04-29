%:-['../data/infrs/infr64.pl', '../data/apps/speakToMe.pl'].
:-['../requirements.pl', '../costs.pl'].

:- set_prolog_flag(answer_write_options,[max_depth(0)]). % write answers' text entirely
:- set_prolog_flag(stack_limit, 32 000 000 000).
:- set_prolog_flag(last_call_optimisation, true).

stats(App, Placement, Cost, NDistinct, Infs, Time, Budget) :-
    statistics(inferences, InfA),
        statistics(cputime, TimeA),
            best(App, Placement, Cost, Budget),
            countDistinct(Placement, NDistinct),
        statistics(cputime, TimeB),
    statistics(inferences, InfB),

    Infs is InfB - InfA,
    Time is TimeB - TimeA.

best(App, Placement, Cost, Budget) :-
    application(App, Functions, Services), 
    ranking(Functions, Services, RankedComps),  % RankedComps:  [(Rank, Comp)|Rest] --> sort "Comp" by increasing HWReqs
    findCompatibles(RankedComps, Components),   % Components:   [(Comp, Compatibles)|Rest]--> sort "Compatibles" nodes by decreasing HWCaps
    placement(Components, Placement, Budget, Cost).

countDistinct(P, L) :-
    findall(N, distinct(member((_,N), P)), S),
    sort(S, Ss), length(Ss, L).

findCompatibles([(_,C)|Cs], [(C,SCompatibles)|Rest]):-
    findCompatibles(Cs, Rest),
    findall((Cost, H, M), lightNodeOK(C, M, H, Cost), Compatibles),  
    sort(Compatibles, SCompatibles).
    %sort(1, @>, Compatibles, Tmp), sort(2, @<, Tmp, SCompatibles),
findCompatibles([],[]).

lightNodeOK(S,N,H,SCost) :-
    serviceInstance(S, SId),
    service(SId, _, SWReqs, (Arch, HWReqs)),
    node(N, NType, SWCaps, (Arch, HWCaps), _, _),
    subset(SWReqs, SWCaps),
    HWCaps >= HWReqs, H is 1/HWCaps, % H used to sort Compatibles (ascending H --> descending HWCaps)) 
    cost(NType, S, SCost).

lightNodeOK(F,N,H,FCost) :-
    functionInstance(F, FId, _), 
    function(FId, _, SWPlatform, (Arch, HWReqs)),
    node(N, NType, SWCaps, (Arch, HWCaps), _, _),
    member(SWPlatform, SWCaps),
    HWCaps >= HWReqs, H is 1/HWCaps,
    cost(NType, F, FCost).

placement([(C, Comps)|Cs], [(C,N)|Ps], Budget, NewCost) :-
    placement(Cs, Ps, Budget, Cost),
    componentPlacement(C, Comps, N, Ps, CCost),
    qosOK(C, N, Ps),
    NewCost is Cost + CCost, NewCost < Budget.
placement([], [], _, 0).


componentPlacement(F, Comps, N, Ps, FCost) :-
    functionInstance(F, FId, _), function(FId, _, _, HWReqs),
    member((_,N), Ps), member((FCost,_,N), Comps),
    compatible(N, HWReqs, Ps).
componentPlacement(F, Comps, N, Ps, FCost) :-
    functionInstance(F, FId, _), function(FId, _, _, HWReqs),
    member((FCost,_,N), Comps), \+ member((_,N),Ps),
    compatible(N, HWReqs, Ps).

componentPlacement(S, Comps, N, Ps, SCost) :-
    serviceInstance(S, SId), service(SId, _, _, HWReqs),
    member((_,N), Ps), member((SCost,_,N), Comps),
    compatible(N, HWReqs, Ps).
componentPlacement(S, Comps, N, Ps, SCost) :-
    serviceInstance(S, SId), service(SId, _, _, HWReqs),
    member((SCost,_,N), Comps), \+ member((_,N),Ps),
    compatible(N, HWReqs, Ps).

compatible(N, (_,HWReqs), Ps) :-
    node(N, _, _, (_, HWCaps), _, _), 
    hwOK(N, HWCaps, HWReqs, Ps). 
    %requirements(TType, T, N),

hwOK(N,HWCaps,HWReqs,Ps) :-
    findall(HW, hwOnN(N, Ps, HW), HWs), sum_list(HWs,TotHW),
    hwTh(T), HWCaps >= TotHW + HWReqs + T.

hwOnN(N, Ps, HW) :- serviceInstance(S, SId), service(SId,_,_,(_,HW)), member((S,N), Ps).
hwOnN(N, Ps, HW) :- functionInstance(F, FId,_), function(FId,_,_,(_,HW)), member((F,N), Ps).

qosOK(C, N, Ps) :-
    findall((N1N2, Lat), distinct(relevant(C, N, Ps, N1N2, Lat)), DataFlows), 
    latOK(DataFlows),
    findall(N1N2, distinct(member((N1N2,_),DataFlows)), BWs), 
    bwOK(BWs, [(C,N)|Ps]).

relevant(T, N, Ps, (N,N2), Lat) :- 
    dataFlow(T, T2, _, _, _, _, Lat), 
    (member((T2,N2), Ps); node(N2, _, _, _, _, IoTCaps), member(T2, IoTCaps)), dif(N,N2).
relevant(T, N, Ps, (N1,N), Lat) :- 
    dataFlow(T1, T, _, _, _, _, Lat), 
    (member((T1,N1), Ps); node(N1, _, _, _, _, IoTCaps), member(T1, IoTCaps)), dif(N1,N).

latOK([((N1,N2), ReqLat)|DFs]) :-
    link(N1,N2,FeatLat,_),
    FeatLat =< ReqLat,
    latOK(DFs).
latOK([]).

bwOK([(N1,N2)|DFs], Ps) :-
    link(N1,N2,_,FeatBW),
    findall(BW, flowsOnN1N2((N1,N2), Ps, BW), BWs), sum_list(BWs, OkAllocBW), 
    bwTh(T), FeatBW >= OkAllocBW + T,
    bwOK(DFs, Ps).
bwOK([],_).

flowsOnN1N2((N1,N2), Ps, BW) :-
    dataFlow(T1,T2,_,_,Size,Rate,_),
    (member((T1,N1), Ps); node(N1, _, _, _, _, IoTCaps), member(T1, IoTCaps)),
    (member((T2,N2), Ps); node(N2, _, _, _, _, IoTCaps), member(T2, IoTCaps)),
    BW is Rate*Size.