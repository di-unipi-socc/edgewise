:- use_module(library(clpr)).

schedule(Schedule, FinTime) :-
    tasks(TasksDurs),
    precedence_constr(TasksDurs, Schedule, FinTime),
    writeln(FinTime),
    minimize(FinTime).

precedence_constr([],[],_).
precedence_constr([(T,D)|TDs], [(T,Start,D)|Rest], FinTime) :-
    {Start >= 0,
    Start + D =< FinTime},
    precedence_constr(TDs, Rest, FinTime),
    prec_constr((T,Start,D), Rest).

prec_constr(_, []).
prec_constr((T,S,D), [(T1,S1,D1)|Rest]) :-
    (prec(T, T1), !, {S+D =< S1}
    ;
    prec(T1, T), !, {S1+D1 =< S}
    ;
    true),
    prec_constr((T,S,D), Rest).

tasks([(t1,5), (t2, 7), (t3,10), (t4,2), (t5, 9)]).
prec(t1,t2). 
prec(t1,t4). 
prec(t2,t3). 
prec(t4,t5).