:-['requirements.pl', 'costs.pl'].

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
    findall(T, (node(_, _, _, _, IoTCaps), member(T, IoTCaps)), IoT),
    subset(Things, IoT).

findCompatibles([C|Cs], [(C,[Comp|Atibles])|Rest]):-
    findCompatibles(Cs, Rest),
    findall((N, Cost), lightNodeOK(C, N, Cost), [Comp|Atibles]).  
findCompatibles([],[]).

lightNodeOK(S, N, SCost) :-
    serviceInstance(S, SId), service(SId, SWReqs, (Arch, HWReqs)),
    node(N, SWCaps, (Arch, HWCaps), _, _),
    requirements(SId, N),
    subset(SWReqs, SWCaps), HWCaps >= HWReqs,
    nodeType(N, Type), cost(Type, S, SCost).

lightNodeOK(F, N, FCost) :-
    functionInstance(F, FId, _), function(FId, SWPlatform, (Arch, HWReqs)),
    node(N, SWCaps, (Arch, HWCaps), _, _),
    requirements(FId, N),
    member(SWPlatform, SWCaps), HWCaps >= HWReqs,
    nodeType(N, Type), cost(Type, F, FCost).