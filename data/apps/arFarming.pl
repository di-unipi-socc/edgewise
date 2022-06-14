% service(ServiceId, SWReqs, (Arch, HWReqs)).
service(database, [mySQL, ubuntu], (x86, 50)).
service(queue, [python], (x86, 5)).
service(imageRecognition, [python, gcc], (arm64, 10)).
service(dashboard, [mySQL, php, js], (x86, 4)).

% function(FunctionId, SWPlatform, (Arch, HWReqs)).
function(camCalibration, python, (arm64, 8)).
function(imgRectification, python, (x86, 4)).
function(roiSelection, python, (arm64, 3)).

% thing(ThingId, TType).
thing(sns, sensor).
thing(ctrl, control).
thing(cam, camera).
thing(dsp, display).

% --- APPLICATION --- %
% application(AppId, [Functions], [Services]).
application(arFarming, [calibre, rectify, roiSel],  [mainDB, imgQueue, snsQueue, ctrlQueue, recognizer, visualizer]).

% serviceInstance(SIId, ServiceId).
serviceInstance(mainDB, database).
serviceInstance(imgQueue, queue).
serviceInstance(snsQueue, queue).
serviceInstance(ctrlQueue, queue).
serviceInstance(recognizer, imageRecognition).
serviceInstance(visualizer, dashboard).

% functionInstance(FIId, FunctionId, (ReqXMonth, ReqDuration)).
functionInstance(calibre, camCalibration, (500, 10)).
functionInstance(rectify, imgRectification, (200, 80)).
functionInstance(roiSel, roiSelection, (400, 30)).


% thingInstance(TIId, ThingId).
thingInstance(soil, sns).
thingInstance(heat, sns).
thingInstance(water, sns).
thingInstance(nutrient, ctrl).
thingInstance(energy, ctrl).
thingInstance(piCamera1, cam).
thingInstance(piCamera2, cam).
thingInstance(arViewer, dsp).

% dataFlow(Source, Dest, DataId, SecReqs, Size, Rate, MaxLat).
dataFlow(soil, snsQueue, snsLevel, [enc], 0.04, 100, 70).
dataFlow(heat, snsQueue, snsLevel, [enc], 0.04, 100, 70).
dataFlow(water, snsQueue, snsLevel, [enc], 0.04, 80, 70).
dataFlow(nutrient, ctrlQueue, ctrlLevel, [enc], 0.08, 50, 70).
dataFlow(energy, ctrlQueue, ctrlLevel, [enc], 0.08, 50, 70).
dataFlow(piCamera1, imgQueue, picture, [enc], 0.5, 100, 100).
dataFlow(piCamera2, imgQueue, picture, [enc], 0.5, 100, 100).

dataFlow(snsQueue, mainDB, snsLevel, [enc], 0.04, 90, 70).
dataFlow(ctrlQueue, mainDB, ctrlLevel, [enc], 0.08, 50, 70).
dataFlow(imgQueue, mainDB, picture, [enc], 0.5, 100, 200).

dataFlow(imgQueue, calibre, picture, [enc], 0.5, 100, 30).
dataFlow(calibre, piCamera1, calibrationData, [enc], 0.01, 50, 30).
dataFlow(calibre, piCamera2, calibrationData, [enc], 0.01, 50, 30).

dataFlow(imgQueue, rectify, picture, [enc], 0.5, 150, 30).
dataFlow(rectify, roiSel, rectPicture, [enc], 0.3, 100, 40).
dataFlow(rectify, recognizer, rectPicture, [enc], 0.3, 100, 40).
dataFlow(calibre, recognizer, calibrationData, [enc], 0.01, 50, 30).
dataFlow(roiSel, recognizer, regionData, [enc], 0.02, 50, 40).

dataFlow(recognizer, visualizer, projectionData, [enc], 0.02, 100, 50).
dataFlow(imgQueue, visualizer, picture, [enc], 0.5, 100, 50).
dataFlow(visualizer, arViewer, info, [enc], 0.8, 90, 60).