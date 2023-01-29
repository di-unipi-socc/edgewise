bwTh(3).
hwTh(1).

node(n22, thing, [gcc, js], (x86, 416.0), [enc, auth], []).
node(n7, cloud, [ubuntu, mySQL, python, js, gcc], (arm64, 704.0), [enc, auth], []).
node(n16, thing, [js, python], (x86, 416.0), [enc, auth], []).
node(n19, cabinet, [gcc, js, mySQL], (arm64, 416.0), [enc, auth], []).
node(n24, thing, [mySQL, python], (arm64, 480.0), [enc, auth], []).
node(n28, thing, [gcc, ubuntu, mySQL], (arm64, 544.0), [enc, auth], []).
node(n21, cloud, [ubuntu, mySQL, python, js, gcc], (arm64, 320.0), [enc, auth], []).
node(n27, cabinet, [gcc, mySQL], (x86, 512.0), [enc, auth], []).
node(n13, cabinet, [js, python, ubuntu, gcc], (arm64, 384.0), [enc, auth], []).
node(n29, cabinet, [python, mySQL, gcc, ubuntu], (arm64, 224.0), [enc, auth], []).
node(n30, thing, [mySQL], (arm64, 544.0), [enc, auth], []).
node(n20, isp, [gcc, js, ubuntu, mySQL], (arm64, 576.0), [enc], []).
node(n26, isp, [ubuntu, python, mySQL], (arm64, 384.0), [enc], []).
node(n11, cabinet, [mySQL, js, ubuntu], (arm64, 832.0), [enc, auth], [piCamera2]).
node(n0, cloud, [ubuntu, mySQL, python, js, gcc], (arm64, 448.0), [enc, auth], []).
node(n10, thing, [mySQL, gcc], (arm64, 160.0), [enc, auth], [echoDot, piCamera1]).
node(n17, thing, [gcc, ubuntu], (x86, 512.0), [enc, auth], []).
node(n25, isp, [ubuntu, mySQL, gcc], (x86, 640.0), [enc], []).
node(n3, cabinet, [python, ubuntu, gcc], (x86, 544.0), [enc, auth], [heat]).
node(n4, cabinet, [ubuntu, gcc, python], (x86, 352.0), [enc, auth], [cam22]).
node(n14, accesspoint, [gcc, python], (x86, 352.0), [enc, auth], []).
node(n1, thing, [python, js], (arm64, 800.0), [enc, auth], [nutrient, iphoneXS]).
node(n8, cabinet, [mySQL, ubuntu], (arm64, 544.0), [enc, auth], [soil]).
node(n9, accesspoint, [gcc, js], (x86, 608.0), [enc, auth], [water, cam12]).
node(n6, thing, [mySQL, python], (arm64, 256.0), [enc, auth], [cam21]).
node(n18, thing, [js], (arm64, 480.0), [enc, auth], []).
node(n5, isp, [python, mySQL], (x86, 352.0), [enc], []).
node(n15, cabinet, [mySQL, gcc], (arm64, 352.0), [enc, auth], []).
node(n2, accesspoint, [gcc, js], (arm64, 608.0), [enc, auth], [cam11, energy]).
node(n12, thing, [ubuntu], (x86, 672.0), [enc, auth], [arViewer]).
node(n23, cloud, [ubuntu, mySQL, python, js, gcc], (x86, 448.0), [enc, auth], []).
node(n31, cabinet, [ubuntu, js, mySQL], (arm64, 352.0), [enc, auth], []).

