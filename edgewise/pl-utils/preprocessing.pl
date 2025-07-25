:-['requirements.pl', 'costs.pl'].
:- dynamic deployed/2.

% :- ['../applications/prolog/speakToMe.pl', '../infrastructures/BA/infr64-151195.pl'].


:- set_prolog_flag(answer_write_options,[max_depth(0)]). % write answers' text entirely
:- set_prolog_flag(stack_limit, 128 000 000 000).
:- set_prolog_flag(last_call_optimisation, true).

preprocess(App, Compatibles) :-
    \+ deployed(App, _),
    application(App, Functions, Services), 
    append(Functions, Services, Components),
    findCompatibles(Components, Compatibles).
preprocess(App, Compatibles) :-
    deployed(App, Placement),
    crStep(Placement, Compatibles).

crStep(P, Compatibles) :- crStep(P, P, [], Compatibles).
crStep([(C,N)|P], CurrP, POk, [(C,[(N,Cost)])|Cs]) :-
    componentPlacement(C, N, CurrP, POk), qosOK(C, N, CurrP, POk),
    nodeType(N, Type), cost(Type, C, Cost),
    crStep(P, CurrP, [(C,N)|POk], Cs).
crStep([(C,N)|P], CurrP, POk, [(C,[Comp|Atibles])|Cs]) :-
    \+ ( componentPlacement(C, N, CurrP, POk), qosOK(C, N, CurrP, POk) ),
    findall((M, Cost), lightNodeOK(C, M, Cost), [Comp|Atibles]),
    crStep(P, CurrP, POk, Cs).
crStep([], _, _, []).

componentPlacement(F, N, CurrP, P) :-
    functionInstance(F, FId, _), function(FId, SWPlat, (Arch,HWReqs)),
    node(N, SWCaps, (Arch,HWCaps), _, _), 
    requirements(FId, N), 
    member(SWPlat, SWCaps),
    hwOK(N, HWCaps, HWReqs, CurrP, P).
componentPlacement(S, N, CurrP, P) :-
    serviceInstance(S, SId), service(SId, SWReqs, (Arch,HWReqs)),
    node(N, SWCaps, (Arch,HWCaps), _, _), 
    requirements(SId, N), 
    subset(SWReqs, SWCaps),
    hwOK(N, HWCaps, HWReqs, CurrP, P).

checkThings :-
    findall(T, thingInstance(T, _), Things),
    findall(T, (node(_, _, _, _, IoTCaps), member(T, IoTCaps)), IoT),
    subset(Things, IoT).

qosOK(C, N, CurrP, P) :- 
    findall(DF, relevant(C, N, P, DF), DataFlows), 
    checkDF(DataFlows, CurrP, [(C,N)|P]).

hwOnN(N, Ps, HW) :- serviceInstance(S, SId), service(SId,_,(_,HW)), member((S,N), Ps).
hwOnN(N, Ps, HW) :- functionInstance(F, FId,_), function(FId,_,(_,HW)), member((F,N), Ps).

hwOK(N, HWCaps, HWReqs, CurrP, P) :- 
    findall(H, hwOnN(N, P, H), Hs), sum_list(Hs, UsedHW),
    findall(H, hwOnN(N, CurrP, H), CurrHs), sum_list(CurrHs, CurrHw),
    hwTh(T), HWCaps + CurrHw >= HWReqs + UsedHW + T.

relevant(C, N, P, (N, M, Lat, BW, Sec)):-
    dataFlow(C, C1, _, Sec, Size, Rate, Lat),
    (member((C1,M), P); node(M, _, _, _, IoTCaps), member(C1, IoTCaps)),
    BW is Size*Rate.
relevant(C, N, _, (M, N, Lat, BW, Sec)):-
    dataFlow(C1, C, _, Sec, Size, Rate, Lat),
    node(M, _, _, _, IoTCaps), member(C1, IoTCaps),
    BW is Size*Rate.

checkDF([(N1,N2, ReqLat, _, SecReqs)|DFs], CurrP, [(C,N)|P]) :-
    secOK(N1, N2, SecReqs),
    link(N1, N2, FeatLat, FeatBW),
    FeatLat =< ReqLat,
    bwOK(C, N, FeatBW, CurrP, P),
    checkDF(DFs, CurrP, [(C,N)|P]).
checkDF([], _, _).

secOK(N1, N2, SecReqs) :-
    node(N1, _, _, SecCaps1, _), subset(SecReqs, SecCaps1),
    node(N2, _, _, SecCaps2, _), subset(SecReqs, SecCaps2).

bwOK(C, N, FeatBW, CurrP, P):-
    findall(BW, relevant(C, N, P, (_,_,_,BW,_)), BWs), sum_list(BWs, OkAllocBW), 
    findall(BW, relevant(C, N, CurrP, (_,_,_,BW,_)), CurrBWs), sum_list(CurrBWs, CurrAllocBW),
    bwTh(T), FeatBW + CurrAllocBW >= OkAllocBW + T.

findCompatibles([C|Cs], [(C,[Comp|Atibles])|Rest]):-
    findCompatibles(Cs, Rest),
    findall((N, Cost), lightNodeOK(C, N, Cost), [Comp|Atibles]).  
findCompatibles([],[]).

lightNodeOK(F, N, FCost) :-
    functionInstance(F, FId, _), function(FId, SWPlatform, (Arch, HWReqs)),
    node(N, SWCaps, (Arch, HWCaps), _, _),
    requirements(FId, N),
    member(SWPlatform, SWCaps), HWCaps >= HWReqs,
    nodeType(N, Type), cost(Type, F, FCost).
lightNodeOK(S, N, SCost) :-
    serviceInstance(S, SId), service(SId, SWReqs, (Arch, HWReqs)),
    node(N, SWCaps, (Arch, HWCaps), _, _),
    requirements(SId, N),
    subset(SWReqs, SWCaps), HWCaps >= HWReqs,
    nodeType(N, Type), cost(Type, S, SCost).