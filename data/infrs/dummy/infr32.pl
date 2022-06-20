bwTh(3).
hwTh(1).

node(n3, thing, [js], (x86, 32), [enc, auth], [piCamera1, cam11]).
node(n22, thing, [ubuntu], (x86, 32), [enc, auth], []).
node(n14, thing, [python, gcc, js], (arm64, 32), [enc, auth], []).
node(n12, cloud, [ubuntu, mySQL, python, js, gcc], (x86, 1024), [enc, auth], []).
node(n23, accesspoint, [mySQL, python, gcc, ubuntu], (x86, 64), [enc, auth], []).
node(n15, thing, [python, mySQL, js], (x86, 32), [enc, auth], []).
node(n8, cabinet, [js, ubuntu, gcc, python], (x86, 256), [enc, auth], [iphoneXS, cam21]).
node(n18, thing, [gcc], (x86, 32), [enc, auth], []).
node(n6, cabinet, [python, ubuntu], (arm64, 128), [enc, auth], [piCamera2, soil]).
node(n7, isp, [js, python, gcc], (x86, 256), [enc], []).
node(n29, accesspoint, [gcc, js, ubuntu, python], (arm64, 64), [enc, auth], []).
node(n2, isp, [mySQL, ubuntu], (arm64, 512), [enc], []).
node(n11, thing, [ubuntu], (arm64, 32), [enc, auth], []).
node(n9, thing, [mySQL, js, python], (arm64, 32), [enc, auth], [nutrient]).
node(n26, isp, [ubuntu, python, mySQL, js], (arm64, 256), [enc], []).
node(n5, cloud, [ubuntu, mySQL, python, js, gcc], (arm64, 1024), [enc, auth], []).
node(n25, thing, [gcc, js, ubuntu], (x86, 32), [enc, auth], []).
node(n17, thing, [js], (arm64, 32), [enc, auth], []).
node(n1, accesspoint, [gcc, js, python, ubuntu], (x86, 64), [enc, auth], [energy, echoDot]).
node(n24, isp, [js, mySQL, ubuntu], (x86, 512), [enc], []).
node(n13, accesspoint, [ubuntu, mySQL, gcc, js], (arm64, 64), [enc, auth], []).
node(n0, cabinet, [python, js], (x86, 256), [enc, auth], [water, cam22]).
node(n30, accesspoint, [gcc, js, python], (arm64, 64), [enc, auth], []).
node(n4, cabinet, [python, js], (arm64, 128), [enc, auth], [cam12]).
node(n19, cabinet, [js, python, ubuntu, gcc], (arm64, 128), [enc, auth], []).
node(n27, cabinet, [python, gcc, js], (x86, 128), [enc, auth], []).
node(n28, cabinet, [ubuntu, gcc, js, mySQL], (arm64, 256), [enc, auth], []).
node(n16, thing, [mySQL], (arm64, 32), [enc, auth], []).
node(n31, accesspoint, [gcc, python, js, ubuntu], (arm64, 64), [enc, auth], []).
node(n21, cabinet, [mySQL, ubuntu, gcc, python], (x86, 256), [enc, auth], []).
node(n10, cabinet, [ubuntu, mySQL, gcc], (arm64, 256), [enc, auth], [heat, arViewer]).
node(n20, thing, [python, js], (arm64, 32), [enc, auth], []).

