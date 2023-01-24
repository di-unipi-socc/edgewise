:-['data/infrs/infr128.pl', 'data/apps/speakToMe.pl'].

hwOnN(N, Ps, HW) :- serviceInstance(S, SId), service(SId,_,(_,HW)), member((S,N), Ps).
hwOnN(N, Ps, HW) :- functionInstance(F, FId,_), function(FId,_,(_,HW)), member((F,N), Ps).

hwAllocation([], _, AllocHW, AllocHW).
hwAllocation([N|Ns], P, OldHW, AllocHW) :-
    findall(HW, hwOnN(N, P, HW), HWs), sum_list(HWs, TotHW),
    hwAllocation(Ns, P, [(N, TotHW)|OldHW], AllocHW).

bwAllocation([], _, AllocBW, AllocBW).
bwAllocation([N1N2|N1N2s], Ps, OldBW, AllocBW) :-
    findall(BW, bwOnN1N2(N1N2, Ps, BW), BWs), sum_list(BWs, TotBW),
    bwAllocation(N1N2s, Ps, [(N1N2, TotBW)|OldBW], AllocBW).

bwOnN1N2((N1,N2), Ps, BW) :- 
    dataFlow(T1, T2, _, _, Size, Rate, _),
    (member((T1,N1), Ps); node(N1, _, _, _, _, IoTCaps), member(T1, IoTCaps)),
    (member((T2,N2), Ps); node(N2, _, _, _, _, IoTCaps), member(T2, IoTCaps)),
    BW is Size*Rate.
    

resourceAllocation(Ps, AllocHW, AllocBW) :-
    findall(N, member((_, N), Ps), Ns), sort(Ns, SNs), % sort to remove duplicates
    hwAllocation(SNs, Ps, [], AllocHW),
    findall(N1N2, relevantLink(N1N2, SNs), N1N2s),
    bwAllocation(N1N2s, Ps, [], AllocBW).


relevantLink((N1,N2), Ns) :- link(N1,N2,_,_), member(N1, Ns), member(N2, Ns), dif(N1,N2).
    

start(HW,BW) :- % testing predicate
    resourceAllocation([(textBucket,n105),(audioBucket,n105),(mainDB,n105),(convertTxt,n123),(uploadPost,n105),(uploadAudio,n105),(publishPost,n33),(converter,n123),(postQueue,n105),(metaPost,n123),(metaAudio,n123)], HW,BW).