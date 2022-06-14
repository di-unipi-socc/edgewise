resourceAllocation(Key, ReqRes, TAlloc, [(Key, NewRes)|Rest]) :-
    select((Key, Res), TAlloc, Rest), NewRes is Res+ReqRes.
resourceAllocation(Key, ReqRes, TAlloc, [(Key, ReqRes)|TAlloc]).

bwAllocation(N1, N2, ReqBW, TBW, [(N1, N2, NewBW)|BWs]) :-
    select((N1, N2, BW), TBW, BWs), NewBW is BW+ReqBW.
bwAllocation(N1, N2, ReqBW, TBW, [(N1, N2, ReqBW)|TBW]).

hwAllocation(N, ReqHW, THW, [(N, NewHW)|Hws]) :-
    select((N,HW), THW, HWs), NewHW is HW+ReqHW.
hwAllocation(N, ReqHW, THW, [(N, ReqHW)|THW]).