link(n14, n17, 5, 700).
link(n3, n19, 5, 700).
link(n1, n16, 5, 700).
link(n0, n24, 5, 700).
link(n16, n23, 5, 700).
link(n0, n4, 5, 700).
link(n20, n24, 5, 700).
link(n26, n28, 5, 700).
link(n6, n12, 5, 700).
link(n1, n9, 5, 700).
link(n4, n7, 5, 700).
link(n7, n18, 5, 700).
link(n25, n30, 5, 700).
link(n3, n17, 5, 700).
link(n12, n18, 5, 700).
link(n10, n16, 5, 700).
link(n6, n13, 5, 700).
link(n7, n28, 5, 700).
link(n0, n14, 5, 700).
link(n10, n20, 5, 700).
link(n12, n19, 5, 700).
link(n4, n31, 5, 700).
link(n0, n19, 5, 700).
link(n16, n30, 5, 700).
link(n9, n10, 5, 700).
link(n6, n16, 5, 700).
link(n6, n11, 5, 700).
link(n0, n5, 5, 700).
link(n0, n21, 5, 700).
link(n3, n21, 5, 700).
link(n2, n12, 5, 700).
link(n1, n11, 5, 700).
link(n0, n3, 5, 700).
link(n6, n25, 5, 700).
link(n4, n29, 5, 700).
link(n8, n9, 5, 700).
link(n13, n25, 5, 700).
link(n7, n10, 5, 700).
link(n3, n7, 5, 700).
link(n6, n14, 5, 700).
link(n10, n28, 5, 700).
link(n9, n11, 5, 700).
link(n8, n27, 5, 700).
link(n3, n20, 5, 700).
link(n5, n20, 5, 700).
link(n10, n13, 5, 700).
link(n7, n15, 5, 700).
link(n13, n18, 5, 700).
link(n9, n15, 5, 700).
link(n5, n17, 5, 700).
link(n1, n20, 5, 700).
link(n12, n29, 5, 700).
link(n0, n10, 5, 700).
link(n2, n6, 5, 700).
link(n21, n29, 5, 700).
link(n7, n31, 5, 700).
link(n15, n23, 5, 700).
link(n9, n24, 5, 700).
link(n5, n28, 5, 700).
link(n0, n17, 5, 700).
link(n6, n9, 5, 700).
link(n0, n7, 5, 700).
link(n14, n21, 5, 700).
link(n5, n27, 5, 700).
link(n2, n28, 5, 700).
link(n14, n16, 5, 700).
link(n3, n12, 5, 700).
link(n9, n30, 5, 700).
link(n9, n14, 5, 700).
link(n1, n8, 5, 700).
link(n3, n6, 5, 700).
link(n4, n8, 5, 700).
link(n6, n26, 5, 700).
link(n12, n22, 5, 700).
link(n1, n6, 5, 700).
link(n4, n22, 5, 700).
link(n7, n8, 5, 700).
link(n4, n21, 5, 700).
link(n6, n10, 5, 700).
link(n7, n13, 5, 700).
link(n7, n11, 5, 700).
link(n14, n25, 5, 700).
link(n6, n17, 5, 700).
link(n5, n9, 5, 700).
link(n3, n29, 5, 700).
link(n0, n8, 5, 700).
link(n1, n15, 5, 700).
link(n2, n16, 5, 700).
link(n0, n11, 5, 700).
link(n9, n26, 5, 700).
link(n19, n20, 5, 700).
link(n12, n31, 5, 700).
link(n19, n27, 5, 700).
link(n9, n25, 5, 700).
link(n10, n26, 5, 700).
link(n3, n15, 5, 700).
link(n16, n27, 5, 700).
link(n9, n23, 5, 700).
link(n10, n14, 5, 700).
link(n9, n22, 5, 700).
link(n1, n18, 5, 700).
link(n10, n25, 5, 700).
link(n23, n24, 5, 700).
link(n11, n18, 5, 700).
link(n0, n12, 5, 700).
link(n11, n31, 5, 700).
link(n0, n23, 5, 700).
link(n18, n21, 5, 700).
link(n0, n6, 5, 700).
link(n11, n15, 5, 700).
link(n16, n19, 5, 700).
link(n0, n26, 5, 700).
link(n17, n29, 5, 700).
link(n2, n10, 5, 700).
link(n12, n23, 5, 700).
link(n8, n13, 5, 700).
link(n20, n31, 5, 700).
link(n6, n8, 5, 700).
link(n18, n30, 5, 700).
link(n6, n7, 5, 700).
link(n12, n26, 5, 700).
link(n6, n22, 5, 700).
link(n20, n22, 5, 700).
link(n11, n12, 5, 700).
link(n0, n1, 5, 700).
link(n8, n14, 5, 700).
link(n6, n27, 5, 700).
link(n4, n13, 5, 700).
link(n0, n2, 5, 700).
link(n2, n30, 5, 700).
link(n4, n9, 5, 700).
link(n4, n6, 5, 700).
link(n10, n24, 5, 700).
link(n7, n19, 5, 700).
link(n1, n7, 5, 700).

domain(all, [_]).

