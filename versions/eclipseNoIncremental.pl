:-['../data/infr/infr32.pl', '../data/app.pl'].
:-['../requirements.pl', '../costs.pl'].
:-lib(branch_and_bound).
:-lib(ic).

best(App, Placement, Optimum, CapCost) :-
    application(App, Functions, Services), 
    ranking(Functions, Services, Components),
    Options = bb_options{strategy:continue, from:0, to:CapCost, delta:1, timeout: 10},
    bb_min(goal(Components,Placement,Cost), Cost, Options).
    %bb_min(goal(Components,Placement,Cost), Cost, [], _, Optimum, Options).

goal(Components, Placement, Cost):-
    placement(Components, Placement, Cost),
    qosOK(Placement).

placement([(_,C)|Cs], [(C,N)|Ps], NewCost) :-
    placement(Cs, Ps, Cost),
    componentPlacement(C, N, Ps, CCost),
    NewCost is Cost + CCost.
placement([], [], 0).

componentPlacement(F, N, Ps, FCost) :-
    functionInstance(F, FId, _), function(FId, FType, SWPlat, (Arch,HWReqs)),
    node(N, NType, SWCaps, (Arch,HWCaps), _, _), 
    %requirements(FType, F, N),
    member(SWPlat,SWCaps), hwOK(N,HWCaps,HWReqs,Ps),
    cost(NType, F, FCost).

componentPlacement(S, N, Ps, SCost) :-
    serviceInstance(S, SId), service(SId, SType, SWReqs, (Arch,HWReqs)),
    node(N, NType, SWCaps, (Arch,HWCaps), _, _), 
    %requirements(SType, S, N),
    sub_set(SWReqs, SWCaps), hwOK(N,HWCaps,HWReqs,Ps),
    cost(NType, S, SCost).

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
    (member((T1,N1), Ps); node(N1, _, _, _, _, IoTCaps), member(T1, IoTCaps)),
    (member((T2,N2), Ps); node(N2, _, _, _, _, IoTCaps), member(T2, IoTCaps)),
    dif(N1,N2), BW is Rate*Size.

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