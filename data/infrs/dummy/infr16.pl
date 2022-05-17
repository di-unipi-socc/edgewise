bwTh(3).
hwTh(1).

node(n14, cabinet, [ubuntu, mySQL], (x86, 256), [enc], []).
node(n11, isp, [ubuntu, mySQL], (arm64, 512), [enc], []).
node(n4, thing, [android, gcc, python], (arm64, 64), [enc, auth], []).
node(n8, thing, [android, gcc, python], (x86, 64), [enc, auth], []).
node(n13, accesspoint, [ubuntu, gcc, python], (x86, 128), [enc, auth], []).
node(n9, cabinet, [ubuntu, mySQL], (arm64, 256), [enc], []).
node(n6, cloud, [ubuntu, mySQL, gcc, python], (arm64, 1024), [enc, auth], []).
node(n15, thing, [android, gcc, python], (x86, 64), [enc, auth], []).
node(n5, cabinet, [ubuntu, mySQL], (arm64, 256), [enc], []).
node(n1, cabinet, [ubuntu, mySQL], (x86, 256), [enc], []).
node(n12, thing, [android, gcc, python], (arm64, 64), [enc, auth], []).
node(n7, cabinet, [ubuntu, mySQL], (arm64, 256), [enc], []).
node(n10, cabinet, [ubuntu, mySQL], (arm64, 256), [enc], []).
node(n0, accesspoint, [ubuntu, gcc, python], (x86, 128), [enc, auth], [iphoneXS]).
node(n2, cabinet, [ubuntu, mySQL], (x86, 256), [enc], []).
node(n3, thing, [android, gcc, python], (arm64, 64), [enc, auth], [echoDot]).

