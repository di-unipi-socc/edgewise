bwTh(3).
hwTh(1).

node(n1, cabinet, [ubuntu, js], (arm64, 128), [enc, auth], []).
node(n4, thing, [gcc, python], (arm64, 32), [enc, auth], []).
node(n2, thing, [mySQL], (x86, 32), [enc, auth], []).
node(n6, cabinet, [gcc, ubuntu], (arm64, 128), [enc, auth], []).
node(n0, thing, [ubuntu], (x86, 32), [enc, auth], []).
node(n7, accesspoint, [mySQL, php, ubuntu, python], (arm64, 64), [enc, auth], []).
node(n3, cloud, [ubuntu, mySQL, python, php, js, gcc], (arm64, 1024), [enc, auth], []).
node(n5, accesspoint, [ubuntu, php], (x86, 64), [enc, auth], []).

link(n3, n4, 5, 700).
link(n0, n1, 5, 700).
link(n0, n5, 5, 700).
link(n4, n5, 5, 700).
link(n1, n7, 5, 700).
link(n0, n3, 5, 700).
link(n1, n5, 5, 700).
link(n2, n6, 5, 700).
link(n0, n4, 5, 700).
link(n5, n7, 5, 700).
link(n4, n6, 5, 700).
link(n1, n4, 5, 700).
link(n0, n2, 5, 700).
link(n0, n6, 5, 700).
link(n4, n7, 5, 700).

domain(all, [_]).

