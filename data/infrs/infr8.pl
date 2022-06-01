bwTh(3).
hwTh(1).

node(n3, cabinet, [js, ubuntu], (x86, 256), [enc, auth], []).
node(n6, isp, [python, js], (arm64, 512), [enc], []).
node(n2, thing, [gcc], (x86, 64), [enc, auth], [nutrient]).
node(n4, accesspoint, [js, gcc, ubuntu, python], (arm64, 128), [enc, auth], [soil]).
node(n7, cabinet, [ubuntu, php, mySQL], (arm64, 256), [enc, auth], []).
node(n5, cloud, [ubuntu, mySQL, python, php, js, gcc], (arm64, 1024), [enc, auth], []).
node(n1, thing, [ubuntu], (arm64, 64), [enc, auth], [piCamera2]).
node(n0, cloud, [ubuntu, mySQL, python, php, js, gcc], (arm64, 1024), [enc, auth], []).

link(n5, n3, 135, 100).
link(n5, n7, 135, 100).
link(n7, n1, 15, 35).
link(n0, n3, 135, 100).
link(n6, n4, 38, 50).
link(n4, n7, 13, 80).
link(n2, n5, 150, 50).
link(n4, n3, 13, 80).
link(n2, n6, 40, 50).
link(n0, n5, 20, 1000).
link(n0, n6, 110, 1000).
link(n5, n6, 110, 1000).
link(n3, n0, 135, 100).
link(n3, n4, 13, 50).
link(n7, n4, 13, 50).
link(n7, n0, 135, 100).
link(n5, n4, 148, 20).
link(n4, n5, 148, 50).
link(n4, n6, 38, 80).
link(n1, n0, 150, 50).
link(n6, n1, 20, 1000).
link(n2, n1, 15, 50).
link(n6, n3, 25, 500).
link(n3, n5, 135, 100).
link(n2, n3, 15, 50).
link(n3, n7, 20, 100).
link(n6, n2, 20, 1000).
link(n3, n2, 15, 35).
link(n6, n0, 110, 1000).
link(n3, n6, 25, 50).
link(n0, n1, 150, 18).
link(n6, n7, 25, 500).
link(n4, n1, 2, 20).
link(n5, n1, 150, 18).
link(n7, n2, 15, 35).
link(n1, n4, 2, 20).
link(n1, n7, 15, 50).
link(n7, n3, 20, 100).
link(n4, n2, 2, 20).
link(n2, n0, 150, 50).
link(n5, n0, 20, 1000).
link(n0, n4, 148, 20).
link(n7, n6, 25, 50).
link(n5, n2, 150, 18).
link(n0, n2, 150, 18).
link(n1, n3, 15, 50).
link(n2, n7, 15, 50).
link(n7, n5, 135, 100).
link(n1, n6, 40, 50).
link(n1, n5, 150, 50).
link(n4, n0, 148, 50).
link(n1, n2, 15, 50).
link(n3, n1, 15, 35).
link(n6, n5, 110, 1000).
link(n2, n4, 2, 20).
link(n0, n7, 135, 100).

domain(all, [_]).

