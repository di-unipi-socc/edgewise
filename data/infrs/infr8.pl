bwTh(3).
hwTh(1).

node(n2, accesspoint, [ubuntu, gcc, python], (arm64, 128), [enc, auth], [echoDot]).
node(n1, isp, [ubuntu, mySQL], (x86, 512), [enc], []).
node(n0, isp, [ubuntu, mySQL], (arm64, 512), [enc], []).
node(n3, isp, [ubuntu, mySQL], (x86, 512), [enc], []).
node(n4, cabinet, [ubuntu, mySQL], (arm64, 256), [enc], []).
node(n7, cabinet, [ubuntu, mySQL], (arm64, 256), [enc], []).
node(n5, thing, [android, gcc, python], (x86, 64), [enc, auth], [iphoneXS]).
node(n6, isp, [ubuntu, mySQL], (x86, 512), [enc], []).

link(n1, n4, 25, 500).
link(n1, n5, 20, 1000).
link(n0, n3, 20, 1000).
link(n2, n1, 38, 80).
link(n5, n4, 15, 50).
link(n4, n5, 15, 35).
link(n7, n4, 20, 100).
link(n3, n0, 20, 1000).
link(n2, n4, 13, 80).
link(n7, n3, 25, 50).
link(n6, n2, 38, 50).
link(n7, n0, 25, 50).
link(n3, n7, 25, 500).
link(n6, n4, 25, 500).
link(n5, n3, 40, 50).
link(n7, n2, 13, 50).
link(n6, n5, 20, 1000).
link(n3, n4, 25, 500).
link(n7, n6, 25, 50).
link(n7, n5, 15, 35).
link(n1, n6, 20, 1000).
link(n4, n0, 25, 50).
link(n1, n2, 38, 50).
link(n4, n6, 25, 50).
link(n2, n7, 13, 80).
link(n0, n7, 25, 500).
link(n5, n7, 15, 50).
link(n5, n2, 2, 20).
link(n5, n1, 40, 50).
link(n2, n3, 38, 80).
link(n7, n1, 25, 50).
link(n1, n7, 25, 500).
link(n6, n0, 20, 1000).
link(n4, n7, 20, 100).
link(n4, n3, 25, 50).
link(n1, n3, 20, 1000).
link(n6, n3, 20, 1000).
link(n2, n5, 2, 20).
link(n5, n6, 40, 50).
link(n2, n6, 38, 80).
link(n0, n5, 20, 1000).
link(n0, n4, 25, 500).
link(n1, n0, 20, 1000).
link(n0, n2, 38, 50).
link(n2, n0, 38, 80).
link(n0, n6, 20, 1000).
link(n0, n1, 20, 1000).
link(n3, n1, 20, 1000).
link(n6, n7, 25, 500).
link(n5, n0, 40, 50).
link(n4, n2, 13, 50).
link(n3, n2, 38, 50).
link(n3, n6, 20, 1000).
link(n4, n1, 25, 50).
link(n3, n5, 20, 1000).
link(n6, n1, 20, 1000).

domain(all, [_]).

