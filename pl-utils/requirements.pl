% requirements(T,N) effettua
% - aggiungere fatti location(N, Loc), provider(n, Provider) nodeType(N, Type) per ogni nodo nel file infr.pl
% - policy di sicurezza (SecFog) i.e. audit, antitampering, etc.
% - avg banda entrante/uscente
% - 

requirements(database, N) :-
    node(N, _, _, _, _, _),

    inDomain(N, uc_datacenter).

requirements(queue, N) :-
    node(N, _, _, _, _, _),
    inDomain(N, uc_halls).

requirements(_, _).


 % --- AUXILIARY PREDICATES ---
inDomain(Geo, D) :-
    domain(D, Areas), member(Geo, Areas).
inDomain(Geo, D) :-
    domain(D, Areas), member(SD, Areas), 
    inDomain(Geo, SD).