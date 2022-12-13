resourceAllocation(Key, ReqRes, TAlloc, [(Key, NewRes)|Rest]) :-
    select((Key, Res), TAlloc, Rest), NewRes is Res+ReqRes.
resourceAllocation(Key, ReqRes, TAlloc, [(Key, ReqRes)|TAlloc]).

bwAllocation(N1, N2, ReqBW, TBW, [(N1, N2, NewBW)|BWs]) :-
    select((N1, N2, BW), TBW, BWs), NewBW is BW+ReqBW.
bwAllocation(N1, N2, ReqBW, TBW, [(N1, N2, ReqBW)|TBW]).

/*
hwAllocation(N, ReqHW, THW, [(N, NewHW)|Hws]) :-
    select((N,HW), THW, HWs), NewHW is HW+ReqHW.
hwAllocation(N, ReqHW, THW, [(N, ReqHW)|THW]).
*/

hwOnN(N, Ps, HW) :- serviceInstance(S, SId), service(SId,_,(_,HW)), member((S,N), Ps).
hwOnN(N, Ps, HW) :- functionInstance(F, FId,_), function(FId,_,(_,HW)), member((F,N), Ps).

hwAllocation([N|Ns], P, ) :-
    findall(HW, hwOnN(N, P, HW), HWs), sum_list(HWs,TotHW),
    hwAllocation([Ns], P, [()])

/*
hwAllocation(P,AllocHW) :-
    findall((N,HW), (member(on(T,N), P), (service(T,_,HW,_,_)), HWs),
    findall((N,SumHW), (group_by(N, HW, member((N,HW),HWs), Group), sumHW(Group, SumHW)), AllocHW).
*/

bwAllocation(P,AllocBW) :-
    findall()