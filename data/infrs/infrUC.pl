% --- INFRASTRUCTURE ---
bwTh(3).
hwTh(1).

% node(NodeId, NodeType, SWCaps, HWCaps, SecCaps, IoTCaps).
node(parkingServices, thing, [python, gcc, mySQL], (x86, 100), [encryption, auth], [piCamera1, piCamera2]).
node(westEntry, thing, [ubuntu], (x86, 100), [encryption], [echoDot, soil, heat]).
node(kleiberHall, thing, [ubuntu, mySQL], (arm64, 150), [encryption], [nutrient, energy]).
node(hoaglandAnnex, thing, [ubuntu], (x86, 150), [auth], [iphoneXS]).
node(briggsHall, thing, [ubuntu, mySQL], (arm64, 180), [auth], [water]).
node(mannLab, cabinet, [ubuntu, gcc, python], (arm64, 256), [encryption, auth], []).
node(lifeSciences, cabinet, [python, mySQL, php, js], (x86, 256), [encryption, auth], []).
node(sciencesLectureHall, cabinet, [ubuntu, mySQL, php, js], (arm64, 256), [encryption, auth], [arViewer]).
node(firePolice, cabinet, [ubuntu, mySQL, gcc, python], (x86, 512), [encryption, auth], []).
node(studentCenter, cabinet, [ubuntu, mySQL, python, php, js], (x86, 512), [encryption, auth], []).
node(isp, cloud, [ubuntu, mySQL, gcc, python], (arm64, 600), [encryption, auth], []).
node(uc_cloud, cloud, [ubuntu, mySQL, gcc, python, php, js], (x86, 10000), [encryption, auth], []).

