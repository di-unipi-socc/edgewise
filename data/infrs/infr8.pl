bwTh(3).
hwTh(1).

node(n1, cloud, [ubuntu, mySQL, python, php, js, gcc], (x86, 1024), [enc, auth], []).
node(n4, isp, [ubuntu, gcc, python, js], (x86, 256), [enc], []).
node(n2, cabinet, [ubuntu, python, php, mySQL], (x86, 256), [enc, auth], []).
node(n0, cabinet, [php, mySQL], (arm64, 128), [enc, auth], []).
node(n5, accesspoint, [mySQL, gcc, js, python], (arm64, 64), [enc, auth], []).
node(n6, isp, [js, python, gcc, ubuntu], (x86, 256), [enc], []).
node(n7, cloud, [ubuntu, mySQL, python, php, js, gcc], (x86, 1024), [enc, auth], []).
node(n3, thing, [python], (arm64, 32), [enc, auth], []).

link(n0, n3, 15, 35).
link(n6, n7, 110, 1000).
link(n0, n5, 13, 50).
link(n2, n6, 25, 50).
link(n2, n4, 25, 50).
link(n0, n7, 135, 100).
link(n3, n4, 40, 50).
link(n0, n6, 25, 50).
link(n4, n5, 38, 50).
link(n5, n6, 38, 80).
link(n1, n5, 148, 20).
link(n0, n2, 20, 100).
link(n0, n4, 25, 50).
link(n0, n1, 135, 100).
link(n5, n7, 148, 50).

domain(all, [_]).

