% requirements(T,N) effettua
% un preprocessing "ad-hoc" per identificare il dominio dei nodi buoni per ogni servizio S, basandosi su:
% - banda media
% - requisiti di sicurezza
% - requisiti geografici (per ora, un dominio e il suo sottoalbero)
% - specialized HW (gpu, iot)
% - ...

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