% requirements(T,N) effettua
% - location(N, Loc), provider(N, Provider) nodeType(N, Type)
% - policy di sicurezza (SecFog) i.e. audit, antitampering, etc.
% - avg banda entrante/uscente
% - 

% requirements(Type, N)
requirements(_, _).

avg_list(List, Avg) :- length(List, N), sum_list(List, Sum), Avg is Sum / N.

avgInBW(N, AvgBW) :- findall(BW, link(_, N, _, BW), BWs), avg_list(BWs, AvgBW).
avgOutBW(N, AvgBW) :- findall(BW, link(N, _, _, BW), BWs), avg_list(BWs, AvgBW).