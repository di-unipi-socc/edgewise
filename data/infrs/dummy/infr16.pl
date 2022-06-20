bwTh(3).
hwTh(1).

node(n9, thing, [mySQL, js, python], (arm64, 32), [enc, auth], [nutrient]).
node(n2, isp, [mySQL, ubuntu], (arm64, 512), [enc], []).
node(n13, accesspoint, [ubuntu, mySQL, gcc, js], (arm64, 64), [enc, auth], []).
node(n1, accesspoint, [gcc, js, python, ubuntu], (x86, 64), [enc, auth], [energy, echoDot]).
node(n10, cabinet, [ubuntu, mySQL, gcc], (arm64, 256), [enc, auth], [heat, arViewer]).
node(n11, thing, [ubuntu], (arm64, 32), [enc, auth], []).
node(n15, thing, [python, mySQL, js], (x86, 32), [enc, auth], []).
node(n8, cabinet, [js, ubuntu, gcc, python], (x86, 256), [enc, auth], [iphoneXS, cam21]).
node(n14, thing, [python, gcc, js], (arm64, 32), [enc, auth], []).
node(n12, cloud, [ubuntu, mySQL, python, js, gcc], (x86, 1024), [enc, auth], []).
node(n5, cloud, [ubuntu, mySQL, python, js, gcc], (arm64, 1024), [enc, auth], []).
node(n4, cabinet, [python, js], (arm64, 128), [enc, auth], [cam12]).
node(n3, thing, [js], (x86, 32), [enc, auth], [piCamera1, cam11]).
node(n7, isp, [js, python, gcc], (x86, 256), [enc], []).
node(n0, cabinet, [python, js], (x86, 256), [enc, auth], [water, cam22]).
node(n6, cabinet, [python, ubuntu], (arm64, 128), [enc, auth], [piCamera2, soil]).

link(n2, n13, 5, 700).
link(n0, n14, 5, 700).
link(n0, n6, 5, 700).
link(n8, n12, 5, 700).
link(n6, n10, 5, 700).
link(n6, n13, 5, 700).
link(n0, n1, 5, 700).
link(n0, n8, 5, 700).
link(n0, n2, 5, 700).
link(n1, n12, 5, 700).
link(n10, n13, 5, 700).
link(n10, n11, 5, 700).
link(n1, n5, 5, 700).
link(n12, n14, 5, 700).
link(n8, n9, 5, 700).
link(n6, n7, 5, 700).
link(n5, n7, 5, 700).
link(n0, n7, 5, 700).
link(n0, n3, 5, 700).
link(n4, n7, 5, 700).
link(n5, n13, 5, 700).
link(n2, n6, 5, 700).
link(n2, n5, 5, 700).
link(n4, n6, 5, 700).
link(n0, n5, 5, 700).
link(n6, n14, 5, 700).
link(n5, n10, 5, 700).
link(n7, n9, 5, 700).
link(n6, n9, 5, 700).
link(n2, n15, 5, 700).
link(n5, n6, 5, 700).
link(n5, n12, 5, 700).
link(n5, n8, 5, 700).
link(n6, n8, 5, 700).
link(n3, n14, 5, 700).
link(n1, n15, 5, 700).
link(n0, n9, 5, 700).
link(n9, n15, 5, 700).
link(n2, n11, 5, 700).
link(n5, n15, 5, 700).
link(n1, n11, 5, 700).
link(n9, n10, 5, 700).
link(n3, n11, 5, 700).
link(n0, n4, 5, 700).
link(n4, n5, 5, 700).
link(n2, n8, 5, 700).
link(n8, n10, 5, 700).
link(n2, n12, 5, 700).

domain(all, [_]).

