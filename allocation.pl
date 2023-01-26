:-['data/infrs/infr128.pl', 'data/apps/speakToMe.pl'].

:- set_prolog_flag(answer_write_options,[max_depth(0)]). % write answers' text entirely
:- set_prolog_flag(stack_limit, 32 000 000 000).
:- set_prolog_flag(last_call_optimisation, true).

resourceAllocation([], Alloc, Alloc).
resourceAllocation([(N, R)|Rs], OldAlloc, NewAlloc) :-
    select((N, OldRs), OldAlloc, Rest), NewRs is OldRs + R,
    resourceAllocation(Rs, [(N, NewRs)|Rest], NewAlloc).
resourceAllocation([(N, R)|Rs], OldAlloc, NewAlloc) :-
    \+ member((N, _), OldAlloc),
    resourceAllocation(Rs, [(N, R)|OldAlloc], NewAlloc).

allocatedResources(Ps, AllocHW, AllocBW) :-
    findall((N, HW), relevantNode(N, Ps, HW), HWs), 
    resourceAllocation(HWs, [], AllocHW), % hwAllocation(HWs, [], AllocHW),
    findall((N1N2, BW), relevantLink(N1N2, Ps, BW), BWs),
    resourceAllocation(BWs, [], AllocBW). % bwAllocation(BWs, [], AllocBW).

relevantNode(N, Ps, HW) :- serviceInstance(S, SId), service(SId,_,(_,HW)), member((S,N), Ps).
relevantNode(N, Ps, HW) :- functionInstance(F, FId,_), function(FId,_,(_,HW)), member((F,N), Ps).

relevantLink((N1,N2), Ps, BW) :- 
    dataFlow(T1, T2, _, _, Size, Rate, _),
    (member((T1,N1), Ps); node(N1, _, _, _, _, IoTCaps), member(T1, IoTCaps)),
    (member((T2,N2), Ps); node(N2, _, _, _, _, IoTCaps), member(T2, IoTCaps)),
    dif(N1,N2), link(N1,N2,_,_), BW is Size*Rate.

start(HW,BW) :- % testing predicate
    allocatedResources([(textBucket,n105),(audioBucket,n105),(mainDB,n105),(convertTxt,n123),(uploadPost,n105),(uploadAudio,n105),(publishPost,n33),(converter,n123),(postQueue,n105),(metaPost,n123),(metaAudio,n123)], HW,BW).