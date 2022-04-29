% :-['../data/infrs/infr16.pl', '../data/apps/speakToMe.pl'].
:-['../requirements.pl', '../costs.pl'].

:- set_prolog_flag(answer_write_options,[max_depth(0)]). % write answers' text entirely
:- set_prolog_flag(stack_limit, 32 000 000 000).
:- set_prolog_flag(last_call_optimisation, true).

tolerance(0.0).

/*best(App, Placement, Cost, Budget) :-
    application(App, Functions, Services), 
    findall((C,P), eligiblePlacement(Functions, Services, Budget, P, C), Pls), sort(Pls,[(Cost, Placement)|_]), 
    % writeln("Found first placement"), writeln(Placement), writeln(Cost),
    % (eligiblePlacement(Functions, Services, Budget, P1, C1), dif(Placement, P1), C1 < Cost),
    % writeln("This last Placement is optimal"),
    countDistinct(Placement). % only for testing
*/

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
    eligiblePlacement(Functions, Services, Budget, Placement, Cost).

eligiblePlacement(Functions, Services, Budget, Placement, Cost):-
    placement(Functions, Services, Placement),
    costOK(Placement, Budget, Cost), hwOK(Placement), qosOK(Placement).
    %write(Placement), write(" - "), writeln(Cost).

countDistinct(P, L) :-
    findall(N, distinct(member((_,N), P)), S),
    sort(S, Ss), length(Ss, L).
    % write("Distinct Nodes: "), write(L), write(" - "), writeln(Ss).

placement(Functions, Services, Placement) :-
    append(Functions, Services, Components),
    placement(Components, Placement).

placement([C|Cs], [(C,N)|P]) :-
    placement(Cs, P), componentPlacement(C,N).
placement([], []).
    
componentPlacement(F, N) :-
    functionInstance(F, FId, _), function(FId, _, SWPlat, (Arch,_)),
    node(N, _, SWCaps, (Arch,_), _, _), 
    %requirements(FType, F, N), 
    member(SWPlat,SWCaps).
componentPlacement(S, N) :-
    serviceInstance(S, SId), service(SId, _, SWReqs, (Arch,_)),
    node(N, _, SWCaps, (Arch,_), _, _), 
    %requirements(SType, S, N), 
    subset(SWReqs, SWCaps).

costOK(Placement, Budget, Cost) :-
    findall(C, (member((S,N), Placement), componentCost(S,N,C)), Costs), sum_list(Costs,Cost),
    tolerance(T), Tol is T * Budget,
    Cost < Budget + Tol.

componentCost(S,N,C) :- node(N, NType, _, _, _, _), cost(NType,S,C).

hwOK(Placement) :-
    findall(N, distinct(member((_,N),Placement)), Nodes),
    nodeHwOk(Nodes,Placement).

nodeHwOk([N|Nodes], Placement) :-
    findall(HW, hwOnN(N, Placement, HW), HWs), sum_list(HWs,TotHW),
    node(N, _, _, (_, HWCaps), _, _),
    hwTh(T), HWCaps >= TotHW + T,
    nodeHwOk(Nodes, Placement).
nodeHwOk([], _).

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
    (member((T1,N1), Ps); node(N1, _, _, _, _, IoTCaps), member(T1, IoTCaps)),
    (member((T2,N2), Ps); node(N2, _, _, _, _, IoTCaps), member(T2, IoTCaps)),
    dif(N1,N2), BW is Rate*Size.