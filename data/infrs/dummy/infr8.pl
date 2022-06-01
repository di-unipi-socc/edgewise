bwTh(3).
hwTh(1).

node(n1, isp, [ubuntu, mySQL], (x86, 512), [enc], []).
node(n2, isp, [ubuntu, mySQL], (arm64, 512), [enc], []).
node(n3, accesspoint, [ubuntu, gcc, python], (arm64, 128), [enc, auth], [echoDot]).
node(n7, cabinet, [ubuntu, mySQL], (arm64, 256), [enc], []).
node(n5, cloud, [ubuntu, mySQL, gcc, python], (arm64, 1024), [enc, auth], []).
node(n4, thing, [android, gcc, python], (x86, 64), [enc, auth], [iphoneXS]).
node(n0, cabinet, [ubuntu, mySQL], (arm64, 256), [enc], []).
node(n6, accesspoint, [ubuntu, gcc, python], (arm64, 128), [enc, auth], []).

link(n3, n2, 5, 700).
link(n5, n2, 5, 700).
link(n4, n7, 5, 700).
link(n6, n7, 5, 700).
link(n6, n0, 5, 700).
link(n5, n1, 5, 700).
link(n2, n7, 5, 700).
link(n5, n0, 5, 700).
link(n0, n3, 5, 700).
link(n1, n2, 5, 700).
link(n1, n3, 5, 700).
link(n7, n2, 5, 700).
link(n1, n5, 5, 700).
link(n3, n6, 5, 700).
link(n2, n0, 5, 700).
link(n4, n0, 5, 700).
link(n0, n6, 5, 700).
link(n4, n1, 5, 700).
link(n5, n4, 5, 700).
link(n5, n6, 5, 700).
link(n2, n6, 5, 700).
link(n7, n3, 5, 700).
link(n3, n4, 5, 700).
link(n7, n6, 5, 700).
link(n2, n3, 5, 700).
link(n6, n2, 5, 700).
link(n6, n4, 5, 700).
link(n0, n4, 5, 700).
link(n4, n6, 5, 700).
link(n0, n2, 5, 700).
link(n2, n4, 5, 700).
link(n0, n1, 5, 700).
link(n5, n3, 5, 700).
link(n1, n0, 5, 700).
link(n7, n4, 5, 700).
link(n5, n7, 5, 700).
link(n1, n4, 5, 700).
link(n6, n1, 5, 700).
link(n0, n5, 5, 700).
link(n3, n7, 5, 700).
link(n1, n7, 5, 700).
link(n4, n3, 5, 700).
link(n7, n0, 5, 700).
link(n2, n5, 5, 700).
link(n4, n5, 5, 700).
link(n0, n7, 5, 700).
link(n4, n2, 5, 700).
link(n2, n1, 5, 700).
link(n3, n1, 5, 700).
link(n6, n5, 5, 700).
link(n6, n3, 5, 700).
link(n7, n1, 5, 700).
link(n1, n6, 5, 700).
link(n3, n5, 5, 700).
link(n3, n0, 5, 700).
link(n7, n5, 5, 700).

domain(all, [_]).

