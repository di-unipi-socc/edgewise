:-['data/infrs/infr128.pl', 'data/apps/speakToMe.pl'].

hwOnN(N, Ps, HW) :- serviceInstance(S, SId), service(SId,_,(_,HW)), member((S,N), Ps).
hwOnN(N, Ps, HW) :- functionInstance(F, FId,_), function(FId,_,(_,HW)), member((F,N), Ps).

hwAllocation([], _, AllocHW, AllocHW).
hwAllocation([N|Ns], P, OldHW, AllocHW) :-
    findall(HW, hwOnN(N, P, HW), HWs), sum_list(HWs, TotHW),
    hwAllocation(Ns, P, [(N, TotHW)|OldHW], AllocHW).

bwOnN((N1,N2), Ps, BW) :- 
    dataFlow(T1, T2, _, _, Size, Rate, _),
    (member((T1,N1), Ps); node(N1, _, _, _, _, IoTCaps), member(T1, IoTCaps)),
    (member((T2,N2), Ps); node(N2, _, _, _, _, IoTCaps), member(T2, IoTCaps)),
    BW is Size*Rate.

resourceAllocation(Ps, AllocHW, AllocBW) :-
    findall(N, distinct(member((_, N), Ps)), Ns),
    hwAllocation(Ns, Ps, [], AllocHW), AllocBW = [].

start(HW,BW) :- % testing predicate
    resourceAllocation([(textBucket,n105),(audioBucket,n105),(mainDB,n105),(convertTxt,n123),(uploadPost,n105),(uploadAudio,n105),(publishPost,n33),(converter,n123),(postQueue,n105),(metaPost,n123),(metaAudio,n123)], HW,BW).