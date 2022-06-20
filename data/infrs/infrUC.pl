% --- INFRASTRUCTURE ---
bwTh(3).
hwTh(1).

% node(NodeId, NodeType, SWCaps, HWCaps, SecCaps, IoTCaps).
node(parkingServices, thing, [python, gcc, mySQL], (x86, 100), [enc, auth], [piCamera1, piCamera2]).
node(westEntry, thing, [ubuntu], (x86, 100), [enc], [echoDot, soil, heat, cam11, cam21]).
node(kleiberHall, thing, [ubuntu, mySQL], (arm64, 150), [enc], [nutrient, energy]).
node(hoaglandAnnex, thing, [ubuntu], (x86, 150), [enc, auth], [iphoneXS]).
node(briggsHall, thing, [ubuntu, mySQL], (arm64, 180), [enc, auth], [water]).
node(mannLab, cabinet, [ubuntu, gcc, python], (arm64, 256), [enc, auth], []).
node(lifeSciences, cabinet, [python, mySQL, php, js], (x86, 256), [enc, auth], [cam12, cam22]).
node(sciencesLectureHall, cabinet, [ubuntu, mySQL, php, js], (arm64, 256), [enc, auth], [arViewer]).
node(firePolice, cabinet, [ubuntu, mySQL, gcc, python], (x86, 512), [enc, auth], []).
node(studentCenter, cabinet, [ubuntu, mySQL, python, php, js], (x86, 512), [enc, auth], []).
node(isp, cloud, [ubuntu, mySQL, gcc, python], (arm64, 600), [enc, auth], []).
node(uc_cloud, cloud, [ubuntu, mySQL, gcc, python, php, js], (x86, 10000), [enc, auth], []).