link(n3, n6, 5, 700).
link(n6, n3, 5, 700).
link(n6, n28, 5, 700).
link(n28, n6, 5, 700).
link(n8, n9, 5, 700).
link(n9, n8, 5, 700).
link(n5, n9, 5, 700).
link(n9, n5, 5, 700).
link(n8, n24, 5, 700).
link(n24, n8, 5, 700).
link(n17, n24, 5, 700).
link(n24, n17, 5, 700).
link(n2, n5, 5, 700).
link(n5, n2, 5, 700).
link(n10, n25, 5, 700).
link(n25, n10, 5, 700).
link(n4, n21, 5, 700).
link(n21, n4, 5, 700).
link(n9, n31, 5, 700).
link(n31, n9, 5, 700).
link(n6, n20, 5, 700).
link(n20, n6, 5, 700).
link(n10, n18, 5, 700).
link(n18, n10, 5, 700).
link(n0, n5, 5, 700).
link(n5, n0, 5, 700).
link(n3, n10, 5, 700).
link(n10, n3, 5, 700).
link(n10, n13, 5, 700).
link(n13, n10, 5, 700).
link(n6, n25, 5, 700).
link(n25, n6, 5, 700).
link(n4, n22, 5, 700).
link(n22, n4, 5, 700).
link(n7, n13, 5, 700).
link(n13, n7, 5, 700).
link(n22, n26, 5, 700).
link(n26, n22, 5, 700).
link(n10, n12, 5, 700).
link(n12, n10, 5, 700).
link(n18, n28, 5, 700).
link(n28, n18, 5, 700).
link(n3, n21, 5, 700).
link(n21, n3, 5, 700).
link(n13, n20, 5, 700).
link(n20, n13, 5, 700).
link(n10, n29, 5, 700).
link(n29, n10, 5, 700).
link(n8, n14, 5, 700).
link(n14, n8, 5, 700).
link(n8, n11, 5, 700).
link(n11, n8, 5, 700).
link(n17, n19, 5, 700).
link(n19, n17, 5, 700).
link(n5, n24, 5, 700).
link(n24, n5, 5, 700).
link(n3, n24, 5, 700).
link(n24, n3, 5, 700).
link(n0, n16, 5, 700).
link(n16, n0, 5, 700).
link(n12, n17, 5, 700).
link(n17, n12, 5, 700).
link(n8, n23, 5, 700).
link(n23, n8, 5, 700).
link(n6, n19, 5, 700).
link(n19, n6, 5, 700).
link(n6, n18, 5, 700).
link(n18, n6, 5, 700).
link(n7, n29, 5, 700).
link(n29, n7, 5, 700).
link(n9, n12, 5, 700).
link(n12, n9, 5, 700).
link(n23, n30, 5, 700).
link(n30, n23, 5, 700).
link(n13, n24, 5, 700).
link(n24, n13, 5, 700).
link(n4, n30, 5, 700).
link(n30, n4, 5, 700).
link(n18, n19, 5, 700).
link(n19, n18, 5, 700).
link(n5, n23, 5, 700).
link(n23, n5, 5, 700).
link(n22, n22, 0, inf).
link(n1, n30, 5, 700).
link(n30, n1, 5, 700).
link(n16, n28, 5, 700).
link(n28, n16, 5, 700).
link(n10, n10, 0, inf).
link(n26, n27, 5, 700).
link(n27, n26, 5, 700).
link(n0, n29, 5, 700).
link(n29, n0, 5, 700).
link(n8, n18, 5, 700).
link(n18, n8, 5, 700).
link(n1, n10, 5, 700).
link(n10, n1, 5, 700).
link(n0, n15, 5, 700).
link(n15, n0, 5, 700).
link(n12, n16, 5, 700).
link(n16, n12, 5, 700).
link(n10, n21, 5, 700).
link(n21, n10, 5, 700).
link(n14, n27, 5, 700).
link(n27, n14, 5, 700).
link(n25, n30, 5, 700).
link(n30, n25, 5, 700).
link(n20, n21, 5, 700).
link(n21, n20, 5, 700).
link(n20, n24, 5, 700).
link(n24, n20, 5, 700).
link(n19, n20, 5, 700).
link(n20, n19, 5, 700).
link(n12, n14, 5, 700).
link(n14, n12, 5, 700).
link(n11, n15, 5, 700).
link(n15, n11, 5, 700).
link(n4, n18, 5, 700).
link(n18, n4, 5, 700).
link(n16, n17, 5, 700).
link(n17, n16, 5, 700).
link(n1, n29, 5, 700).
link(n29, n1, 5, 700).
link(n18, n30, 5, 700).
link(n30, n18, 5, 700).
link(n9, n16, 5, 700).
link(n16, n9, 5, 700).
link(n30, n30, 0, inf).
link(n4, n25, 5, 700).
link(n25, n4, 5, 700).
link(n11, n17, 5, 700).
link(n17, n11, 5, 700).
link(n9, n10, 5, 700).
link(n10, n9, 5, 700).
link(n1, n19, 5, 700).
link(n19, n1, 5, 700).
link(n1, n4, 5, 700).
link(n4, n1, 5, 700).
link(n13, n16, 5, 700).
link(n16, n13, 5, 700).
link(n2, n19, 5, 700).
link(n19, n2, 5, 700).
link(n9, n21, 5, 700).
link(n21, n9, 5, 700).
link(n13, n25, 5, 700).
link(n25, n13, 5, 700).
link(n10, n30, 5, 700).
link(n30, n10, 5, 700).
link(n6, n24, 5, 700).
link(n24, n6, 5, 700).
link(n3, n13, 5, 700).
link(n13, n3, 5, 700).
link(n2, n29, 5, 700).
link(n29, n2, 5, 700).
link(n3, n19, 5, 700).
link(n19, n3, 5, 700).
link(n11, n28, 5, 700).
link(n28, n11, 5, 700).
link(n10, n26, 5, 700).
link(n26, n10, 5, 700).
link(n10, n16, 5, 700).
link(n16, n10, 5, 700).
link(n20, n25, 5, 700).
link(n25, n20, 5, 700).
link(n7, n21, 5, 700).
link(n21, n7, 5, 700).
link(n5, n21, 5, 700).
link(n21, n5, 5, 700).
link(n12, n23, 5, 700).
link(n23, n12, 5, 700).
link(n17, n29, 5, 700).
link(n29, n17, 5, 700).
link(n24, n27, 5, 700).
link(n27, n24, 5, 700).
link(n17, n21, 5, 700).
link(n21, n17, 5, 700).
link(n8, n20, 5, 700).
link(n20, n8, 5, 700).
link(n2, n8, 5, 700).
link(n8, n2, 5, 700).
link(n21, n27, 5, 700).
link(n27, n21, 5, 700).
link(n7, n27, 5, 700).
link(n27, n7, 5, 700).
link(n15, n18, 5, 700).
link(n18, n15, 5, 700).
link(n8, n13, 5, 700).
link(n13, n8, 5, 700).
link(n14, n23, 5, 700).
link(n23, n14, 5, 700).
link(n13, n19, 5, 700).
link(n19, n13, 5, 700).
link(n17, n22, 5, 700).
link(n22, n17, 5, 700).
link(n5, n22, 5, 700).
link(n22, n5, 5, 700).
link(n9, n22, 5, 700).
link(n22, n9, 5, 700).
link(n2, n12, 5, 700).
link(n12, n2, 5, 700).
link(n12, n22, 5, 700).
link(n22, n12, 5, 700).
link(n16, n19, 5, 700).
link(n19, n16, 5, 700).
link(n27, n28, 5, 700).
link(n28, n27, 5, 700).
link(n17, n18, 5, 700).
link(n18, n17, 5, 700).
link(n14, n18, 5, 700).
link(n18, n14, 5, 700).
link(n11, n19, 5, 700).
link(n19, n11, 5, 700).
link(n9, n25, 5, 700).
link(n25, n9, 5, 700).
link(n15, n27, 5, 700).
link(n27, n15, 5, 700).
link(n10, n20, 5, 700).
link(n20, n10, 5, 700).
link(n15, n22, 5, 700).
link(n22, n15, 5, 700).
link(n5, n30, 5, 700).
link(n30, n5, 5, 700).
link(n6, n10, 5, 700).
link(n10, n6, 5, 700).
link(n22, n27, 5, 700).
link(n27, n22, 5, 700).
link(n25, n26, 5, 700).
link(n26, n25, 5, 700).
link(n4, n16, 5, 700).
link(n16, n4, 5, 700).
link(n10, n17, 5, 700).
link(n17, n10, 5, 700).
link(n12, n27, 5, 700).
link(n27, n12, 5, 700).
link(n4, n20, 5, 700).
link(n20, n4, 5, 700).
link(n13, n30, 5, 700).
link(n30, n13, 5, 700).
link(n2, n3, 5, 700).
link(n3, n2, 5, 700).
link(n24, n24, 0, inf).
link(n30, n31, 5, 700).
link(n31, n30, 5, 700).
link(n16, n21, 5, 700).
link(n21, n16, 5, 700).
link(n2, n9, 5, 700).
link(n9, n2, 5, 700).
link(n1, n22, 5, 700).
link(n22, n1, 5, 700).
link(n6, n15, 5, 700).
link(n15, n6, 5, 700).
link(n16, n24, 5, 700).
link(n24, n16, 5, 700).
link(n12, n19, 5, 700).
link(n19, n12, 5, 700).
link(n25, n31, 5, 700).
link(n31, n25, 5, 700).
link(n3, n18, 5, 700).
link(n18, n3, 5, 700).
link(n2, n21, 5, 700).
link(n21, n2, 5, 700).
link(n0, n22, 5, 700).
link(n22, n0, 5, 700).
link(n12, n15, 5, 700).
link(n15, n12, 5, 700).
link(n0, n18, 5, 700).
link(n18, n0, 5, 700).
link(n4, n19, 5, 700).
link(n19, n4, 5, 700).
link(n4, n13, 5, 700).
link(n13, n4, 5, 700).
link(n14, n30, 5, 700).
link(n30, n14, 5, 700).
link(n15, n23, 5, 700).
link(n23, n15, 5, 700).
link(n3, n7, 5, 700).
link(n7, n3, 5, 700).
link(n2, n6, 5, 700).
link(n6, n2, 5, 700).
link(n18, n29, 5, 700).
link(n29, n18, 5, 700).
link(n4, n27, 5, 700).
link(n27, n4, 5, 700).
link(n0, n12, 5, 700).
link(n12, n0, 5, 700).
link(n11, n21, 5, 700).
link(n21, n11, 5, 700).
link(n14, n20, 5, 700).
link(n20, n14, 5, 700).
link(n1, n31, 5, 700).
link(n31, n1, 5, 700).
link(n26, n28, 5, 700).
link(n28, n26, 5, 700).
link(n9, n9, 0, inf).
link(n17, n28, 5, 700).
link(n28, n17, 5, 700).
link(n1, n16, 5, 700).
link(n16, n1, 5, 700).
link(n1, n21, 5, 700).
link(n21, n1, 5, 700).
link(n4, n23, 5, 700).
link(n23, n4, 5, 700).
link(n0, n30, 5, 700).
link(n30, n0, 5, 700).
link(n12, n26, 5, 700).
link(n26, n12, 5, 700).
link(n16, n26, 5, 700).
link(n26, n16, 5, 700).
link(n28, n31, 5, 700).
link(n31, n28, 5, 700).
link(n27, n27, 0, inf).
link(n2, n27, 5, 700).
link(n27, n2, 5, 700).
link(n17, n27, 5, 700).
link(n27, n17, 5, 700).
link(n9, n11, 5, 700).
link(n11, n9, 5, 700).
link(n3, n22, 5, 700).
link(n22, n3, 5, 700).
link(n1, n15, 5, 700).
link(n15, n1, 5, 700).
link(n4, n17, 5, 700).
link(n17, n4, 5, 700).
link(n7, n19, 5, 700).
link(n19, n7, 5, 700).
link(n12, n18, 5, 700).
link(n18, n12, 5, 700).
link(n19, n19, 0, inf).
link(n5, n12, 5, 700).
link(n12, n5, 5, 700).
link(n6, n31, 5, 700).
link(n31, n6, 5, 700).
link(n12, n25, 5, 700).
link(n25, n12, 5, 700).
link(n1, n2, 5, 700).
link(n2, n1, 5, 700).
link(n16, n16, 0, inf).
link(n0, n4, 5, 700).
link(n4, n0, 5, 700).
link(n16, n29, 5, 700).
link(n29, n16, 5, 700).
link(n11, n12, 5, 700).
link(n12, n11, 5, 700).
link(n26, n26, 0, inf).
link(n6, n8, 5, 700).
link(n8, n6, 5, 700).
link(n4, n10, 5, 700).
link(n10, n4, 5, 700).
link(n2, n23, 5, 700).
link(n23, n2, 5, 700).
link(n8, n28, 5, 700).
link(n28, n8, 5, 700).
link(n12, n20, 5, 700).
link(n20, n12, 5, 700).
link(n4, n5, 5, 700).
link(n5, n4, 5, 700).
link(n19, n25, 5, 700).
link(n25, n19, 5, 700).
link(n9, n14, 5, 700).
link(n14, n9, 5, 700).
link(n1, n20, 5, 700).
link(n20, n1, 5, 700).
link(n1, n13, 5, 700).
link(n13, n1, 5, 700).
link(n7, n22, 5, 700).
link(n22, n7, 5, 700).
link(n4, n9, 5, 700).
link(n9, n4, 5, 700).
link(n6, n21, 5, 700).
link(n21, n6, 5, 700).
link(n21, n24, 5, 700).
link(n24, n21, 5, 700).
link(n1, n6, 5, 700).
link(n6, n1, 5, 700).
link(n5, n26, 5, 700).
link(n26, n5, 5, 700).
link(n5, n5, 0, inf).
link(n23, n26, 5, 700).
link(n26, n23, 5, 700).
link(n8, n27, 5, 700).
link(n27, n8, 5, 700).
link(n6, n12, 5, 700).
link(n12, n6, 5, 700).
link(n26, n30, 5, 700).
link(n30, n26, 5, 700).
link(n6, n13, 5, 700).
link(n13, n6, 5, 700).
link(n7, n18, 5, 700).
link(n18, n7, 5, 700).
link(n12, n29, 5, 700).
link(n29, n12, 5, 700).
link(n4, n7, 5, 700).
link(n7, n4, 5, 700).
link(n1, n11, 5, 700).
link(n11, n1, 5, 700).
link(n19, n28, 5, 700).
link(n28, n19, 5, 700).
link(n16, n31, 5, 700).
link(n31, n16, 5, 700).
link(n17, n23, 5, 700).
link(n23, n17, 5, 700).
link(n18, n31, 5, 700).
link(n31, n18, 5, 700).
link(n16, n25, 5, 700).
link(n25, n16, 5, 700).
link(n15, n29, 5, 700).
link(n29, n15, 5, 700).
link(n2, n7, 5, 700).
link(n7, n2, 5, 700).
link(n14, n24, 5, 700).
link(n24, n14, 5, 700).
link(n6, n26, 5, 700).
link(n26, n6, 5, 700).
link(n11, n26, 5, 700).
link(n26, n11, 5, 700).
link(n14, n14, 0, inf).
link(n10, n24, 5, 700).
link(n24, n10, 5, 700).
link(n29, n29, 0, inf).
link(n0, n25, 5, 700).
link(n25, n0, 5, 700).
link(n13, n17, 5, 700).
link(n17, n13, 5, 700).
link(n18, n23, 5, 700).
link(n23, n18, 5, 700).
link(n6, n29, 5, 700).
link(n29, n6, 5, 700).
link(n9, n26, 5, 700).
link(n26, n9, 5, 700).
link(n2, n16, 5, 700).
link(n16, n2, 5, 700).
link(n3, n23, 5, 700).
link(n23, n3, 5, 700).
link(n15, n30, 5, 700).
link(n30, n15, 5, 700).
link(n6, n17, 5, 700).
link(n17, n6, 5, 700).
link(n3, n17, 5, 700).
link(n17, n3, 5, 700).
link(n4, n15, 5, 700).
link(n15, n4, 5, 700).
link(n11, n24, 5, 700).
link(n24, n11, 5, 700).
link(n17, n25, 5, 700).
link(n25, n17, 5, 700).
link(n5, n10, 5, 700).
link(n10, n5, 5, 700).
link(n1, n24, 5, 700).
link(n24, n1, 5, 700).
link(n1, n12, 5, 700).
link(n12, n1, 5, 700).
link(n3, n29, 5, 700).
link(n29, n3, 5, 700).
link(n1, n17, 5, 700).
link(n17, n1, 5, 700).
link(n12, n24, 5, 700).
link(n24, n12, 5, 700).
link(n8, n26, 5, 700).
link(n26, n8, 5, 700).
link(n14, n19, 5, 700).
link(n19, n14, 5, 700).
link(n25, n27, 5, 700).
link(n27, n25, 5, 700).
link(n5, n19, 5, 700).
link(n19, n5, 5, 700).
link(n3, n16, 5, 700).
link(n16, n3, 5, 700).
link(n3, n30, 5, 700).
link(n30, n3, 5, 700).
link(n19, n23, 5, 700).
link(n23, n19, 5, 700).
link(n7, n15, 5, 700).
link(n15, n7, 5, 700).
link(n9, n15, 5, 700).
link(n15, n9, 5, 700).
link(n22, n24, 5, 700).
link(n24, n22, 5, 700).
link(n1, n25, 5, 700).
link(n25, n1, 5, 700).
link(n8, n31, 5, 700).
link(n31, n8, 5, 700).
link(n14, n25, 5, 700).
link(n25, n14, 5, 700).
link(n5, n25, 5, 700).
link(n25, n5, 5, 700).
link(n21, n28, 5, 700).
link(n28, n21, 5, 700).
link(n26, n31, 5, 700).
link(n31, n26, 5, 700).
link(n4, n14, 5, 700).
link(n14, n4, 5, 700).
link(n0, n0, 0, inf).
link(n11, n11, 0, inf).
link(n3, n3, 0, inf).
link(n16, n22, 5, 700).
link(n22, n16, 5, 700).
link(n9, n19, 5, 700).
link(n19, n9, 5, 700).
link(n23, n25, 5, 700).
link(n25, n23, 5, 700).
link(n17, n31, 5, 700).
link(n31, n17, 5, 700).
link(n3, n27, 5, 700).
link(n27, n3, 5, 700).
link(n24, n28, 5, 700).
link(n28, n24, 5, 700).
link(n0, n9, 5, 700).
link(n9, n0, 5, 700).
link(n5, n18, 5, 700).
link(n18, n5, 5, 700).
link(n9, n17, 5, 700).
link(n17, n9, 5, 700).
link(n8, n8, 0, inf).
link(n21, n30, 5, 700).
link(n30, n21, 5, 700).
link(n10, n28, 5, 700).
link(n28, n10, 5, 700).
link(n0, n27, 5, 700).
link(n27, n0, 5, 700).
link(n29, n31, 5, 700).
link(n31, n29, 5, 700).
link(n9, n28, 5, 700).
link(n28, n9, 5, 700).
link(n25, n28, 5, 700).
link(n28, n25, 5, 700).
link(n19, n31, 5, 700).
link(n31, n19, 5, 700).
link(n8, n10, 5, 700).
link(n10, n8, 5, 700).
link(n17, n26, 5, 700).
link(n26, n17, 5, 700).
link(n13, n26, 5, 700).
link(n26, n13, 5, 700).
link(n14, n17, 5, 700).
link(n17, n14, 5, 700).
link(n18, n20, 5, 700).
link(n20, n18, 5, 700).
link(n13, n15, 5, 700).
link(n15, n13, 5, 700).
link(n13, n13, 0, inf).
link(n8, n19, 5, 700).
link(n19, n8, 5, 700).
link(n3, n9, 5, 700).
link(n9, n3, 5, 700).
link(n20, n26, 5, 700).
link(n26, n20, 5, 700).
link(n15, n24, 5, 700).
link(n24, n15, 5, 700).
link(n23, n29, 5, 700).
link(n29, n23, 5, 700).
link(n1, n8, 5, 700).
link(n8, n1, 5, 700).
link(n0, n17, 5, 700).
link(n17, n0, 5, 700).
link(n8, n16, 5, 700).
link(n16, n8, 5, 700).
link(n21, n31, 5, 700).
link(n31, n21, 5, 700).
link(n9, n24, 5, 700).
link(n24, n9, 5, 700).
link(n4, n6, 5, 700).
link(n6, n4, 5, 700).
link(n8, n25, 5, 700).
link(n25, n8, 5, 700).
link(n6, n14, 5, 700).
link(n14, n6, 5, 700).
link(n13, n21, 5, 700).
link(n21, n13, 5, 700).
link(n14, n21, 5, 700).
link(n21, n14, 5, 700).
link(n2, n4, 5, 700).
link(n4, n2, 5, 700).
link(n18, n26, 5, 700).
link(n26, n18, 5, 700).
link(n18, n21, 5, 700).
link(n21, n18, 5, 700).
link(n8, n29, 5, 700).
link(n29, n8, 5, 700).
link(n3, n14, 5, 700).
link(n14, n3, 5, 700).
link(n3, n5, 5, 700).
link(n5, n3, 5, 700).
link(n5, n31, 5, 700).
link(n31, n5, 5, 700).
link(n22, n29, 5, 700).
link(n29, n22, 5, 700).
link(n5, n6, 5, 700).
link(n6, n5, 5, 700).
link(n0, n19, 5, 700).
link(n19, n0, 5, 700).
link(n7, n23, 5, 700).
link(n23, n7, 5, 700).
link(n0, n3, 5, 700).
link(n3, n0, 5, 700).
link(n10, n27, 5, 700).
link(n27, n10, 5, 700).
link(n19, n27, 5, 700).
link(n27, n19, 5, 700).
link(n5, n13, 5, 700).
link(n13, n5, 5, 700).
link(n7, n16, 5, 700).
link(n16, n7, 5, 700).
link(n14, n26, 5, 700).
link(n26, n14, 5, 700).
link(n7, n10, 5, 700).
link(n10, n7, 5, 700).
link(n24, n30, 5, 700).
link(n30, n24, 5, 700).
link(n1, n3, 5, 700).
link(n3, n1, 5, 700).
link(n12, n28, 5, 700).
link(n28, n12, 5, 700).
link(n15, n28, 5, 700).
link(n28, n15, 5, 700).
link(n4, n12, 5, 700).
link(n12, n4, 5, 700).
link(n1, n27, 5, 700).
link(n27, n1, 5, 700).
link(n11, n25, 5, 700).
link(n25, n11, 5, 700).
link(n1, n5, 5, 700).
link(n5, n1, 5, 700).
link(n4, n31, 5, 700).
link(n31, n4, 5, 700).
link(n7, n14, 5, 700).
link(n14, n7, 5, 700).
link(n2, n20, 5, 700).
link(n20, n2, 5, 700).
link(n11, n13, 5, 700).
link(n13, n11, 5, 700).
link(n11, n20, 5, 700).
link(n20, n11, 5, 700).
link(n25, n29, 5, 700).
link(n29, n25, 5, 700).
link(n6, n11, 5, 700).
link(n11, n6, 5, 700).
link(n20, n27, 5, 700).
link(n27, n20, 5, 700).
link(n3, n28, 5, 700).
link(n28, n3, 5, 700).
link(n7, n24, 5, 700).
link(n24, n7, 5, 700).
link(n5, n27, 5, 700).
link(n27, n5, 5, 700).
link(n8, n17, 5, 700).
link(n17, n8, 5, 700).
link(n1, n23, 5, 700).
link(n23, n1, 5, 700).
link(n22, n31, 5, 700).
link(n31, n22, 5, 700).
link(n14, n29, 5, 700).
link(n29, n14, 5, 700).
link(n8, n22, 5, 700).
link(n22, n8, 5, 700).
link(n17, n17, 0, inf).
link(n0, n24, 5, 700).
link(n24, n0, 5, 700).
link(n18, n27, 5, 700).
link(n27, n18, 5, 700).
link(n2, n25, 5, 700).
link(n25, n2, 5, 700).
link(n21, n26, 5, 700).
link(n26, n21, 5, 700).
link(n0, n13, 5, 700).
link(n13, n0, 5, 700).
link(n6, n16, 5, 700).
link(n16, n6, 5, 700).
link(n10, n31, 5, 700).
link(n31, n10, 5, 700).
link(n4, n8, 5, 700).
link(n8, n4, 5, 700).
link(n0, n2, 5, 700).
link(n2, n0, 5, 700).
link(n24, n31, 5, 700).
link(n31, n24, 5, 700).
link(n11, n27, 5, 700).
link(n27, n11, 5, 700).
link(n21, n23, 5, 700).
link(n23, n21, 5, 700).
link(n13, n28, 5, 700).
link(n28, n13, 5, 700).
link(n29, n30, 5, 700).
link(n30, n29, 5, 700).
link(n8, n30, 5, 700).
link(n30, n8, 5, 700).
link(n3, n20, 5, 700).
link(n20, n3, 5, 700).
link(n13, n29, 5, 700).
link(n29, n13, 5, 700).
link(n23, n24, 5, 700).
link(n24, n23, 5, 700).
link(n11, n31, 5, 700).
link(n31, n11, 5, 700).
link(n13, n22, 5, 700).
link(n22, n13, 5, 700).
link(n6, n6, 0, inf).
link(n12, n21, 5, 700).
link(n21, n12, 5, 700).
link(n9, n20, 5, 700).
link(n20, n9, 5, 700).
link(n7, n7, 0, inf).
link(n16, n23, 5, 700).
link(n23, n16, 5, 700).
link(n7, n26, 5, 700).
link(n26, n7, 5, 700).
link(n15, n15, 0, inf).
link(n2, n11, 5, 700).
link(n11, n2, 5, 700).
link(n23, n23, 0, inf).
link(n18, n25, 5, 700).
link(n25, n18, 5, 700).
link(n4, n4, 0, inf).
link(n11, n30, 5, 700).
link(n30, n11, 5, 700).
link(n14, n16, 5, 700).
link(n16, n14, 5, 700).
link(n11, n18, 5, 700).
link(n18, n11, 5, 700).
link(n3, n15, 5, 700).
link(n15, n3, 5, 700).
link(n4, n24, 5, 700).
link(n24, n4, 5, 700).
link(n3, n31, 5, 700).
link(n31, n3, 5, 700).
link(n20, n23, 5, 700).
link(n23, n20, 5, 700).
link(n2, n28, 5, 700).
link(n28, n2, 5, 700).
link(n14, n15, 5, 700).
link(n15, n14, 5, 700).
link(n17, n20, 5, 700).
link(n20, n17, 5, 700).
link(n6, n22, 5, 700).
link(n22, n6, 5, 700).
link(n3, n12, 5, 700).
link(n12, n3, 5, 700).
link(n5, n8, 5, 700).
link(n8, n5, 5, 700).
link(n3, n25, 5, 700).
link(n25, n3, 5, 700).
link(n2, n15, 5, 700).
link(n15, n2, 5, 700).
link(n8, n12, 5, 700).
link(n12, n8, 5, 700).
link(n16, n30, 5, 700).
link(n30, n16, 5, 700).
link(n7, n28, 5, 700).
link(n28, n7, 5, 700).
link(n0, n1, 5, 700).
link(n1, n0, 5, 700).
link(n13, n27, 5, 700).
link(n27, n13, 5, 700).
link(n8, n21, 5, 700).
link(n21, n8, 5, 700).
link(n6, n30, 5, 700).
link(n30, n6, 5, 700).
link(n5, n15, 5, 700).
link(n15, n5, 5, 700).
link(n4, n29, 5, 700).
link(n29, n4, 5, 700).
link(n23, n31, 5, 700).
link(n31, n23, 5, 700).
link(n2, n24, 5, 700).
link(n24, n2, 5, 700).
link(n11, n23, 5, 700).
link(n23, n11, 5, 700).
link(n2, n18, 5, 700).
link(n18, n2, 5, 700).
link(n5, n14, 5, 700).
link(n14, n5, 5, 700).
link(n28, n28, 0, inf).
link(n15, n16, 5, 700).
link(n16, n15, 5, 700).
link(n2, n14, 5, 700).
link(n14, n2, 5, 700).
link(n1, n9, 5, 700).
link(n9, n1, 5, 700).
link(n2, n26, 5, 700).
link(n26, n2, 5, 700).
link(n6, n7, 5, 700).
link(n7, n6, 5, 700).
link(n19, n30, 5, 700).
link(n30, n19, 5, 700).
link(n9, n23, 5, 700).
link(n23, n9, 5, 700).
link(n15, n31, 5, 700).
link(n31, n15, 5, 700).
link(n3, n11, 5, 700).
link(n11, n3, 5, 700).
link(n10, n23, 5, 700).
link(n23, n10, 5, 700).
link(n7, n20, 5, 700).
link(n20, n7, 5, 700).
link(n11, n14, 5, 700).
link(n14, n11, 5, 700).
link(n0, n10, 5, 700).
link(n10, n0, 5, 700).
link(n0, n31, 5, 700).
link(n31, n0, 5, 700).
link(n20, n30, 5, 700).
link(n30, n20, 5, 700).
link(n3, n4, 5, 700).
link(n4, n3, 5, 700).
link(n14, n22, 5, 700).
link(n22, n14, 5, 700).
link(n12, n31, 5, 700).
link(n31, n12, 5, 700).
link(n21, n29, 5, 700).
link(n29, n21, 5, 700).
link(n21, n25, 5, 700).
link(n25, n21, 5, 700).
link(n10, n11, 5, 700).
link(n11, n10, 5, 700).
link(n18, n18, 0, inf).
link(n7, n12, 5, 700).
link(n12, n7, 5, 700).
link(n7, n8, 5, 700).
link(n8, n7, 5, 700).
link(n2, n2, 0, inf).
link(n16, n18, 5, 700).
link(n18, n16, 5, 700).
link(n21, n21, 0, inf).
link(n13, n18, 5, 700).
link(n18, n13, 5, 700).
link(n15, n25, 5, 700).
link(n25, n15, 5, 700).
link(n3, n26, 5, 700).
link(n26, n3, 5, 700).
link(n7, n17, 5, 700).
link(n17, n7, 5, 700).
link(n12, n12, 0, inf).
link(n5, n20, 5, 700).
link(n20, n5, 5, 700).
link(n0, n8, 5, 700).
link(n8, n0, 5, 700).
link(n7, n31, 5, 700).
link(n31, n7, 5, 700).
link(n13, n14, 5, 700).
link(n14, n13, 5, 700).
link(n24, n25, 5, 700).
link(n25, n24, 5, 700).
link(n24, n26, 5, 700).
link(n26, n24, 5, 700).
link(n9, n29, 5, 700).
link(n29, n9, 5, 700).
link(n7, n9, 5, 700).
link(n9, n7, 5, 700).
link(n7, n25, 5, 700).
link(n25, n7, 5, 700).
link(n5, n7, 5, 700).
link(n7, n5, 5, 700).
link(n22, n23, 5, 700).
link(n23, n22, 5, 700).
link(n1, n14, 5, 700).
link(n14, n1, 5, 700).
link(n16, n27, 5, 700).
link(n27, n16, 5, 700).
link(n20, n20, 0, inf).
link(n15, n17, 5, 700).
link(n17, n15, 5, 700).
link(n11, n29, 5, 700).
link(n29, n11, 5, 700).
link(n0, n23, 5, 700).
link(n23, n0, 5, 700).
link(n6, n9, 5, 700).
link(n9, n6, 5, 700).
link(n18, n22, 5, 700).
link(n22, n18, 5, 700).
link(n19, n29, 5, 700).
link(n29, n19, 5, 700).
link(n13, n23, 5, 700).
link(n23, n13, 5, 700).
link(n22, n28, 5, 700).
link(n28, n22, 5, 700).
link(n6, n27, 5, 700).
link(n27, n6, 5, 700).
link(n1, n18, 5, 700).
link(n18, n1, 5, 700).
link(n5, n28, 5, 700).
link(n28, n5, 5, 700).
link(n23, n27, 5, 700).
link(n27, n23, 5, 700).
link(n28, n30, 5, 700).
link(n30, n28, 5, 700).
link(n0, n7, 5, 700).
link(n7, n0, 5, 700).
link(n11, n22, 5, 700).
link(n22, n11, 5, 700).
link(n2, n31, 5, 700).
link(n31, n2, 5, 700).
link(n4, n26, 5, 700).
link(n26, n4, 5, 700).
link(n27, n31, 5, 700).
link(n31, n27, 5, 700).
link(n1, n28, 5, 700).
link(n28, n1, 5, 700).
link(n2, n10, 5, 700).
link(n10, n2, 5, 700).
link(n24, n29, 5, 700).
link(n29, n24, 5, 700).
link(n7, n11, 5, 700).
link(n11, n7, 5, 700).
link(n26, n29, 5, 700).
link(n29, n26, 5, 700).
link(n9, n30, 5, 700).
link(n30, n9, 5, 700).
link(n0, n11, 5, 700).
link(n11, n0, 5, 700).
link(n10, n14, 5, 700).
link(n14, n10, 5, 700).
link(n10, n15, 5, 700).
link(n15, n10, 5, 700).
link(n12, n13, 5, 700).
link(n13, n12, 5, 700).
link(n5, n17, 5, 700).
link(n17, n5, 5, 700).
link(n19, n26, 5, 700).
link(n26, n19, 5, 700).
link(n5, n16, 5, 700).
link(n16, n5, 5, 700).
link(n0, n14, 5, 700).
link(n14, n0, 5, 700).
link(n17, n30, 5, 700).
link(n30, n17, 5, 700).
link(n15, n19, 5, 700).
link(n19, n15, 5, 700).
link(n1, n26, 5, 700).
link(n26, n1, 5, 700).
link(n9, n13, 5, 700).
link(n13, n9, 5, 700).
link(n15, n26, 5, 700).
link(n26, n15, 5, 700).
link(n20, n22, 5, 700).
link(n22, n20, 5, 700).
link(n19, n22, 5, 700).
link(n22, n19, 5, 700).
link(n4, n28, 5, 700).
link(n28, n4, 5, 700).
link(n9, n18, 5, 700).
link(n18, n9, 5, 700).
link(n25, n25, 0, inf).
link(n19, n24, 5, 700).
link(n24, n19, 5, 700).
link(n13, n31, 5, 700).
link(n31, n13, 5, 700).
link(n21, n22, 5, 700).
link(n22, n21, 5, 700).
link(n11, n16, 5, 700).
link(n16, n11, 5, 700).
link(n0, n20, 5, 700).
link(n20, n0, 5, 700).
link(n22, n25, 5, 700).
link(n25, n22, 5, 700).
link(n2, n30, 5, 700).
link(n30, n2, 5, 700).
link(n19, n21, 5, 700).
link(n21, n19, 5, 700).
link(n8, n15, 5, 700).
link(n15, n8, 5, 700).
link(n15, n21, 5, 700).
link(n21, n15, 5, 700).
link(n12, n30, 5, 700).
link(n30, n12, 5, 700).
link(n6, n23, 5, 700).
link(n23, n6, 5, 700).
link(n0, n26, 5, 700).
link(n26, n0, 5, 700).
link(n28, n29, 5, 700).
link(n29, n28, 5, 700).
link(n0, n21, 5, 700).
link(n21, n0, 5, 700).
link(n2, n22, 5, 700).
link(n22, n2, 5, 700).
link(n20, n31, 5, 700).
link(n31, n20, 5, 700).
link(n5, n29, 5, 700).
link(n29, n5, 5, 700).
link(n4, n11, 5, 700).
link(n11, n4, 5, 700).
link(n10, n22, 5, 700).
link(n22, n10, 5, 700).
link(n14, n28, 5, 700).
link(n28, n14, 5, 700).
link(n2, n13, 5, 700).
link(n13, n2, 5, 700).
link(n5, n11, 5, 700).
link(n11, n5, 5, 700).
link(n27, n30, 5, 700).
link(n30, n27, 5, 700).
link(n14, n31, 5, 700).
link(n31, n14, 5, 700).
link(n9, n27, 5, 700).
link(n27, n9, 5, 700).
link(n1, n7, 5, 700).
link(n7, n1, 5, 700).
link(n23, n28, 5, 700).
link(n28, n23, 5, 700).
link(n16, n20, 5, 700).
link(n20, n16, 5, 700).
link(n3, n8, 5, 700).
link(n8, n3, 5, 700).
link(n27, n29, 5, 700).
link(n29, n27, 5, 700).
link(n31, n31, 0, inf).
link(n18, n24, 5, 700).
link(n24, n18, 5, 700).
link(n22, n30, 5, 700).
link(n30, n22, 5, 700).
link(n20, n28, 5, 700).
link(n28, n20, 5, 700).
link(n2, n17, 5, 700).
link(n17, n2, 5, 700).
link(n1, n1, 0, inf).
link(n0, n28, 5, 700).
link(n28, n0, 5, 700).
link(n0, n6, 5, 700).
link(n6, n0, 5, 700).
link(n20, n29, 5, 700).
link(n29, n20, 5, 700).
link(n15, n20, 5, 700).
link(n20, n15, 5, 700).
link(n7, n30, 5, 700).
link(n30, n7, 5, 700).
link(n10, n19, 5, 700).
link(n19, n10, 5, 700).

domain(all, [_]).

