:-['../data/infr/infr.pl', '../data/app.pl'].
:-['../requirements.pl', '../costs.pl'].
:- dynamic best_so_far/2.

:- set_prolog_flag(answer_write_options,[max_depth(0)]). % write answers' text entirely
:- set_prolog_flag(stack_limit, 32 000 000 000).
:- set_prolog_flag(last_call_optimisation, true).

best(App, Placement, Cost, CapCost) :-
    application(App, Functions, Services), 
    % RankedComps --> sort components by increasing HWReqs
    ranking(Functions, Services, RankedComps),
    % Components --> sort comp nodes by decreasing HWCaps
    findCompatibles(RankedComps, Components),
    placement(Components, Placement, CapCost, Cost),
    qosOK(Placement),
    findall(N, distinct(member((_,N), Placement)), S),
    sort(S, Ss), length(Ss, L), writeln(L).

findCompatibles([(_,S)|Ss], [(S,SCompatibles)|Rest]):-
  findCompatibles(Ss, Rest),
  findall((Cost, H, M), lightNodeOK(S, M, H, Cost), Compatibles),  
  %sort(1, @>, Compatibles, Tmp), sort(2, @<, Tmp, SCompatibles),
  sort(Compatibles, SCompatibles).
findCompatibles([],[]).

lightNodeOK(S,N,H,SCost) :-
  serviceInstance(S, SId),
  service(SId, _, SWReqs, (Arch, HWReqs)),
  node(N, NType, SWCaps, (Arch, HWCaps), _, _),
  subset(SWReqs, SWCaps),
  HWCaps >= HWReqs, H is 1/HWCaps,
  cost(NType, S, SCost).

lightNodeOK(F,N,H,FCost) :-
    functionInstance(F, FId, _), 
    function(FId, _, SWPlatform, (Arch, HWReqs)),
    node(N, NType, SWCaps, (Arch, HWCaps), _, _),
    member(SWPlatform, SWCaps),
    HWCaps >= HWReqs, H is 1/HWCaps,
    cost(NType, F, FCost).

placement([(C, Comps)|Cs], [(C,N)|Ps], CapCost, NewCost) :-
    placement(Cs, Ps, CapCost, Cost),
    componentPlacement(C, Comps, N, Ps, CCost),
    % write(C), write(" on "), writeln(N),
    NewCost is Cost + CCost, NewCost < CapCost.
placement([], [], _, 0).

/*componentPlacement(F, Comps, N, Ps, FCost) :-
    functionInstance(F, FId, _), function(FId, _, _, HWReqs),
    member((_,N), Ps), member((FCost,_,N), Comps),
    compatible(N, HWReqs, Ps).
*/
componentPlacement(F, Comps, N, Ps, FCost) :-
    functionInstance(F, FId, _), function(FId, _, _, HWReqs),
    member((FCost,_,N), Comps), %\+ member((_,N),Ps),
    compatible(N, HWReqs, Ps).

/*componentPlacement(S, Comps, N, Ps, SCost) :-
    serviceInstance(S, SId), service(SId, _, _, HWReqs),
    member((_,N), Ps), member((SCost,_,N), Comps),
    compatible(N, HWReqs, Ps).
*/
componentPlacement(S, Comps, N, Ps, SCost) :-
    serviceInstance(S, SId), service(SId, _, _, HWReqs),
    member((SCost,_,N), Comps), %\+ member((_,N),Ps),
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

qosOK(Ps) :- 
    findall((N1N2, Lat), relevant(N1N2, Ps, Lat, _), DataFlows), 
    checkDF(DataFlows, Ps).

checkDF([((N1,N2),ReqLat)|DFs], Ps) :-
    checkDF(DFs, Ps), 
    link(N1, N2, FeatLat, FeatBW),
    FeatLat =< ReqLat,
    bwOK((N1,N2), FeatBW, Ps).
checkDF([], _).

bwOK(N1N2, FeatBW, Ps):-
    findall(BW, relevant(N1N2, Ps, _, BW), BWs), sum_list(BWs, OkAllocBW), 
    bwTh(T), FeatBW >= OkAllocBW + T.

relevant((N1,N2), Ps, Lat, BW) :-
    dataFlow(T1,T2,_,_,Size,Rate,Lat),
    (member((T1,N1), Ps); node(N1, _, _, _, _, IoTCaps), member(T1, IoTCaps)),
    (member((T2,N2), Ps); node(N2, _, _, _, _, IoTCaps), member(T2, IoTCaps)),
    dif(N1,N2), BW is Rate*Size.