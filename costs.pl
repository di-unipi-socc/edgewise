%:-['data/infr.pl', 'data/app.pl'].

cost(_, SIId, C) :-
    serviceInstance(SIId, SId),
    service(SId, _, SWReqs, (Arch, HW)),
    findall(C1, (unitCost(S, C1), member(S, SWReqs)), SWCosts), sum_list(SWCosts, SWCost),
    unitCost((Arch, HW), HWC), HWCost is HW*HWC,
    C is HWCost + SWCost.

% ProcCost and PerReqCost are provided.
cost(cloud, FIId, C) :-
    functionInstance(FIId, FId, (ReqXMonth, ReqDuration)),
    function(FId, _, _, (_, HWReqs)),
    Mbps is HWReqs * ReqXMonth * ReqDuration / 1000,  % total processing (Mb/s)
    CompCost is Mbps * 0.004, % monthly processing costs
    ReqCost is ReqXMonth * 0.000016, % monthly costs for requests

    C is CompCost + ReqCost. % total cost

cost(isp, FIId, C) :-
    functionInstance(FIId, FId, (ReqXMonth, ReqDuration)),
    function(FId, _, _, (_, HWReqs)),
    Mbps is HWReqs * ReqXMonth * ReqDuration / 1000,  % total processing (Mb/s)
    CompCost is Mbps * 0.005, % monthly processing costs
    ReqCost is ReqXMonth * 0.000017, % monthly costs for requests

    C is CompCost + ReqCost. % total cost

cost(cabinet, FIId, C) :-
    functionInstance(FIId, FId, (ReqXMonth, ReqDuration)),
    function(FId, _, _, (_, HWReqs)),
    Mbps is HWReqs * ReqXMonth * ReqDuration / 1000,  % total processing (Mb/s)
    CompCost is Mbps * 0.0006, % monthly processing costs
    ReqCost is ReqXMonth * 0.0000018, % monthly costs for requests

    C is CompCost + ReqCost. % total cost

cost(accesspoint, FIId, C) :-
    functionInstance(FIId, FId, (ReqXMonth, ReqDuration)),
    function(FId, _, _, (_, HWReqs)),
    Mbps is HWReqs * ReqXMonth * ReqDuration / 1000,  % total processing (Mb/s)
    CompCost is Mbps * 0.0007, % monthly processing costs
    ReqCost is ReqXMonth * 0.0000019, % monthly costs for requests

    C is CompCost + ReqCost. % total cost

cost(thing, FIId, C) :-
    functionInstance(FIId, FId, (ReqXMonth, ReqDuration)),
    function(FId, _, _, (_, HWReqs)),
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

weight(S, Rank) :- serviceInstance(S, SId), service(SId, _, _, (_, Rank)).
weight(F, Rank) :- functionInstance(F, FId, _), function(FId, _, _, (_, Rank)).


unitCost(ubuntu, 4).
unitCost(gcc, 4).
unitCost(python, 3).
unitCost(mySQL, 0.5).
unitCost((arm64, _), 0.005).
unitCost((x86, _), 0.003).

