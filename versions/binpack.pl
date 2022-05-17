% :-['../data/infrs/infr64.pl', '../data/apps/speakToMe.pl'].
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
    writeln("prova"),
    application(App, Functions, Services), 
    ranking(Functions, Services, RankedComps),  % RankedComps:  [(Rank, Comp)|Rest] --> sort "Comp" by increasing HWReqs
    writeln("ranking"),
    findCompatibles(RankedComps, Components),   % Components:   [(Comp, Compatibles)|Rest]--> sort "Compatibles" nodes by decreasing HWCaps
    writeln("comps"),
    placement(Components, Placement, Budget, Cost), qosOK(Placement).

countDistinct(P, L) :-
    findall(N, distinct(member((_,N), P)), S),
    sort(S, Ss), length(Ss, L).

findCompatibles([(_,C)|Cs], [(C,SCompatibles)|Rest]):-
    findCompatibles(Cs, Rest),
    findall((Cost, H, M), lightNodeOK(C, M, H, Cost), Compatibles),  
    sort(Compatibles, SCompatibles).
    %length(SCompatibles, L), write(C), write(" - "), writeln(L).
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

placement(Cs, Placement, Budget, NewCost) :-
    placement(Cs, [], Placement, Budget, 0, NewCost).
    % write("Found placement: "), writeln(Placement).

placement([(C, Comps)|Cs], OldP, NewP, Budget, OldCost, NewCost) :-
    componentPlacement(C, Comps, N, OldP, CCost),
    TCost is OldCost + CCost, TCost < Budget,
    placement(Cs, [(C,N)|OldP], NewP, Budget, TCost, NewCost).
placement([], P, P, _, Cost, Cost).

pickNode(N, Ps, Comps, Cost):-
    (member((_,N), Ps), member((Cost,_,N), Comps));
    (member((Cost,_,N), Comps), \+ member((_,N),Ps)).

componentPlacement(F, Comps, N, Ps, FCost) :-
    functionInstance(F, FId, _), function(FId, _, _, HWReqs),
    pickNode(N, Ps, Comps, FCost), compatible(N, HWReqs, Ps).

componentPlacement(S, Comps, N, Ps, SCost) :-
    serviceInstance(S, SId), service(SId, _, _, HWReqs),
    pickNode(N, Ps, Comps, SCost), compatible(N, HWReqs, Ps).

compatible(N, (_,HWReqs), Ps) :-
    node(N, _, _, (_, HWCaps), _, _), 
    hwOK(N, HWCaps, HWReqs, Ps). 
    %requirements(TType, T, N),

hwOK(N,HWCaps,HWReqs,Ps) :-
    findall(HW, hwOnN(N, Ps, HW), HWs), sum_list(HWs,TotHW),
    hwTh(T), HWCaps >= TotHW + HWReqs + T.

hwOnN(N, Ps, HW) :- serviceInstance(S, SId), service(SId,_,_,(_,HW)), member((S,N), Ps).
hwOnN(N, Ps, HW) :- functionInstance(F, FId,_), function(FId,_,_,(_,HW)), member((F,N), Ps).

qosOK(Ps) :- 
    findall((N1N2, Lat), relevant(N1N2, Ps, Lat, _), DataFlows), 
    checkDF(DataFlows, Ps).

checkDF([((N1,N2),ReqLat)|DFs], Ps) :-
    checkDF(DFs, Ps), 
    link(N1, N2, FeatLat, FeatBW),
    FeatLat =< ReqLat, bwOK((N1,N2), FeatBW, Ps).
checkDF([], _).

bwOK(N1N2, FeatBW, Ps):-
    findall(BW, relevant(N1N2, Ps, _, BW), BWs), sum_list(BWs, OkAllocBW), 
    bwTh(T), FeatBW >= OkAllocBW + T.

relevant((N1,N2), Ps, Lat, BW) :-
    dataFlow(T1,T2,_,_,Size,Rate,Lat),
    (member((T1,N1), Ps); (node(N1, _, _, _, _, IoTCaps), member(T1, IoTCaps))),
    (member((T2,N2), Ps); (node(N2, _, _, _, _, IoTCaps), member(T2, IoTCaps))),
    dif(N1,N2), BW is Rate*Size.