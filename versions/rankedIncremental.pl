:-['../data/infr/infr32.pl', '../data/app.pl'].
:-['../requirements.pl', '../costs.pl'].
:- dynamic best_so_far/2.

:- set_prolog_flag(answer_write_options,[max_depth(0)]). % write answers' text entirely
:- set_prolog_flag(stack_limit, 16 000 000 000).
:- set_prolog_flag(last_call_optimisation, true).

best(App, BestPlacement, BestCost, CapCost) :-
    application(App, Functions, Services), 
    ranking(Functions, Services, RankedComps),
    initializeBound(CapCost),
    placement(RankedComps, Placement, Cost),
    updateBound(Placement, Cost), fail;
    best_so_far(BestPlacement, BestCost).

placement([(_,C)|Cs], [(C,N)|Ps], NewCost) :-
    placement(Cs, Ps, Cost),
    componentPlacement(C, N, Ps, CCost),
    best_so_far(_, BestCostSoFar),
    NewCost is Cost + CCost, NewCost < BestCostSoFar.
placement([], [], 0).

componentPlacement(F, N, Ps, FCost) :-
    functionInstance(F, FId, _), function(FId, FType, SWPlat, (Arch,HWReqs)),
    node(N, NType, SWCaps, (Arch,HWCaps), _, _), 
    %requirements(FType, F, N), 
    member(SWPlat,SWCaps), hwOK(N,HWCaps,HWReqs,Ps), qosOK(F, N, Ps),
    cost(NType, F, FCost).

componentPlacement(S, N, Ps, SCost) :-
    serviceInstance(S, SId), service(SId, SType, SWReqs, (Arch,HWReqs)),
    node(N, NType, SWCaps, (Arch,HWCaps), _, _), 
    %requirements(SType, S, N), 
    subset(SWReqs, SWCaps), hwOK(N,HWCaps,HWReqs,Ps), qosOK(S, N, Ps),
    cost(NType, S, SCost).

hwOK(N,HWCaps,HWReqs,Ps) :-
    findall(HW, hwOnN(N, Ps, HW), HWs), sum_list(HWs,TotHW),
    hwTh(T), HWCaps >= TotHW + HWReqs + T.

hwOnN(N, Ps, HW) :- serviceInstance(S, SId), service(SId,_,_,(_,HW)), member((S,N), Ps).
hwOnN(N, Ps, HW) :- functionInstance(F, FId,_), function(FId,_,_,(_,HW)), member((F,N), Ps).

qosOK(T, N, Ps) :-
    findall((N1N2, Lat), distinct(relevant(T, N, Ps, N1N2, Lat)), DataFlows), 
    latOK(DataFlows),
    findall(N1N2, distinct(member((N1N2,_),DataFlows)), BWs), 
    bwOK(BWs, [(T,N)|Ps]).

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

initializeBound(CapCost) :- 
    retract(best_so_far(_,_)), fail;
    assert(best_so_far(no_deployment, CapCost)).

updateBound(Placement, Cost) :-
    retract(best_so_far(_,_)), !,
    assert(best_so_far(Placement, Cost)).