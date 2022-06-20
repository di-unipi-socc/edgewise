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

link(n14, n17, 15, 50).
link(n3, n19, 15, 50).
link(n1, n16, 2, 20).
link(n0, n24, 25, 50).
link(n16, n23, 2, 20).
link(n0, n4, 20, 100).
link(n20, n24, 40, 50).
link(n26, n28, 25, 500).
link(n6, n12, 135, 100).
link(n1, n9, 2, 20).
link(n4, n7, 25, 50).
link(n7, n18, 20, 1000).
link(n25, n30, 2, 20).
link(n3, n17, 15, 50).
link(n12, n18, 150, 18).
link(n10, n16, 15, 35).
link(n6, n13, 13, 50).
link(n7, n28, 25, 500).
link(n0, n14, 15, 35).
link(n10, n20, 15, 35).
link(n12, n19, 135, 100).
link(n4, n31, 13, 50).
link(n0, n19, 20, 100).
link(n16, n30, 2, 20).
link(n9, n10, 15, 50).
link(n6, n16, 15, 35).
link(n6, n11, 15, 35).
link(n0, n5, 135, 100).
link(n0, n21, 20, 100).
link(n3, n21, 15, 50).
link(n2, n12, 110, 1000).
link(n1, n11, 2, 20).
link(n0, n3, 15, 35).
link(n6, n25, 15, 35).
link(n4, n29, 13, 50).
link(n8, n9, 15, 35).
link(n13, n25, 2, 20).
link(n7, n10, 25, 500).
link(n3, n7, 40, 50).
link(n6, n14, 15, 35).
link(n10, n28, 20, 100).
link(n9, n11, 15, 50).
link(n8, n27, 20, 100).
link(n3, n20, 15, 50).
link(n5, n20, 150, 18).
link(n10, n13, 13, 50).
link(n7, n15, 20, 1000).
link(n13, n18, 2, 20).
link(n9, n15, 15, 50).
link(n5, n17, 150, 18).
link(n1, n20, 2, 20).
link(n12, n29, 148, 20).
link(n0, n10, 20, 100).
link(n2, n6, 25, 500).
link(n21, n29, 13, 50).
link(n7, n31, 38, 50).
link(n15, n23, 2, 20).
link(n9, n24, 40, 50).
link(n5, n28, 135, 100).
link(n0, n17, 15, 35).
link(n6, n9, 15, 35).
link(n0, n7, 25, 50).
link(n14, n21, 15, 50).
link(n5, n27, 135, 100).
link(n2, n28, 25, 500).
link(n14, n16, 15, 50).
link(n3, n12, 150, 50).
link(n9, n30, 2, 20).
link(n9, n14, 15, 50).
link(n1, n8, 13, 80).
link(n3, n6, 15, 50).
link(n4, n8, 20, 100).
link(n6, n26, 25, 50).
link(n12, n22, 150, 18).
link(n1, n6, 13, 80).
link(n4, n22, 15, 35).
link(n7, n8, 25, 500).
link(n4, n21, 20, 100).
link(n6, n10, 20, 100).
link(n7, n13, 38, 50).
link(n7, n11, 20, 1000).
link(n14, n25, 15, 50).
link(n6, n17, 15, 35).
link(n5, n9, 150, 18).
link(n3, n29, 2, 20).
link(n0, n8, 20, 100).
link(n1, n15, 2, 20).
link(n2, n16, 20, 1000).
link(n0, n11, 15, 35).
link(n9, n26, 40, 50).
link(n19, n20, 15, 35).
link(n12, n31, 148, 20).
link(n19, n27, 20, 100).
link(n9, n25, 15, 50).
link(n10, n26, 25, 50).
link(n3, n15, 15, 50).
link(n16, n27, 15, 50).
link(n9, n23, 2, 20).
link(n10, n14, 15, 35).
link(n9, n22, 15, 50).
link(n1, n18, 2, 20).
link(n10, n25, 15, 35).
link(n23, n24, 38, 80).
link(n11, n18, 15, 50).
link(n0, n12, 135, 100).
link(n11, n31, 2, 20).
link(n0, n23, 13, 50).
link(n18, n21, 15, 50).
link(n0, n6, 20, 100).
link(n11, n15, 15, 50).
link(n16, n19, 15, 50).
link(n0, n26, 25, 50).
link(n17, n29, 2, 20).
link(n2, n10, 25, 500).
link(n12, n23, 148, 20).
link(n8, n13, 13, 50).
link(n20, n31, 2, 20).
link(n6, n8, 20, 100).
link(n18, n30, 2, 20).
link(n6, n7, 25, 50).
link(n12, n26, 110, 1000).
link(n6, n22, 15, 35).
link(n20, n22, 15, 50).
link(n11, n12, 150, 50).
link(n0, n1, 13, 50).
link(n8, n14, 15, 35).
link(n6, n27, 20, 100).
link(n4, n13, 13, 50).
link(n0, n2, 25, 50).
link(n2, n30, 38, 50).
link(n4, n9, 15, 35).
link(n4, n6, 20, 100).
link(n10, n24, 25, 50).
link(n7, n19, 25, 500).
link(n1, n7, 38, 80).

domain(all, [_]).

