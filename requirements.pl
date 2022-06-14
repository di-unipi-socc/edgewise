% :-['data/infrs/infrUC.pl', 'data/apps/arFarming.pl'].

% requirements(Type,S,N) effettua
% un preprocessing "ad-hoc" per identificare il dominio dei nodi buoni per ogni servizio S, basandosi su:
% - banda media
% - requisiti di sicurezza
% - requisiti geografici (per ora, un dominio e il suo sottoalbero)
% - specialized HW (gpu, iot)
% - ...

requirements(_, S, N) :-
    serviceInstance(S, SId),
    service(SId, _, _),
    node(N, _, _, _, SecCaps, _),
    inDomain(N, all).

requirements(_, F, N) :-
    functionInstance(F, FId, _),
    function(FId, _, _),
    node(N, _, _, _, _, _),
    inDomain(N, all).

 % --- AUXILIARY PREDICATES ---
inDomain(Geo, D) :-
    domain(D, Areas), member(Geo, Areas).
inDomain(Geo, D) :-
    domain(D, Areas), member(SD, Areas), 
    inDomain(Geo, SD).

inBandwidth(N, InBw) :-
    findall(Bw, link(_,N,Bw,_), InBwList),
    avglist(InBwList, InBw).

outBandwidth(N, OutBw) :-
    findall(Bw, link(N,_,Bw,_), OutBwList),
    avglist(OutBwList, OutBw).

avglist(List, Average):- 
    sumlist(List, Sum),
    length(List, Length), Length > 0, 
    Average is Sum / Length.