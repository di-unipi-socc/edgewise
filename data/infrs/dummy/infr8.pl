bwTh(5).
hwTh(2).

node(n1, accesspoint, [ubuntu, gcc, python], (x86, 128), [enc, auth], [echoDot]).
node(n6, isp, [ubuntu, mySQL], (arm64, 512), [enc], []).
node(n0, cabinet, [ubuntu, mySQL], (x86, 256), [enc], []).
node(n7, cabinet, [ubuntu, mySQL], (x86, 256), [enc], []).
node(n2, cloud, [ubuntu, mySQL, gcc, python], (x86, 1024), [enc, auth], []).
node(n5, cabinet, [ubuntu, mySQL], (arm64, 256), [enc], []).
node(n4, cabinet, [ubuntu, mySQL], (x86, 256), [enc], []).
node(n3, cabinet, [ubuntu, mySQL], (x86, 256), [enc], []).

link(n3, n7, 5, 700).
link(n0, n4, 5, 700).
link(n1, n2, 5, 700).
link(n6, n7, 5, 700).
link(n6, n3, 5, 700).
link(n4, n0, 5, 700).
link(n6, n0, 5, 700).
link(n7, n5, 5, 700).
link(n2, n4, 5, 700).
link(n0, n2, 5, 700).
link(n7, n3, 5, 700).
link(n4, n2, 5, 700).
link(n2, n0, 5, 700).
link(n4, n1, 5, 700).
link(n3, n0, 5, 700).
link(n1, n5, 5, 700).
link(n6, n4, 5, 700).
link(n7, n6, 5, 700).
link(n5, n1, 5, 700).
link(n1, n4, 5, 700).
link(n7, n1, 5, 700).
link(n7, n4, 5, 700).
link(n5, n7, 5, 700).
link(n0, n1, 5, 700).
link(n6, n5, 5, 700).
link(n3, n1, 5, 700).
link(n5, n6, 5, 700).
link(n3, n6, 5, 700).
link(n2, n7, 5, 700).
link(n0, n3, 5, 700).
link(n1, n6, 5, 700).
link(n3, n4, 5, 700).
link(n6, n1, 5, 700).
link(n0, n6, 5, 700).
link(n5, n3, 5, 700).
link(n3, n5, 5, 700).
link(n4, n6, 5, 700).
link(n2, n6, 5, 700).
link(n5, n0, 5, 700).
link(n5, n4, 5, 700).
link(n1, n7, 5, 700).
link(n6, n2, 5, 700).
link(n4, n3, 5, 700).
link(n7, n0, 5, 700).
link(n2, n5, 5, 700).
link(n1, n0, 5, 700).
link(n3, n2, 5, 700).
link(n2, n3, 5, 700).
link(n7, n2, 5, 700).
link(n4, n7, 5, 700).
link(n0, n5, 5, 700).
link(n4, n5, 5, 700).
link(n1, n3, 5, 700).
link(n2, n1, 5, 700).
link(n5, n2, 5, 700).
link(n0, n7, 5, 700).

domain(all, [_]).

