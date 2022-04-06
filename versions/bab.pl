:-['../data/infr.pl', '../data/app.pl'].
:-['../requirements.pl', '../costs.pl'].
:- dynamic best_so_far/2.

:- set_prolog_flag(answer_write_options,[max_depth(0)]). % write answers' text entirely
:- set_prolog_flag(stack_limit, 16 000 000 000).
:- set_prolog_flag(last_call_optimisation, true).

bestPlacement(App, BestPlacement, BestCost, CapCost) :-
    application(App, Functions, Services),
    initializeBound(CapCost),
    functionPlacement(Functions, FPlacement, FCost),
    servicePlacement(Services, FPlacement, SPlacement, FCost, Cost),
    %qosOK((FPlacement, SPlacement)), 
    updateBound((FPlacement, SPlacement), Cost), fail;
    best_so_far(BestPlacement, BestCost).

functionPlacement([F|Fs], [(F,N,HWReqs)|Ps], NewCost) :-
    functionPlacement(Fs, Ps, Cost),
    functionInstance(F, FId, _), function(FId, FType, SWPlat, (Arch,HWReqs)),
    node(N, NType, SWCaps, (Arch,HWCaps), _, _), 
    requirements(FType, F, N),
    member(SWPlat,SWCaps), hwOK(N,HWCaps,HWReqs,Ps,[]),
    cost(NType, F, C), best_so_far(_, BestCostSoFar), 
    NewCost is Cost + C, NewCost < BestCostSoFar.
functionPlacement([], [], 0).

servicePlacement([S|Ss], FPlacement, [(S,N,HWReqs)|Ps], CurrCost, NewCost) :-
    servicePlacement(Ss, FPlacement, Ps, CurrCost, Cost),
    serviceInstance(S, SId), service(SId, SType, SWReqs, (Arch,HWReqs)),
    node(N, NType, SWCaps, (Arch,HWCaps), _, _), 
    requirements(SType, S, N),
    subset(SWReqs, SWCaps), hwOK(N,HWCaps,HWReqs,FPlacement, Ps),
    cost(NType, S, C), best_so_far(_, BestCostSoFar), 
    NewCost is Cost + C, NewCost < BestCostSoFar.
servicePlacement([], _, [], CurrCost, CurrCost).

hwOK(N,HWCaps,HWReqs,FP,SP) :-
    append(FP,SP,Ps),
    findall(H, member((_,N,H),Ps), HWs), sum_list(HWs,TotHW),
    HWCaps >= TotHW + HWReqs.

qosOK((FP, SP)) :-
    append(FP, SP, P),
    findall((N1N2, Lat, BW), relevant(N1N2, Lat, BW, P), DataFlows),
    checkDF(DataFlows, _).

relevant((N1,N2), Lat, BW, P) :-
    dataFlow(T1, T2, _, _, Size, Rate, Lat),
    member((T1,N1,_), P), member((T2,N2,_), P), dif(N1,N2),
    BW is Rate*Size.

relevant((N1,N2), Lat, BW, P) :-
    dataFlow(T1, T2, _, _, Size, Rate, Lat),
    node(N1, _, _, _, _, IoTCaps), member(T1, IoTCaps), member((T2,N2,_), P), dif(N1,N2),
    BW is Rate*Size.

relevant((N1,N2), Lat, BW, P) :-
    dataFlow(T1, T2, _, _, Size, Rate, Lat),
    member((T1,N1,_), P), node(N2, _, _, _, _, IoTCaps), member(T2, IoTCaps), dif(N1,N2),
    BW is Rate*Size.

checkDF([((N1,N2),ReqLat,ReqBW)|DFs], NewAllocBW) :-
    checkDF(DFs, AllocBW),
    link(N1, N2, FeatLat, FeatBW),
    FeatLat =< ReqLat,
    bwOK(N1, N2, ReqBW, FeatBW, AllocBW, NewAllocBW).
checkDF([], []).

bwOK(N1, N2, ReqBW, FeatBW, AllocBW, NewBW):-
    findall(BW, member((N1,N2,BW), AllocBW), BWs), sum_list(BWs, NewAllocBW), 
    bwTh(T), FeatBW >= ReqBW + NewAllocBW + T,
    bwAllocation(N1, N2, ReqBW, AllocBW, NewBW).

bwAllocation(N1, N2, ReqBW, TBW, [(N1, N2, NewBW)|BWs]) :-
    select((N1, N2, BW), TBW, BWs), NewBW is BW+ReqBW.
bwAllocation(N1, N2, ReqBW, TBW, [(N1, N2, ReqBW)|TBW]).

initializeBound(CapCost) :- 
    retract(best_so_far(_,_)), fail;
    assert(best_so_far(dummy, CapCost)).

updateBound(Placement, Cost) :-
    retract(best_so_far(_,_)), !,
    assert(best_so_far(Placement, Cost)).