% link(N1, N2, Lat, BW).
link(parkingServices, westEntry, 10, 70).
link(westEntry, parkingServices, 10, 70).
link(parkingServices, kleiberHall, 10, 70).
link(kleiberHall, parkingServices, 10, 70).
link(parkingServices, hoaglandAnnex, 10, 70).
link(hoaglandAnnex, parkingServices, 10, 70).
link(parkingServices, briggsHall, 10, 70).
link(briggsHall, parkingServices, 10, 70).
link(parkingServices, mannLab, 10, 70).
link(mannLab, parkingServices, 10, 70).
link(parkingServices, lifeSciences, 10, 70).
link(lifeSciences, parkingServices, 10, 70).
link(parkingServices, sciencesLectureHall, 10, 70).
link(sciencesLectureHall, parkingServices, 10, 70).
link(parkingServices, firePolice, 10, 70).
link(firePolice, parkingServices, 10, 70).
link(parkingServices, studentCenter, 10, 70).
link(studentCenter, parkingServices, 10, 70).
link(parkingServices, isp, 10, 70).
link(isp, parkingServices, 10, 70).
link(parkingServices, uc_cloud, 10, 70).
link(uc_cloud, parkingServices, 10, 70).
link(westEntry, kleiberHall, 10, 70).
link(kleiberHall, westEntry, 10, 70).
link(westEntry, hoaglandAnnex, 10, 70).
link(hoaglandAnnex, westEntry, 10, 70).
link(westEntry, briggsHall, 10, 70).
link(briggsHall, westEntry, 10, 70).
link(westEntry, mannLab, 10, 70).
link(mannLab, westEntry, 10, 70).
link(westEntry, lifeSciences, 10, 70).
link(lifeSciences, westEntry, 10, 70).
link(westEntry, sciencesLectureHall, 10, 70).
link(sciencesLectureHall, westEntry, 10, 70).
link(westEntry, firePolice, 10, 70).
link(firePolice, westEntry, 10, 70).
link(westEntry, studentCenter, 10, 70).
link(studentCenter, westEntry, 10, 70).
link(westEntry, isp, 10, 70).
link(isp, westEntry, 10, 70).
link(westEntry, uc_cloud, 10, 70).
link(uc_cloud, westEntry, 10, 70).
link(kleiberHall, hoaglandAnnex, 10, 70).
link(hoaglandAnnex, kleiberHall, 10, 70).
link(kleiberHall, briggsHall, 10, 70).
link(briggsHall, kleiberHall, 10, 70).
link(kleiberHall, mannLab, 10, 70).
link(mannLab, kleiberHall, 10, 70).
link(kleiberHall, lifeSciences, 10, 70).
link(lifeSciences, kleiberHall, 10, 70).
link(kleiberHall, sciencesLectureHall, 10, 70).
link(sciencesLectureHall, kleiberHall, 10, 70).
link(kleiberHall, firePolice, 10, 70).
link(firePolice, kleiberHall, 10, 70).
link(kleiberHall, studentCenter, 10, 70).
link(studentCenter, kleiberHall, 10, 70).
link(kleiberHall, isp, 10, 70).
link(isp, kleiberHall, 10, 70).
link(kleiberHall, uc_cloud, 10, 70).
link(uc_cloud, kleiberHall, 10, 70).
link(hoaglandAnnex, briggsHall, 10, 70).
link(briggsHall, hoaglandAnnex, 10, 70).
link(hoaglandAnnex, mannLab, 10, 70).
link(mannLab, hoaglandAnnex, 10, 70).
link(hoaglandAnnex, lifeSciences, 10, 70).
link(lifeSciences, hoaglandAnnex, 10, 70).
link(hoaglandAnnex, sciencesLectureHall, 10, 70).
link(sciencesLectureHall, hoaglandAnnex, 10, 70).
link(hoaglandAnnex, firePolice, 10, 70).
link(firePolice, hoaglandAnnex, 10, 70).
link(hoaglandAnnex, studentCenter, 10, 70).
link(studentCenter, hoaglandAnnex, 10, 70).
link(hoaglandAnnex, isp, 10, 70).
link(isp, hoaglandAnnex, 10, 70).
link(hoaglandAnnex, uc_cloud, 10, 70).
link(uc_cloud, hoaglandAnnex, 10, 70).
link(briggsHall, mannLab, 10, 70).
link(mannLab, briggsHall, 10, 70).
link(briggsHall, lifeSciences, 10, 70).
link(lifeSciences, briggsHall, 10, 70).
link(briggsHall, sciencesLectureHall, 10, 70).
link(sciencesLectureHall, briggsHall, 10, 70).
link(briggsHall, firePolice, 10, 70).
link(firePolice, briggsHall, 10, 70).
link(briggsHall, studentCenter, 10, 70).
link(studentCenter, briggsHall, 10, 70).
link(briggsHall, isp, 10, 70).
link(isp, briggsHall, 10, 70).
link(briggsHall, uc_cloud, 10, 70).
link(uc_cloud, briggsHall, 10, 70).
link(mannLab, lifeSciences, 10, 70).
link(lifeSciences, mannLab, 10, 70).
link(mannLab, sciencesLectureHall, 10, 70).
link(sciencesLectureHall, mannLab, 10, 70).
link(mannLab, firePolice, 10, 70).
link(firePolice, mannLab, 10, 70).
link(mannLab, studentCenter, 10, 70).
link(studentCenter, mannLab, 10, 70).
link(mannLab, isp, 10, 70).
link(isp, mannLab, 10, 70).
link(mannLab, uc_cloud, 10, 70).
link(uc_cloud, mannLab, 10, 70).
link(lifeSciences, sciencesLectureHall, 10, 70).
link(sciencesLectureHall, lifeSciences, 10, 70).
link(lifeSciences, firePolice, 10, 70).
link(firePolice, lifeSciences, 10, 70).
link(lifeSciences, studentCenter, 10, 70).
link(studentCenter, lifeSciences, 10, 70).
link(lifeSciences, isp, 10, 70).
link(isp, lifeSciences, 10, 70).
link(lifeSciences, uc_cloud, 10, 70).
link(uc_cloud, lifeSciences, 10, 70).
link(sciencesLectureHall, firePolice, 10, 70).
link(firePolice, sciencesLectureHall, 10, 70).
link(sciencesLectureHall, studentCenter, 10, 70).
link(studentCenter, sciencesLectureHall, 10, 70).
link(sciencesLectureHall, isp, 10, 70).
link(isp, sciencesLectureHall, 10, 70).
link(sciencesLectureHall, uc_cloud, 10, 70).
link(uc_cloud, sciencesLectureHall, 10, 70).
link(firePolice, studentCenter, 10, 70).
link(studentCenter, firePolice, 10, 70).
link(firePolice, isp, 10, 70).
link(isp, firePolice, 10, 70).
link(firePolice, uc_cloud, 10, 70).
link(uc_cloud, firePolice, 10, 70).
link(studentCenter, isp, 10, 70).
link(isp, studentCenter, 10, 70).
link(studentCenter, uc_cloud, 10, 70).
link(uc_cloud, studentCenter, 10, 70).
link(isp, uc_cloud, 10, 70).
link(uc_cloud, isp, 10, 70).


% domain(Area, [SubDomains]).
domain(europe, [uc_research, eu_clouds]).
domain(eu_clouds, [azure_europe, aws_europe, uc_cloud]).
domain(azure_europe, [azure_berlin, azure_dublin]).
domain(aws_europe, [aws_amsterdam, aws_dublin]).
domain(uc_research, [uc_halls, uc_datacenter, uc_campus]).
domain(uc_halls, [kleiberHall, briggsHall, sciencesLectureHall]).
domain(uc_datacenter, [mannLab, studentCenter, isp]).
domain(uc_campus, [parkingServices, westEntry, hoaglandAnnex, lifeSciences, firePolice]).