bwTh(5).
hwTh(2).

node(n0, thing, [android, gcc, python], (arm64, 64), [enc, auth], [iphoneXS]).
node(n1, cabinet, [ubuntu, mySQL], (x86, 256), [enc], []).
node(n2, thing, [android, gcc, python], (arm64, 64), [enc, auth], [echoDot]).
node(n3, cabinet, [ubuntu, mySQL], (arm64, 256), [enc], []).
node(n4, isp, [ubuntu, mySQL], (arm64, 512), [enc], []).
node(n5, thing, [android, gcc, python], (arm64, 64), [enc, auth], []).
node(n6, cloud, [ubuntu, mySQL, gcc, python], (arm64, 1024), [enc, auth], []).
node(n7, accesspoint, [ubuntu, gcc, python], (x86, 128), [enc, auth], []).

link(n0,n1,10,70).
link(n0,n2,10,70).
link(n0,n3,10,70).
link(n0,n4,10,70).
link(n0,n5,10,70).
link(n0,n6,10,70).
link(n0,n7,10,70).
link(n1,n0,10,70).
link(n1,n2,10,70).
link(n1,n3,10,70).
link(n1,n4,10,70).
link(n1,n5,10,70).
link(n1,n6,10,70).
link(n1,n7,10,70).
link(n2,n0,10,70).
link(n2,n1,10,70).
link(n2,n3,10,70).
link(n2,n4,10,70).
link(n2,n5,10,70).
link(n2,n6,10,70).
link(n2,n7,10,70).
link(n3,n0,10,70).
link(n3,n1,10,70).
link(n3,n2,10,70).
link(n3,n4,10,70).
link(n3,n5,10,70).
link(n3,n6,10,70).
link(n3,n7,10,70).
link(n4,n0,10,70).
link(n4,n1,10,70).
link(n4,n2,10,70).
link(n4,n3,10,70).
link(n4,n5,10,70).
link(n4,n6,10,70).
link(n4,n7,10,70).
link(n5,n0,10,70).
link(n5,n1,10,70).
link(n5,n2,10,70).
link(n5,n3,10,70).
link(n5,n4,10,70).
link(n5,n6,10,70).
link(n5,n7,10,70).
link(n6,n0,10,70).
link(n6,n1,10,70).
link(n6,n2,10,70).
link(n6,n3,10,70).
link(n6,n4,10,70).
link(n6,n5,10,70).
link(n6,n7,10,70).
link(n7,n0,10,70).
link(n7,n1,10,70).
link(n7,n2,10,70).
link(n7,n3,10,70).
link(n7,n4,10,70).
link(n7,n5,10,70).
link(n7,n6,10,70).

domain(all, [_]).

