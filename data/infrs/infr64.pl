bwTh(3).
hwTh(1).

node(n50, cabinet, [python, ubuntu, gcc, mySQL], (x86, 128), [enc, auth], []).
node(n53, isp, [js, mySQL], (arm64, 512), [enc], []).
node(n60, cloud, [ubuntu, mySQL, python, js, gcc], (x86, 1024), [enc, auth], []).
node(n34, cabinet, [js, python, gcc, ubuntu], (arm64, 128), [enc, auth], []).
node(n56, cabinet, [gcc, ubuntu], (x86, 256), [enc, auth], []).
node(n62, cabinet, [python, gcc, mySQL], (x86, 128), [enc, auth], []).
node(n10, cabinet, [gcc, mySQL, ubuntu], (arm64, 128), [enc, auth], []).
node(n35, isp, [js, gcc, python], (x86, 512), [enc], []).
node(n5, isp, [mySQL, ubuntu], (x86, 512), [enc], []).
node(n32, cabinet, [ubuntu, python, mySQL, js], (arm64, 128), [enc, auth], []).
node(n1, cabinet, [js, gcc], (arm64, 256), [enc, auth], [cam21]).
node(n28, isp, [js, gcc, python], (x86, 256), [enc], []).
node(n8, isp, [ubuntu, js], (x86, 256), [enc], []).
node(n52, accesspoint, [js, mySQL, python], (x86, 64), [enc, auth], []).
node(n4, thing, [js, gcc], (x86, 32), [enc, auth], [cam22, energy, water]).
node(n37, cabinet, [js, python], (x86, 128), [enc, auth], []).
node(n26, cabinet, [mySQL, ubuntu, js], (arm64, 128), [enc, auth], []).
node(n7, thing, [mySQL], (x86, 32), [enc, auth], [iphoneXS, nutrient]).
node(n45, thing, [gcc, mySQL], (x86, 32), [enc, auth], []).
node(n57, isp, [python, mySQL, js], (arm64, 512), [enc], []).
node(n24, thing, [python], (arm64, 32), [enc, auth], []).
node(n15, cloud, [ubuntu, mySQL, python, js, gcc], (arm64, 1024), [enc, auth], []).
node(n14, isp, [python, gcc, mySQL], (arm64, 256), [enc], []).
node(n27, thing, [ubuntu, python, js], (x86, 32), [enc, auth], []).
node(n9, thing, [gcc, js, ubuntu], (arm64, 32), [enc, auth], []).
node(n36, accesspoint, [ubuntu, gcc, mySQL], (x86, 64), [enc, auth], []).
node(n49, isp, [ubuntu, gcc], (x86, 512), [enc], []).
node(n2, cabinet, [gcc, js], (arm64, 256), [enc, auth], [arViewer, heat]).
node(n55, isp, [js, mySQL, ubuntu, python], (arm64, 512), [enc], []).
node(n0, thing, [mySQL], (x86, 32), [enc, auth], [soil, cam11, echoDot]).
node(n61, cloud, [ubuntu, mySQL, python, js, gcc], (arm64, 1024), [enc, auth], []).
node(n43, isp, [ubuntu, mySQL, python], (arm64, 256), [enc], []).
node(n20, thing, [gcc, python, mySQL], (x86, 32), [enc, auth], []).
node(n17, isp, [ubuntu, js, mySQL, python], (arm64, 512), [enc], []).
node(n33, cabinet, [js, python], (arm64, 128), [enc, auth], []).
node(n59, accesspoint, [python, js, ubuntu], (arm64, 64), [enc, auth], []).
node(n12, cabinet, [python, mySQL], (arm64, 128), [enc, auth], []).
node(n30, accesspoint, [gcc, mySQL], (x86, 64), [enc, auth], []).
node(n25, cabinet, [js, ubuntu, python, gcc], (x86, 256), [enc, auth], []).
node(n39, accesspoint, [gcc, mySQL], (arm64, 64), [enc, auth], []).
node(n47, cabinet, [mySQL, gcc, python, js], (arm64, 128), [enc, auth], []).
node(n31, cabinet, [mySQL, ubuntu, python], (x86, 128), [enc, auth], []).
node(n63, cloud, [ubuntu, mySQL, python, js, gcc], (x86, 1024), [enc, auth], []).
node(n42, cabinet, [gcc, mySQL], (x86, 128), [enc, auth], []).
node(n38, cabinet, [mySQL, gcc, js], (arm64, 128), [enc, auth], []).
node(n29, isp, [gcc, ubuntu], (x86, 256), [enc], []).
node(n11, cabinet, [ubuntu, python, mySQL], (x86, 256), [enc, auth], []).
node(n22, cabinet, [js, ubuntu, mySQL], (arm64, 128), [enc, auth], []).
node(n44, cabinet, [python, mySQL], (x86, 128), [enc, auth], []).
node(n41, accesspoint, [python, ubuntu, mySQL], (arm64, 64), [enc, auth], []).
node(n54, accesspoint, [js, ubuntu, python, mySQL], (x86, 64), [enc, auth], []).
node(n18, isp, [js, ubuntu, mySQL], (x86, 256), [enc], []).
node(n58, isp, [gcc, mySQL], (x86, 256), [enc], []).
node(n51, accesspoint, [mySQL, ubuntu], (arm64, 64), [enc, auth], []).
node(n13, accesspoint, [gcc, mySQL, js, ubuntu], (arm64, 64), [enc, auth], []).
node(n19, cabinet, [ubuntu, js, python, mySQL], (arm64, 256), [enc, auth], []).
node(n6, cabinet, [ubuntu, js], (arm64, 128), [enc, auth], [cam12]).
node(n46, thing, [python, gcc, ubuntu], (arm64, 32), [enc, auth], []).
node(n21, cloud, [ubuntu, mySQL, python, js, gcc], (x86, 1024), [enc, auth], []).
node(n3, thing, [mySQL], (x86, 32), [enc, auth], [piCamera2, piCamera1]).
node(n16, accesspoint, [js, python, ubuntu, mySQL], (arm64, 64), [enc, auth], []).
node(n48, isp, [mySQL, js], (arm64, 256), [enc], []).
node(n40, isp, [mySQL, ubuntu, gcc, js], (arm64, 512), [enc], []).
node(n23, cloud, [ubuntu, mySQL, python, js, gcc], (x86, 1024), [enc, auth], []).

