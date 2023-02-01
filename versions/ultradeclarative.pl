% :-['../data/infrs/infrUC.pl', '../data/apps/distSecurity.pl'].
:-['../utils/requirements.pl', '../utils/costs.pl'].

:- multifile link/4.
link(X, X, 0, inf).

:- set_prolog_flag(answer_write_options,[max_depth(0)]). % write answers' text entirely
:- set_prolog_flag(stack_limit, 32 000 000 000).
:- set_prolog_flag(last_call_optimisation, true).

tolerance(0.0).

stats(App, Placement, Cost, Bins, Infs, Time, Budget) :-
    statistics(inferences, InfA),
        statistics(cputime, TimeA),
            best(App, Placement, Cost, Budget),
            countDistinct(Placement, Bins),
        statistics(cputime, TimeB),
    statistics(inferences, InfB),

    Infs is InfB - InfA,
    Time is TimeB - TimeA.

best(App, Placement, Cost, Budget) :-
    application(App, Functions, Services), checkThings,
    eligiblePlacement(Functions, Services, Budget, Placement, Cost).

eligiblePlacement(Functions, Services, Budget, Placement, Cost):-
    placement(Functions, Services, Placement),
    costOK(Placement, Budget, Cost), hwOK(Placement), qosOK(Placement).

countDistinct(P, L) :-
    findall(N, distinct(member((_,N), P)), S),
    sort(S, Ss), length(Ss, L).

checkThings :-
    findall(T, thingInstance(T, _), Things),
    findall(T, (node(_, _, _, _, _, IoTCaps), member(T, IoTCaps)), IoT),
    subset(Things, IoT).

placement(Functions, Services, Placement) :-
    append(Functions, Services, Components),
    placement(Components, Placement).

placement([C|Cs], [(C,N)|P]) :-
    placement(Cs, P), componentPlacement(C,N).
placement([], []).
    
componentPlacement(F, N) :-
    functionInstance(F, FId, _), function(FId, SWPlat, (Arch,_)),
    node(N, _, SWCaps, (Arch,_), _, _), 
    requirements(FId, N), 
    member(SWPlat, SWCaps).
componentPlacement(S, N) :-
    serviceInstance(S, SId), service(SId, SWReqs, (Arch,_)),
    node(N, _, SWCaps, (Arch,_), _, _), 
    requirements(SId, N), 
    subset(SWReqs, SWCaps).

costOK(Placement, Budget, Cost) :-
    findall(C, (member((S,N), Placement), componentCost(S,N,C)), Costs), sum_list(Costs,Cost),
    tolerance(T), Tol is T * Budget,
    Cost < Budget + Tol.

componentCost(S,N,C) :- node(N, NType, _, _, _, _), cost(NType,S,C).

hwOK(Placement) :-
    findall(N, distinct(member((_,N),Placement)), Nodes),
    nodeHwOK(Nodes,Placement).

nodeHwOK([N|Nodes], Placement) :-
    findall(HW, hwOnN(N, Placement, HW), HWs), sum_list(HWs,TotHW),
    node(N, _, _, (_, HWCaps), _, _),
    hwTh(T), HWCaps >= TotHW + T,
    nodeHwOK(Nodes, Placement).
nodeHwOK([], _).

hwOnN(N, Ps, HW) :- serviceInstance(S, SId), service(SId,_,(_,HW)), member((S,N), Ps).
hwOnN(N, Ps, HW) :- functionInstance(F, FId,_), function(FId,_,(_,HW)), member((F,N), Ps).

qosOK(Ps) :-
    findall((N1N2, Lat, Sec), relevant(N1N2, Ps, Lat, _, Sec), DataFlows),
    checkDF(DataFlows, Ps).

checkDF([((N1,N2), ReqLat, SecReqs)|DFs], Ps) :-
    checkDF(DFs, Ps),
    secOK(N1, N2, SecReqs),
    link(N1, N2, FeatLat, FeatBW),
    FeatLat =< ReqLat,
    bwOK((N1,N2), FeatBW, Ps).
checkDF([], _).

bwOK(N1N2, FeatBW, Ps):-
    findall(BW, relevant(N1N2, Ps, _, BW, _), BWs), sum_list(BWs, OkAllocBW), 
    bwTh(T), FeatBW >= OkAllocBW + T.

secOK(N1, N2, SecReqs) :-
    node(N1, _, _, _, SecCaps1, _), subset(SecReqs, SecCaps1),
    node(N2, _, _, _, SecCaps2, _),  subset(SecReqs, SecCaps2).

relevant((N1,N2), Ps, Lat, BW, Sec):-
    dataFlow(T1, T2, _, Sec, Size, Rate, Lat),
    (member((T1,N1), Ps); node(N1, _, _, _, _, IoTCaps), member(T1, IoTCaps)),
    (member((T2,N2), Ps); node(N2, _, _, _, _, IoTCaps), member(T2, IoTCaps)),
    BW is Size*Rate.
