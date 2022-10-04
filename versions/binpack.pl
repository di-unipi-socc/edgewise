%:-['../data/infrs/infr128.pl', '../data/apps/speakToMe.pl'].
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
    checkThings, 
    ranking(Functions, Services, RankedComps),  % RankedComps:  [(Rank, Comp)|Rest] --> sort "Comp" by increasing HWReqs
    findCompatibles(RankedComps, Components),   % Components:   [(Comp, Compatibles)|Rest]--> sort "Compatibles" nodes by decreasing HWCaps
    placement(Components, Placement, Budget, Cost),
    statistics(cputime, StartTime),
    timer(StartTime, Placement).
    %qosOK(Placement).

checkThings :-
    findall(T, thingInstance(T, _), Things),
    findall(T, (node(_, _, _, _, _, IoTCaps), member(T, IoTCaps)), IoT),
    subset(Things, IoT).

timer(StartTime, Placement) :-
    MaxTime is StartTime+300, statistics(cputime, CurrTime),
    (CurrTime < MaxTime -> qosOK(Placement); !, false).

countDistinct(P, L) :-
    findall(N, distinct(member((_,N), P)), S),
    sort(S, Ss), length(Ss, L).

findCompatibles([(_,C)|Cs], [(C,SCompatibles)|Rest]):-
    findCompatibles(Cs, Rest),
    findall((Cost, H, M), lightNodeOK(C, M, H, Cost), Compatibles),  
    sort(Compatibles, SCompatibles).
findCompatibles([],[]).

lightNodeOK(S,N,H,SCost) :-
    serviceInstance(S, SId), service(SId, SWReqs, (Arch, HWReqs)),
    node(N, NType, SWCaps, (Arch, HWCaps), _, _),
    requirements(SId, N),
    subset(SWReqs, SWCaps), 
    HWCaps >= HWReqs, H is 1/HWCaps, % H used to sort Compatibles (ascending H --> descending HWCaps)) 
    cost(NType, S, SCost).

lightNodeOK(F,N,H,FCost) :-
    functionInstance(F, FId, _), function(FId, SWPlatform, (Arch, HWReqs)),
    node(N, NType, SWCaps, (Arch, HWCaps), _, _),
    requirements(FId, N),
    member(SWPlatform, SWCaps), 
    HWCaps >= HWReqs, H is 1/HWCaps,
    cost(NType, F, FCost).

placement(Cs, Placement, Budget, NewCost) :-
    placement(Cs, [], Placement, Budget, 0, NewCost).

placement([(C, Comps)|Cs], OldP, NewP, Budget, OldCost, NewCost) :-
    componentPlacement(C, Comps, N, OldP, CCost),
    TCost is OldCost + CCost, TCost < Budget,
    placement(Cs, [(C,N)|OldP], NewP, Budget, TCost, NewCost).
placement([], P, P, _, Cost, Cost).

componentPlacement(F, Comps, N, Ps, FCost) :-
    functionInstance(F, FId, _), function(FId, _, HWReqs),
    member((_,N), Ps), member((FCost,_,N), Comps),
    compatible(N, HWReqs, Ps).
componentPlacement(F, Comps, N, Ps, FCost) :-
    functionInstance(F, FId, _), function(FId, _, HWReqs),
    member((FCost,_,N), Comps), \+ member((_,N),Ps),
    compatible(N, HWReqs, Ps).

componentPlacement(S, Comps, N, Ps, SCost) :-
    serviceInstance(S, SId), service(SId, _, HWReqs),
    member((_,N), Ps), member((SCost,_,N), Comps),
    compatible(N, HWReqs, Ps).
componentPlacement(S, Comps, N, Ps, SCost) :-
    serviceInstance(S, SId), service(SId, _, HWReqs),
    member((SCost,_,N), Comps), \+ member((_,N),Ps),
    compatible(N, HWReqs, Ps).

compatible(N, (Arch,HWReqs), Ps) :-
    node(N, _, _, (Arch, HWCaps), _, _), 
    hwOK(N, HWCaps, HWReqs, Ps).

hwOK(N,HWCaps,HWReqs,Ps) :-
    findall(HW, hwOnN(N, Ps, HW), HWs), sum_list(HWs,TotHW),
    hwTh(T), HWCaps >= TotHW + HWReqs + T.

hwOnN(N, Ps, HW) :- serviceInstance(S, SId), service(SId,_,(_,HW)), member((S,N), Ps).
hwOnN(N, Ps, HW) :- functionInstance(F, FId,_), function(FId,_,(_,HW)), member((F,N), Ps).

qosOK(Ps) :-
    findall((N1N2, Lat, Sec), relevant(N1N2, Ps, Lat, _, Sec), DataFlows),
    checkDF(DataFlows, Ps).

checkDF([((N1,N2),ReqLat,SecReqs)|DFs], Ps) :-
    checkDF(DFs, Ps),
    (link(N1, N2, FeatLat, FeatBW); link(N2, N1, FeatLat, FeatBW)),
    secOK(N1, N2, SecReqs),
    FeatLat =< ReqLat, bwOK((N1,N2), FeatBW, Ps).
checkDF([], _).

bwOK(N1N2, FeatBW, Ps):-
    findall(BW, relevant(N1N2, Ps, _, BW, _), BWs), sum_list(BWs, OkAllocBW), 
    bwTh(T), FeatBW >= OkAllocBW + T.

secOK(N1, N2, SecReqs) :-
    node(N1, _, _, _, SecCaps1, _), subset(SecReqs, SecCaps1),
    node(N2, _, _, _, SecCaps2, _), subset(SecReqs, SecCaps2).

relevant((N1,N2), Ps, Lat, BW, Sec):-
    dataFlow(T1, T2, _, Sec, Size, Rate, Lat),
    (member((T1,N1), Ps); node(N1, _, _, _, _, IoTCaps), member(T1, IoTCaps)),
    (member((T2,N2), Ps); node(N2, _, _, _, _, IoTCaps), member(T2, IoTCaps)),
    BW is Size*Rate.