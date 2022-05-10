bwTh(5).
hwTh(2).

node(n5, cloud, [ubuntu, mySQL, gcc, python], (arm64, 1024), [enc, auth], []).
node(n0, cabinet, [ubuntu, mySQL], (arm64, 256), [enc], []).
node(n1, accesspoint, [ubuntu, gcc, python], (x86, 128), [enc, auth], [echoDot]).
node(n3, isp, [ubuntu, mySQL], (x86, 512), [enc], []).
node(n4, isp, [ubuntu, mySQL], (arm64, 512), [enc], []).
node(n7, thing, [android, gcc, python], (x86, 64), [enc, auth], []).
node(n6, cabinet, [ubuntu, mySQL], (arm64, 256), [enc], []).
node(n2, thing, [android, gcc, python], (x86, 64), [enc, auth], [iphoneXS]).

link(n6, n5, 135, 100).
link(n5, n6, 135, 100).
link(n1, n5, 148, 50).
link(n6, n2, 15, 35).
link(n4, n6, 25, 500).
link(n6, n7, 15, 35).
link(n1, n7, 2, 20).
link(n7, n1, 2, 20).
link(n1, n4, 38, 80).
link(n3, n6, 25, 500).
link(n0, n2, 15, 35).
link(n7, n5, 150, 50).
link(n2, n1, 2, 20).
link(n0, n7, 15, 35).
link(n6, n3, 25, 50).
link(n7, n0, 15, 50).
link(n7, n6, 15, 50).
link(n5, n7, 150, 18).
link(n4, n3, 20, 1000).
link(n4, n2, 20, 1000).
link(n0, n6, 20, 100).
link(n2, n6, 15, 50).
link(n4, n5, 110, 1000).
link(n1, n6, 13, 80).
link(n5, n1, 148, 20).
link(n1, n3, 38, 80).
link(n5, n3, 110, 1000).
link(n0, n4, 25, 50).
link(n0, n5, 135, 100).
link(n3, n0, 25, 500).
link(n4, n0, 25, 500).
link(n3, n5, 110, 1000).
link(n5, n4, 110, 1000).
link(n5, n2, 150, 18).
link(n3, n1, 38, 50).
link(n6, n0, 20, 100).
link(n0, n3, 25, 50).
link(n0, n1, 13, 50).
link(n3, n4, 20, 1000).
link(n7, n2, 15, 50).
link(n5, n0, 135, 100).
link(n1, n2, 2, 20).
link(n2, n0, 15, 50).
link(n6, n4, 25, 50).
link(n2, n4, 40, 50).
link(n4, n7, 20, 1000).
link(n2, n3, 40, 50).
link(n1, n0, 13, 80).
link(n7, n4, 40, 50).
link(n2, n7, 15, 50).
link(n4, n1, 38, 50).
link(n3, n2, 20, 1000).
link(n7, n3, 40, 50).
link(n6, n1, 13, 50).
link(n3, n7, 20, 1000).
link(n2, n5, 150, 50).

domain(all, [_]).