link(n1, n6, 5, 700).
link(n8, n2, 5, 700).
link(n3, n0, 5, 700).
link(n10, n7, 5, 700).
link(n15, n3, 5, 700).
link(n9, n3, 5, 700).
link(n7, n8, 5, 700).
link(n12, n9, 5, 700).
link(n2, n6, 5, 700).
link(n1, n5, 5, 700).
link(n11, n8, 5, 700).
link(n1, n14, 5, 700).
link(n14, n15, 5, 700).
link(n0, n9, 5, 700).
link(n14, n8, 5, 700).
link(n10, n2, 5, 700).
link(n8, n0, 5, 700).
link(n4, n15, 5, 700).
link(n8, n14, 5, 700).
link(n2, n15, 5, 700).
link(n5, n10, 5, 700).
link(n14, n11, 5, 700).
link(n11, n5, 5, 700).
link(n15, n13, 5, 700).
link(n2, n12, 5, 700).
link(n8, n4, 5, 700).
link(n15, n14, 5, 700).
link(n14, n9, 5, 700).
link(n8, n15, 5, 700).
link(n1, n2, 5, 700).
link(n1, n11, 5, 700).
link(n9, n15, 5, 700).
link(n6, n7, 5, 700).
link(n3, n14, 5, 700).
link(n10, n6, 5, 700).
link(n13, n4, 5, 700).
link(n3, n6, 5, 700).
link(n10, n5, 5, 700).
link(n13, n8, 5, 700).
link(n3, n1, 5, 700).
link(n2, n9, 5, 700).
link(n4, n5, 5, 700).
link(n10, n15, 5, 700).
link(n11, n4, 5, 700).
link(n1, n7, 5, 700).
link(n4, n1, 5, 700).
link(n9, n10, 5, 700).
link(n0, n10, 5, 700).
link(n15, n1, 5, 700).
link(n13, n12, 5, 700).
link(n2, n4, 5, 700).
link(n5, n3, 5, 700).
link(n11, n7, 5, 700).
link(n8, n13, 5, 700).
link(n13, n9, 5, 700).
link(n9, n13, 5, 700).
link(n13, n5, 5, 700).
link(n3, n8, 5, 700).
link(n8, n5, 5, 700).
link(n15, n12, 5, 700).
link(n10, n8, 5, 700).
link(n12, n6, 5, 700).
link(n2, n8, 5, 700).
link(n5, n8, 5, 700).
link(n4, n6, 5, 700).
link(n0, n4, 5, 700).
link(n3, n4, 5, 700).
link(n0, n11, 5, 700).
link(n14, n7, 5, 700).
link(n14, n12, 5, 700).
link(n0, n7, 5, 700).
link(n14, n3, 5, 700).
link(n4, n11, 5, 700).
link(n5, n13, 5, 700).
link(n1, n13, 5, 700).
link(n0, n12, 5, 700).
link(n2, n0, 5, 700).
link(n13, n6, 5, 700).
link(n13, n2, 5, 700).
link(n12, n7, 5, 700).
link(n13, n14, 5, 700).
link(n3, n15, 5, 700).
link(n5, n15, 5, 700).
link(n6, n0, 5, 700).
link(n11, n2, 5, 700).
link(n4, n9, 5, 700).
link(n15, n2, 5, 700).
link(n3, n13, 5, 700).
link(n2, n13, 5, 700).
link(n9, n1, 5, 700).
link(n7, n0, 5, 700).
link(n5, n9, 5, 700).
link(n7, n9, 5, 700).
link(n8, n7, 5, 700).
link(n2, n11, 5, 700).
link(n10, n0, 5, 700).
link(n5, n0, 5, 700).
link(n14, n13, 5, 700).
link(n12, n1, 5, 700).
link(n9, n5, 5, 700).
link(n15, n10, 5, 700).
link(n5, n2, 5, 700).
link(n1, n0, 5, 700).
link(n2, n10, 5, 700).
link(n6, n15, 5, 700).
link(n6, n3, 5, 700).
link(n14, n6, 5, 700).
link(n12, n2, 5, 700).
link(n10, n12, 5, 700).
link(n11, n14, 5, 700).
link(n3, n2, 5, 700).
link(n13, n1, 5, 700).
link(n10, n13, 5, 700).
link(n12, n5, 5, 700).
link(n2, n1, 5, 700).
link(n11, n12, 5, 700).
link(n7, n10, 5, 700).
link(n8, n1, 5, 700).
link(n4, n8, 5, 700).
link(n11, n1, 5, 700).
link(n5, n4, 5, 700).
link(n0, n14, 5, 700).
link(n0, n8, 5, 700).
link(n0, n3, 5, 700).
link(n9, n6, 5, 700).
link(n12, n15, 5, 700).
link(n4, n2, 5, 700).
link(n8, n6, 5, 700).
link(n6, n11, 5, 700).
link(n10, n3, 5, 700).
link(n6, n14, 5, 700).
link(n14, n5, 5, 700).
link(n6, n5, 5, 700).
link(n9, n12, 5, 700).
link(n15, n0, 5, 700).
link(n14, n10, 5, 700).
link(n1, n4, 5, 700).
link(n15, n11, 5, 700).
link(n13, n15, 5, 700).
link(n11, n9, 5, 700).
link(n8, n10, 5, 700).
link(n6, n4, 5, 700).
link(n11, n10, 5, 700).
link(n6, n1, 5, 700).
link(n15, n7, 5, 700).
link(n9, n4, 5, 700).
link(n4, n10, 5, 700).
link(n4, n14, 5, 700).
link(n15, n6, 5, 700).
link(n14, n4, 5, 700).
link(n2, n7, 5, 700).
link(n10, n1, 5, 700).
link(n3, n11, 5, 700).
link(n1, n10, 5, 700).
link(n15, n9, 5, 700).
link(n9, n7, 5, 700).
link(n8, n9, 5, 700).
link(n10, n14, 5, 700).
link(n7, n3, 5, 700).
link(n4, n13, 5, 700).
link(n9, n11, 5, 700).
link(n10, n4, 5, 700).
link(n1, n3, 5, 700).
link(n1, n15, 5, 700).
link(n9, n0, 5, 700).
link(n7, n15, 5, 700).
link(n3, n10, 5, 700).
link(n11, n3, 5, 700).
link(n7, n11, 5, 700).
link(n5, n1, 5, 700).
link(n7, n12, 5, 700).
link(n14, n2, 5, 700).
link(n1, n9, 5, 700).
link(n0, n2, 5, 700).
link(n9, n2, 5, 700).
link(n14, n0, 5, 700).
link(n14, n1, 5, 700).
link(n0, n15, 5, 700).
link(n7, n6, 5, 700).
link(n13, n10, 5, 700).
link(n3, n7, 5, 700).
link(n6, n13, 5, 700).
link(n5, n7, 5, 700).
link(n7, n14, 5, 700).
link(n5, n11, 5, 700).
link(n15, n4, 5, 700).
link(n8, n12, 5, 700).
link(n4, n0, 5, 700).
link(n11, n6, 5, 700).
link(n2, n3, 5, 700).
link(n8, n11, 5, 700).
link(n6, n12, 5, 700).
link(n4, n7, 5, 700).
link(n3, n9, 5, 700).
link(n5, n6, 5, 700).
link(n1, n12, 5, 700).
link(n0, n6, 5, 700).
link(n5, n14, 5, 700).
link(n13, n11, 5, 700).
link(n2, n14, 5, 700).
link(n3, n5, 5, 700).
link(n11, n15, 5, 700).
link(n5, n12, 5, 700).
link(n1, n8, 5, 700).
link(n15, n8, 5, 700).
link(n10, n9, 5, 700).
link(n0, n13, 5, 700).
link(n0, n5, 5, 700).
link(n13, n0, 5, 700).
link(n9, n14, 5, 700).
link(n9, n8, 5, 700).
link(n7, n13, 5, 700).
link(n15, n5, 5, 700).
link(n4, n12, 5, 700).
link(n7, n5, 5, 700).
link(n6, n10, 5, 700).
link(n6, n2, 5, 700).
link(n7, n1, 5, 700).
link(n6, n8, 5, 700).
link(n8, n3, 5, 700).
link(n12, n8, 5, 700).
link(n13, n3, 5, 700).
link(n12, n14, 5, 700).
link(n0, n1, 5, 700).
link(n13, n7, 5, 700).
link(n11, n0, 5, 700).
link(n3, n12, 5, 700).
link(n7, n4, 5, 700).
link(n2, n5, 5, 700).
link(n12, n0, 5, 700).
link(n4, n3, 5, 700).
link(n12, n10, 5, 700).
link(n7, n2, 5, 700).
link(n12, n11, 5, 700).
link(n10, n11, 5, 700).
link(n12, n13, 5, 700).
link(n12, n3, 5, 700).
link(n11, n13, 5, 700).
link(n6, n9, 5, 700).
link(n12, n4, 5, 700).

domain(all, [_]).

