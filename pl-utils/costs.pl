 % :-['data/infrs/infrUC.pl', 'data/apps/arFarming.pl'].

cost(NType, SIId, C) :-
    serviceInstance(SIId, SId),
    service(SId, SWReqs, (Arch, HW)),
    findall(C1, (unitCost(S, NType, C1), member(S, SWReqs)), SWCosts), sum_list(SWCosts, SWCost),
    unitCost(Arch, NType, HWC), HWCost is HW*HWC,
    C is HWCost + SWCost.

% ProcCost and PerReqCost are provided.
cost(cloud, FIId, C) :-
    functionInstance(FIId, FId, (ReqXMonth, ReqDuration)),
    function(FId, _, (_, HWReqs)),
    Mbps is HWReqs * ReqXMonth * ReqDuration / 1000,  % total processing (Mb/s)
    CompCost is Mbps * 0.004, % monthly processing costs
    ReqCost is ReqXMonth * 0.000016, % monthly costs for requests

    C is CompCost + ReqCost. % total cost

cost(edge, FIId, C) :-
    functionInstance(FIId, FId, (ReqXMonth, ReqDuration)),
    function(FId, _, (_, HWReqs)),
    Mbps is HWReqs * ReqXMonth * ReqDuration / 1000,  % total processing (Mb/s)
    CompCost is Mbps * 0.0006, % monthly processing costs
    ReqCost is ReqXMonth * 0.0000018, % monthly costs for requests

    C is CompCost + ReqCost. % total cost

cost(thing, FIId, C) :-
    functionInstance(FIId, FId, (ReqXMonth, ReqDuration)),
    function(FId, _, (_, HWReqs)),
    Mbps is HWReqs * ReqXMonth * ReqDuration / 1000,  % total processing (Mb/s)
    CompCost is Mbps * 0.0008, % monthly processing costs
    ReqCost is ReqXMonth * 0.000002, % monthly costs for requests

    C is CompCost + ReqCost. % total cost


ranking(Functions, Services, RankedComps) :- 
    append(Functions, Services, Components), 
    rank(Components, [], RankedComps).

rank([C|Cs], Pairs, RankedComps) :- 
    weight(C,R), rank(Cs, [(R,C)|Pairs], RankedComps).
rank([], Pairs, RankedComps) :- sort(Pairs, RankedComps).

weight(S, Rank) :- serviceInstance(S, SId), service(SId, _, (_, Rank)).
weight(F, Rank) :- functionInstance(F, FId, _), function(FId, _, (_, Rank)).


% unitCost(Cap, NType, Cost).
% SOFTWARE
unitCost(ubuntu, cloud, 5.524).
unitCost(ubuntu, isp, 2.826).
unitCost(ubuntu, cabinet, 0.987).
unitCost(ubuntu, accesspoint, 0.505).
unitCost(ubuntu, thing, 0.26).

unitCost(python, cloud, 4.608).
unitCost(python, isp, 2.304).
unitCost(python, cabinet, 0.768).
unitCost(python, accesspoint, 0.384).
unitCost(python, thing, 0.192).

unitCost(gcc, cloud, 19.347).
unitCost(gcc, isp, 10.656).
unitCost(gcc, cabinet, 5.558).
unitCost(gcc, accesspoint, 2.686).
unitCost(gcc, thing, 1.544).

unitCost(mySQL, cloud, 3.2).
unitCost(mySQL, isp, 2.25).
unitCost(mySQL, cabinet, 0.8).
unitCost(mySQL, accesspoint, 0.4).
unitCost(mySQL, thing, 0.2).

% HARDWARE
unitCost(arm64, cloud, 3.226).
unitCost(arm64, isp, 1.848).
unitCost(arm64, cabinet, 0.616).
unitCost(arm64, accesspoint, 0.308).
unitCost(arm64, thing, 0.154).

unitCost(x86, cloud, 7.104).
unitCost(x86, isp, 3.552).
unitCost(x86, cabinet, 0.928).
unitCost(x86, accesspoint, 0.464).
unitCost(x86, thing, 0.232).
