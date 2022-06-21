%:-['../data/infrs/infr8.pl', '../data/apps/arFarming.pl'].
:-['../requirements.pl', '../costs.pl'].

:- set_prolog_flag(answer_write_options,[max_depth(0)]). % write answers' text entirely
:- set_prolog_flag(stack_limit, 32 000 000 000).
:- set_prolog_flag(last_call_optimisation, true).

preprocess(App, Compatibles) :-
    application(App, Functions, Services), 
    checkThings,
    append(Functions, Services, Components),
    findCompatibles(Components, Compatibles).

checkThings :-
    findall(T, thingInstance(T, _), Things),
    findall(T, (node(_, _, _, _, _, IoTCaps), member(T, IoTCaps)), IoT),
    subset(Things, IoT).

findCompatibles([C|Cs], [(C,Compatibles)|Rest]):-
    findCompatibles(Cs, Rest),
    findall((N, Cost), lightNodeOK(C, N, Cost), Compatibles).  
findCompatibles([],[]).

lightNodeOK(S, N, SCost) :-
    serviceInstance(S, SId),
    service(SId, SWReqs, (Arch, HWReqs)),
    node(N, NType, SWCaps, (Arch, HWCaps), _, _),
    subset(SWReqs, SWCaps), 
    HWCaps >= HWReqs,
    % requirements(SId, S, N),
    cost(NType, S, SCost).

lightNodeOK(F, N, FCost) :-
    functionInstance(F, FId, _), 
    function(FId, SWPlatform, (Arch, HWReqs)),
    node(N, NType, SWCaps, (Arch, HWCaps), _, _),
    member(SWPlatform, SWCaps),
    HWCaps >= HWReqs,
    % requirements(FId, F, N),
    cost(NType, F, FCost).