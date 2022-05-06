bwTh(5).
hwTh(2).

node(n6, thing, [android, gcc, python], (arm64, 64), [enc, auth], []).
node(n5, isp, [ubuntu, mySQL], (arm64, 512), [enc], []).
node(n3, thing, [android, gcc, python], (arm64, 64), [enc, auth], [iphoneXS]).
node(n2, cabinet, [ubuntu, mySQL], (arm64, 256), [enc], []).
node(n4, thing, [android, gcc, python], (arm64, 64), [enc, auth], []).
node(n0, accesspoint, [ubuntu, gcc, python], (x86, 128), [enc, auth], [echoDot]).
node(n7, isp, [ubuntu, mySQL], (x86, 512), [enc], []).
node(n1, isp, [ubuntu, mySQL], (arm64, 512), [enc], []).

link(n7,n2,25,500).
link(n0,n7,38,80).
link(n1,n2,25,500).
link(n0,n3,2,20).
link(n0,n5,38,80).
link(n6,n4,15,50).
link(n2,n5,25,50).
link(n7,n5,20,1000).
link(n4,n3,15,50).
link(n2,n7,25,50).
link(n1,n5,20,1000).
link(n2,n0,13,50).
link(n0,n2,13,80).
link(n7,n4,20,1000).
link(n1,n4,20,1000).
link(n1,n7,20,1000).
link(n4,n5,40,50).
link(n4,n6,15,50).
link(n1,n3,20,1000).
link(n4,n0,2,20).
link(n2,n4,15,35).
link(n5,n6,20,1000).
link(n0,n1,38,80).
link(n6,n7,40,50).
link(n7,n3,20,1000).
link(n1,n6,20,1000).
link(n6,n3,15,50).
link(n5,n0,38,50).
link(n4,n1,40,50).
link(n5,n4,20,1000).
link(n6,n1,40,50).
link(n7,n1,20,1000).
link(n7,n0,38,50).
link(n6,n0,2,20).
link(n0,n6,2,20).
link(n6,n5,40,50).
link(n4,n7,40,50).
link(n0,n4,2,20).
link(n5,n2,25,500).
link(n2,n6,15,35).
link(n3,n5,40,50).
link(n3,n7,40,50).
link(n4,n2,15,50).
link(n3,n0,2,20).
link(n3,n2,15,50).
link(n2,n3,15,35).
link(n2,n1,25,50).
link(n6,n2,15,50).
link(n3,n1,40,50).
link(n5,n3,20,1000).
link(n1,n0,38,50).
link(n3,n4,15,50).
link(n5,n7,20,1000).
link(n7,n6,20,1000).
link(n3,n6,15,50).
link(n5,n1,20,1000).

domain(all, [_]).

