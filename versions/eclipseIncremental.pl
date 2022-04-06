:-['../data/infr/infr32.pl', '../data/app.pl'].
:-['../requirements.pl', '../costs.pl'].
:-lib(branch_and_bound).
:-lib(ic).

best(App, Placement, Cost, CapCost) :-
    application(App, Functions, Services), 
    ranking(Functions, Services, Components),
    Options = bb_options{strategy:restart, from:0, to:CapCost, delta:0.01},
    bb_min(placement(Components,Placement,Cost), Cost, Options).

placement([(_,C)|Cs], [(C,N)|Ps], NewCost) :-
    placement(Cs, Ps, Cost),
    componentPlacement(C, N, Ps, CCost),
    NewCost is CCost + Cost.
placement([], [], 0).

componentPlacement(F, N, Ps, FCost) :-
    functionInstance(F, FId, _), function(FId, FType, SWPlat, (Arch,HWReqs)),
    node(N, NType, SWCaps, (Arch,HWCaps), _, _), cost(NType, F, FCost),
    %requirements(FType, F, N), 
    member(SWPlat,SWCaps), hwOK(N,HWCaps,HWReqs,Ps), qosOK(F, N, Ps).


componentPlacement(S, N, Ps, SCost) :-
    serviceInstance(S, SId), service(SId, SType, SWReqs, (Arch,HWReqs)),
    node(N, NType, SWCaps, (Arch,HWCaps), _, _), cost(NType, S, SCost),
    %requirements(SType, S, N),
    sub_set(SWReqs, SWCaps), hwOK(N,HWCaps,HWReqs,Ps), qosOK(S, N, Ps).

hwOK(N,HWCaps,HWReqs,Ps) :-
    findall(HW, hwOnN(N, Ps, HW), HWs), sum_list(HWs,TotHW),
    hwTh(T), HWCaps >= TotHW + HWReqs + T.

hwOnN(N, Ps, HW) :- serviceInstance(S, SId), service(SId,_,_,(_,HW)), member((S,N), Ps).
hwOnN(N, Ps, HW) :- functionInstance(F, FId,_), function(FId,_,_,(_,HW)), member((F,N), Ps).

qosOK(T, N, Ps) :-
    findall((N1N2, Lat), relevant(T, N, Ps, N1N2, Lat), DataFlows), latOK(DataFlows),
    findall(N1N2, member((N1N2,_),DataFlows), BWs), bwOK(BWs, [(T,N)|Ps]).

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

sum_list([], 0.0).
sum_list([X|Xs], Sum) :-
    sum_list(Xs, OldSum),
    Sum is X+OldSum.

sub_set([],_).
sub_set([X|Xs], B) :-
    member(X,B),
    sub_set(Xs,B).

dif(A,B) :-
    A \= B.