bwTh(3).
hwTh(1).

node(n1, accesspoint, [js, gcc], (arm64, 64), [enc, auth], [water]).
node(n14, cloud, [ubuntu, mySQL, python, js, gcc], (x86, 1024), [enc, auth], []).
node(n10, isp, [js, python, mySQL, gcc], (x86, 512), [enc], []).
node(n0, accesspoint, [python, js, gcc], (arm64, 64), [enc, auth], [echoDot, soil]).
node(n13, cabinet, [gcc, ubuntu, python], (arm64, 128), [enc, auth], []).
node(n7, thing, [js], (arm64, 32), [enc, auth], [cam12]).
node(n3, accesspoint, [python, gcc, ubuntu], (arm64, 64), [enc, auth], [nutrient, arViewer]).
node(n15, cabinet, [gcc, python, ubuntu, mySQL], (arm64, 256), [enc, auth], []).
node(n5, cabinet, [mySQL, python], (x86, 128), [enc, auth], [heat, cam21]).
node(n12, cabinet, [ubuntu, js], (arm64, 128), [enc, auth], [piCamera1, iphoneXS]).
node(n6, cabinet, [js, ubuntu], (arm64, 128), [enc, auth], [cam11, piCamera2]).
node(n11, cloud, [ubuntu, mySQL, python, js, gcc], (x86, 1024), [enc, auth], []).
node(n8, isp, [python, js, ubuntu, mySQL], (x86, 256), [enc], []).
node(n2, cloud, [ubuntu, mySQL, python, js, gcc], (arm64, 1024), [enc, auth], []).
node(n9, cabinet, [python, ubuntu], (x86, 256), [enc, auth], [cam22]).
node(n4, accesspoint, [python, gcc, js], (x86, 64), [enc, auth], [energy]).

link(n0, n15, 13, 80).
link(n0, n7, 2, 20).
link(n0, n9, 13, 80).
link(n0, n11, 148, 50).
link(n0, n2, 148, 50).
link(n0, n3, 10, 10).
link(n0, n13, 13, 80).
link(n0, n10, 38, 80).
link(n0, n8, 38, 80).
link(n0, n5, 13, 80).
link(n0, n12, 13, 80).
link(n0, n6, 13, 80).
link(n0, n14, 148, 50).
link(n0, n4, 10, 10).
link(n0, n1, 10, 10).

domain(all, [_]).