link(n7, n21, 150, 50).
link(n9, n14, 40, 50).
link(n8, n45, 20, 1000).
link(n17, n50, 25, 500).
link(n48, n59, 38, 50).
link(n1, n8, 25, 50).
link(n1, n18, 25, 50).
link(n7, n22, 15, 50).
link(n32, n49, 25, 50).
link(n0, n4, 15, 50).
link(n12, n38, 20, 100).
link(n4, n7, 15, 50).
link(n48, n61, 110, 1000).
link(n30, n55, 38, 80).
link(n5, n19, 25, 500).
link(n11, n19, 20, 100).
link(n9, n25, 15, 50).
link(n7, n28, 40, 50).
link(n7, n27, 15, 50).
link(n12, n33, 20, 100).
link(n1, n21, 135, 100).
link(n19, n45, 15, 35).
link(n11, n14, 25, 50).
link(n10, n58, 25, 50).
link(n6, n63, 135, 100).
link(n0, n9, 15, 50).
link(n10, n47, 20, 100).
link(n15, n57, 110, 1000).
link(n7, n53, 40, 50).
link(n8, n44, 25, 500).
link(n46, n52, 2, 20).
link(n1, n38, 20, 100).
link(n29, n48, 20, 1000).
link(n5, n7, 20, 1000).
link(n11, n56, 20, 100).
link(n9, n33, 15, 50).
link(n19, n23, 135, 100).
link(n8, n18, 20, 1000).
link(n8, n16, 38, 50).
link(n8, n30, 38, 50).
link(n35, n40, 20, 1000).
link(n34, n63, 135, 100).
link(n28, n61, 110, 1000).
link(n7, n10, 15, 50).
link(n32, n48, 25, 50).
link(n5, n14, 20, 1000).
link(n11, n12, 20, 100).
link(n8, n34, 25, 500).
link(n7, n55, 40, 50).
link(n0, n34, 15, 50).
link(n6, n10, 20, 100).
link(n9, n34, 15, 50).
link(n16, n30, 10, 10).
link(n40, n45, 20, 1000).
link(n0, n14, 40, 50).
link(n9, n20, 15, 50).
link(n10, n12, 20, 100).
link(n6, n7, 15, 35).
link(n4, n22, 15, 50).
link(n14, n29, 20, 1000).
link(n12, n63, 135, 100).
link(n7, n20, 15, 50).
link(n10, n14, 25, 50).
link(n3, n25, 15, 50).
link(n18, n35, 20, 1000).
link(n3, n28, 40, 50).
link(n0, n35, 40, 50).
link(n20, n51, 2, 20).
link(n5, n13, 38, 50).
link(n0, n55, 40, 50).
link(n31, n60, 135, 100).
link(n15, n33, 135, 100).
link(n13, n17, 38, 80).
link(n4, n12, 15, 50).
link(n27, n58, 40, 50).
link(n11, n49, 25, 50).
link(n21, n35, 110, 1000).
link(n1, n60, 135, 100).
link(n5, n36, 38, 50).
link(n11, n29, 25, 50).
link(n29, n34, 25, 500).
link(n20, n39, 2, 20).
link(n30, n35, 38, 80).
link(n46, n55, 40, 50).
link(n33, n39, 13, 50).
link(n9, n22, 15, 50).
link(n24, n46, 15, 50).
link(n38, n42, 20, 100).
link(n38, n54, 13, 50).
link(n7, n44, 15, 50).
link(n3, n30, 2, 20).
link(n22, n25, 20, 100).
link(n9, n26, 15, 50).
link(n11, n31, 20, 100).
link(n27, n43, 40, 50).
link(n14, n17, 20, 1000).
link(n55, n59, 38, 50).
link(n27, n37, 15, 50).
link(n3, n32, 15, 50).
link(n11, n36, 13, 50).
link(n0, n63, 150, 50).
link(n0, n47, 15, 50).
link(n7, n11, 15, 50).
link(n50, n51, 13, 50).
link(n29, n62, 25, 500).
link(n11, n15, 135, 100).
link(n21, n53, 110, 1000).
link(n1, n31, 20, 100).
link(n10, n13, 13, 50).
link(n17, n38, 25, 500).
link(n18, n45, 20, 1000).
link(n9, n31, 15, 50).
link(n0, n51, 2, 20).
link(n40, n48, 20, 1000).
link(n24, n61, 150, 50).
link(n0, n11, 15, 50).
link(n29, n43, 20, 1000).
link(n4, n8, 40, 50).
link(n4, n9, 15, 50).
link(n9, n10, 15, 50).
link(n17, n28, 20, 1000).
link(n0, n2, 15, 50).
link(n0, n46, 15, 50).
link(n6, n22, 20, 100).
link(n7, n8, 40, 50).
link(n7, n18, 40, 50).
link(n10, n16, 13, 50).
link(n8, n21, 110, 1000).
link(n16, n46, 2, 20).
link(n11, n18, 25, 50).
link(n21, n59, 148, 20).
link(n17, n41, 38, 50).
link(n21, n28, 110, 1000).
link(n0, n32, 15, 50).
link(n24, n29, 40, 50).
link(n15, n20, 150, 18).
link(n9, n51, 2, 20).
link(n7, n24, 15, 50).
link(n15, n16, 148, 20).
link(n3, n21, 150, 50).
link(n3, n9, 15, 50).
link(n8, n52, 38, 50).
link(n0, n1, 15, 50).
link(n9, n24, 15, 50).
link(n0, n8, 40, 50).
link(n4, n62, 15, 50).
link(n22, n48, 25, 50).
link(n22, n24, 15, 35).
link(n9, n38, 15, 50).
link(n16, n52, 10, 10).
link(n37, n57, 25, 50).
link(n29, n32, 25, 500).
link(n10, n15, 135, 100).
link(n12, n20, 15, 35).
link(n10, n62, 20, 100).
link(n33, n44, 20, 100).
link(n9, n40, 40, 50).
link(n18, n61, 110, 1000).
link(n13, n32, 13, 80).
link(n5, n50, 25, 500).
link(n5, n17, 20, 1000).
link(n17, n35, 20, 1000).
link(n1, n32, 20, 100).
link(n25, n43, 25, 50).
link(n12, n37, 20, 100).
link(n11, n53, 25, 50).
link(n18, n59, 38, 50).
link(n8, n28, 20, 1000).
link(n0, n5, 40, 50).
link(n9, n42, 15, 50).
link(n0, n26, 15, 50).
link(n27, n49, 40, 50).
link(n10, n35, 25, 50).
link(n5, n8, 20, 1000).
link(n20, n37, 15, 50).
link(n17, n29, 20, 1000).
link(n9, n16, 2, 20).
link(n17, n40, 20, 1000).
link(n32, n56, 20, 100).
link(n25, n61, 135, 100).
link(n22, n54, 13, 50).
link(n17, n49, 20, 1000).
link(n38, n52, 13, 50).
link(n7, n31, 15, 50).
link(n19, n52, 13, 50).
link(n15, n56, 135, 100).
link(n5, n10, 25, 500).
link(n12, n26, 20, 100).
link(n3, n46, 15, 50).
link(n6, n26, 20, 100).
link(n8, n62, 25, 500).
link(n6, n55, 25, 50).
link(n25, n26, 20, 100).
link(n14, n36, 38, 50).
link(n9, n36, 2, 20).
link(n8, n11, 25, 500).
link(n23, n30, 148, 20).
link(n14, n15, 110, 1000).
link(n6, n48, 25, 50).
link(n17, n22, 25, 500).
link(n8, n43, 20, 1000).
link(n49, n54, 38, 50).
link(n17, n27, 20, 1000).
link(n5, n11, 25, 500).
link(n8, n56, 25, 500).
link(n14, n58, 20, 1000).
link(n8, n46, 20, 1000).
link(n19, n24, 15, 35).
link(n5, n9, 20, 1000).
link(n20, n48, 40, 50).
link(n3, n53, 40, 50).
link(n6, n44, 20, 100).
link(n3, n63, 150, 50).
link(n3, n47, 15, 50).
link(n2, n25, 20, 100).
link(n21, n23, 20, 1000).
link(n11, n62, 20, 100).
link(n18, n27, 20, 1000).
link(n41, n50, 13, 80).
link(n28, n33, 25, 500).
link(n6, n46, 15, 35).
link(n54, n56, 13, 80).
link(n3, n7, 15, 50).
link(n18, n49, 20, 1000).
link(n4, n15, 150, 50).
link(n27, n42, 15, 50).
link(n8, n9, 20, 1000).
link(n49, n57, 20, 1000).
link(n47, n54, 13, 50).
link(n48, n54, 38, 50).
link(n6, n16, 13, 50).
link(n7, n17, 40, 50).
link(n1, n34, 20, 100).
link(n31, n39, 13, 50).
link(n43, n44, 25, 500).
link(n0, n21, 150, 50).
link(n41, n47, 13, 80).
link(n5, n23, 110, 1000).
link(n17, n20, 20, 1000).
link(n11, n37, 20, 100).
link(n6, n58, 25, 50).
link(n25, n36, 13, 50).
link(n7, n60, 150, 50).
link(n43, n50, 25, 500).
link(n11, n32, 20, 100).
link(n29, n31, 25, 500).
link(n37, n45, 15, 35).
link(n3, n12, 15, 50).
link(n11, n41, 13, 50).
link(n9, n23, 150, 50).
link(n52, n57, 38, 80).
link(n0, n33, 15, 50).
link(n9, n21, 150, 50).
link(n18, n34, 25, 500).
link(n20, n30, 2, 20).
link(n2, n37, 20, 100).
link(n0, n19, 15, 50).
link(n9, n43, 40, 50).
link(n8, n12, 25, 500).
link(n32, n43, 25, 50).
link(n4, n42, 15, 50).
link(n10, n18, 25, 50).
link(n7, n13, 2, 20).
link(n8, n13, 38, 50).
link(n4, n19, 15, 50).
link(n1, n15, 135, 100).
link(n1, n11, 20, 100).
link(n3, n23, 150, 50).
link(n10, n41, 13, 50).
link(n11, n23, 135, 100).
link(n0, n6, 15, 50).
link(n9, n11, 15, 50).
link(n16, n22, 13, 80).
link(n24, n27, 15, 50).
link(n16, n60, 148, 50).
link(n9, n39, 2, 20).
link(n1, n7, 15, 35).
link(n4, n10, 15, 50).
link(n29, n56, 25, 500).
link(n0, n7, 15, 50).
link(n11, n17, 25, 50).
link(n7, n41, 2, 20).
link(n36, n57, 38, 80).
link(n35, n36, 38, 50).
link(n17, n33, 25, 500).
link(n14, n25, 25, 500).
link(n0, n13, 2, 20).
link(n9, n13, 2, 20).
link(n8, n19, 25, 500).
link(n15, n41, 148, 20).
link(n22, n42, 20, 100).
link(n11, n38, 20, 100).
link(n21, n26, 135, 100).
link(n6, n49, 25, 50).
link(n21, n41, 148, 20).
link(n41, n60, 148, 50).
link(n4, n38, 15, 50).
link(n9, n19, 15, 50).
link(n27, n55, 40, 50).
link(n0, n39, 2, 20).
link(n7, n14, 40, 50).
link(n8, n58, 20, 1000).
link(n5, n24, 20, 1000).
link(n25, n54, 13, 50).
link(n11, n16, 13, 50).
link(n26, n53, 25, 50).
link(n28, n50, 25, 500).
link(n11, n51, 13, 50).
link(n8, n17, 20, 1000).
link(n26, n31, 20, 100).
link(n2, n62, 20, 100).
link(n0, n3, 15, 50).
link(n8, n47, 25, 500).
link(n11, n24, 15, 35).
link(n24, n30, 2, 20).
link(n18, n25, 25, 500).
link(n19, n40, 25, 50).
link(n12, n18, 25, 50).
link(n26, n37, 20, 100).
link(n8, n53, 20, 1000).
link(n7, n57, 40, 50).
link(n29, n60, 110, 1000).
link(n1, n29, 25, 50).
link(n27, n63, 150, 50).
link(n37, n61, 135, 100).
link(n8, n10, 25, 500).
link(n8, n29, 20, 1000).
link(n41, n45, 2, 20).
link(n27, n52, 2, 20).
link(n11, n28, 25, 50).
link(n8, n15, 110, 1000).
link(n25, n44, 20, 100).
link(n32, n58, 25, 50).
link(n25, n27, 15, 35).
link(n11, n42, 20, 100).
link(n16, n47, 13, 80).
link(n7, n12, 15, 50).
link(n7, n59, 2, 20).
link(n27, n40, 40, 50).
link(n30, n40, 38, 80).
link(n30, n59, 10, 10).
link(n31, n50, 20, 100).
link(n17, n39, 38, 50).
link(n8, n51, 38, 50).
link(n8, n20, 20, 1000).
link(n16, n27, 2, 20).
link(n2, n9, 15, 35).
link(n3, n8, 40, 50).

domain(all, [_]).