% link(N1, N2, Lat, BW).
link(parkingServices, westEntry, 15, 100).
link(westEntry, parkingServices, 15, 100).
link(parkingServices, kleiberHall, 15, 100).
link(kleiberHall, parkingServices, 15, 100).
link(parkingServices, hoaglandAnnex, 15, 100).
link(hoaglandAnnex, parkingServices, 15, 100).
link(parkingServices, briggsHall, 15, 100).
link(briggsHall, parkingServices, 15, 100).
link(parkingServices, mannLab, 15, 100).
link(mannLab, parkingServices, 15, 100).
link(parkingServices, lifeSciences, 15, 100).
link(lifeSciences, parkingServices, 15, 100).
link(parkingServices, sciencesLectureHall, 15, 100).
link(sciencesLectureHall, parkingServices, 15, 100).
link(parkingServices, firePolice, 15, 100).
link(firePolice, parkingServices, 15, 100).
link(parkingServices, studentCenter, 15, 100).
link(studentCenter, parkingServices, 15, 100).
link(parkingServices, isp, 15, 100).
link(isp, parkingServices, 15, 100).
link(parkingServices, uc_cloud, 15, 100).
link(uc_cloud, parkingServices, 15, 100).
link(westEntry, kleiberHall, 15, 100).
link(kleiberHall, westEntry, 15, 100).
link(westEntry, hoaglandAnnex, 15, 100).
link(hoaglandAnnex, westEntry, 15, 100).
link(westEntry, briggsHall, 15, 100).
link(briggsHall, westEntry, 15, 100).
link(westEntry, mannLab, 15, 100).
link(mannLab, westEntry, 15, 100).
link(westEntry, lifeSciences, 15, 100).
link(lifeSciences, westEntry, 15, 100).
link(westEntry, sciencesLectureHall, 15, 100).
link(sciencesLectureHall, westEntry, 15, 100).
link(westEntry, firePolice, 15, 100).
link(firePolice, westEntry, 15, 100).
link(westEntry, studentCenter, 15, 100).
link(studentCenter, westEntry, 15, 100).
link(westEntry, isp, 15, 100).
link(isp, westEntry, 15, 100).
link(westEntry, uc_cloud, 15, 100).
link(uc_cloud, westEntry, 15, 100).
link(kleiberHall, hoaglandAnnex, 15, 100).
link(hoaglandAnnex, kleiberHall, 15, 100).
link(kleiberHall, briggsHall, 15, 100).
link(briggsHall, kleiberHall, 15, 100).
link(kleiberHall, mannLab, 15, 100).
link(mannLab, kleiberHall, 15, 100).
link(kleiberHall, lifeSciences, 15, 100).
link(lifeSciences, kleiberHall, 15, 100).
link(kleiberHall, sciencesLectureHall, 15, 100).
link(sciencesLectureHall, kleiberHall, 15, 100).
link(kleiberHall, firePolice, 15, 100).
link(firePolice, kleiberHall, 15, 100).
link(kleiberHall, studentCenter, 15, 100).
link(studentCenter, kleiberHall, 15, 100).
link(kleiberHall, isp, 15, 100).
link(isp, kleiberHall, 15, 100).
link(kleiberHall, uc_cloud, 15, 100).
link(uc_cloud, kleiberHall, 15, 100).
link(hoaglandAnnex, briggsHall, 15, 100).
link(briggsHall, hoaglandAnnex, 15, 100).
link(hoaglandAnnex, mannLab, 15, 100).
link(mannLab, hoaglandAnnex, 15, 100).
link(hoaglandAnnex, lifeSciences, 15, 100).
link(lifeSciences, hoaglandAnnex, 15, 100).
link(hoaglandAnnex, sciencesLectureHall, 15, 100).
link(sciencesLectureHall, hoaglandAnnex, 15, 100).
link(hoaglandAnnex, firePolice, 15, 100).
link(firePolice, hoaglandAnnex, 15, 100).
link(hoaglandAnnex, studentCenter, 15, 100).
link(studentCenter, hoaglandAnnex, 15, 100).
link(hoaglandAnnex, isp, 15, 100).
link(isp, hoaglandAnnex, 15, 100).
link(hoaglandAnnex, uc_cloud, 15, 100).
link(uc_cloud, hoaglandAnnex, 15, 100).
link(briggsHall, mannLab, 15, 100).
link(mannLab, briggsHall, 15, 100).
link(briggsHall, lifeSciences, 15, 100).
link(lifeSciences, briggsHall, 15, 100).
link(briggsHall, sciencesLectureHall, 15, 100).
link(sciencesLectureHall, briggsHall, 15, 100).
link(briggsHall, firePolice, 15, 100).
link(firePolice, briggsHall, 15, 100).
link(briggsHall, studentCenter, 15, 100).
link(studentCenter, briggsHall, 15, 100).
link(briggsHall, isp, 15, 100).
link(isp, briggsHall, 15, 100).
link(briggsHall, uc_cloud, 15, 100).
link(uc_cloud, briggsHall, 15, 100).
link(mannLab, lifeSciences, 15, 100).
link(lifeSciences, mannLab, 15, 100).
link(mannLab, sciencesLectureHall, 15, 100).
link(sciencesLectureHall, mannLab, 15, 100).
link(mannLab, firePolice, 15, 100).
link(firePolice, mannLab, 15, 100).
link(mannLab, studentCenter, 15, 100).
link(studentCenter, mannLab, 15, 100).
link(mannLab, isp, 15, 100).
link(isp, mannLab, 15, 100).
link(mannLab, uc_cloud, 15, 100).
link(uc_cloud, mannLab, 15, 100).
link(lifeSciences, sciencesLectureHall, 15, 100).
link(sciencesLectureHall, lifeSciences, 15, 100).
link(lifeSciences, firePolice, 15, 100).
link(firePolice, lifeSciences, 15, 100).
link(lifeSciences, studentCenter, 15, 100).
link(studentCenter, lifeSciences, 15, 100).
link(lifeSciences, isp, 15, 100).
link(isp, lifeSciences, 15, 100).
link(lifeSciences, uc_cloud, 15, 100).
link(uc_cloud, lifeSciences, 15, 100).
link(sciencesLectureHall, firePolice, 15, 100).
link(firePolice, sciencesLectureHall, 15, 100).
link(sciencesLectureHall, studentCenter, 15, 100).
link(studentCenter, sciencesLectureHall, 15, 100).
link(sciencesLectureHall, isp, 15, 100).
link(isp, sciencesLectureHall, 15, 100).
link(sciencesLectureHall, uc_cloud, 15, 100).
link(uc_cloud, sciencesLectureHall, 15, 100).
link(firePolice, studentCenter, 15, 100).
link(studentCenter, firePolice, 15, 100).
link(firePolice, isp, 15, 100).
link(isp, firePolice, 15, 100).
link(firePolice, uc_cloud, 15, 100).
link(uc_cloud, firePolice, 15, 100).
link(studentCenter, isp, 15, 100).
link(isp, studentCenter, 15, 100).
link(studentCenter, uc_cloud, 15, 100).
link(uc_cloud, studentCenter, 15, 100).
link(isp, uc_cloud, 15, 100).
link(uc_cloud, isp, 15, 100).


% domain(Area, [SubDomains]).
domain(europe, [uc_research, eu_clouds]).
domain(eu_clouds, [azure_europe, aws_europe, uc_cloud]).
domain(azure_europe, [azure_berlin, azure_dublin]).
domain(aws_europe, [aws_amsterdam, aws_dublin]).
domain(uc_research, [uc_halls, uc_datacenter, uc_campus]).
domain(uc_halls, [kleiberHall, briggsHall, sciencesLectureHall]).
domain(uc_datacenter, [mannLab, studentCenter, isp]).
domain(uc_campus, [parkingServices, westEntry, hoaglandAnnex, lifeSciences, firePolice]).