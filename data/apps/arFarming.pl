% service(ServiceId, SType, SWReqs, (Arch, HWReqs)).
service(dynamoDB, database, [mySQL, ubuntu], (x86, 50)).
service(sqs, queue, [python], (x86, 5)).
service(reko, imageRecognition, [python, gcc], (arm64, 10)).
service(quicksight, dashboard, [mySQL, php, js], (x86, 4)).

% function(FunctionId, FType, SWPlatform, (Arch, HWReqs)).
function(camCalibration, camFun, python, (arm64, 8)).
function(imgRectification, imgFun, python, (x86, 4)).
function(roiSelection, imgFun, python, (arm64, 3)).

% thing(ThingId, TType).
thing(sns, sensor).
thing(ctrl, control).
thing(cam, camera).
thing(dsp, display).

% --- APPLICATION --- %
% application(AppId, [Functions], [Services]).
application(arFarming, [calibre, rectify, roiSel],  [mainDB, imgQueue, snsQueue, ctrlQueue, recognizer, visualizer]).

% serviceInstance(SIId, ServiceId).
serviceInstance(mainDB, dynamoDB).
serviceInstance(imgQueue, sqs).
serviceInstance(snsQueue, sqs).
serviceInstance(ctrlQueue, sqs).
serviceInstance(recognizer, reko).
serviceInstance(visualizer, quicksight).

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
dataFlow(soil, snsQueue, snsLevel, [], 0.04, 100, 70).
dataFlow(heat, snsQueue, snsLevel, [], 0.04, 100, 70).
dataFlow(water, snsQueue, snsLevel, [], 0.04, 80, 70).
dataFlow(nutrient, ctrlQueue, ctrlLevel, [], 0.08, 50, 70).
dataFlow(energy, ctrlQueue, ctrlLevel, [], 0.08, 50, 70).
dataFlow(piCamera1, imgQueue, picture, [], 0.5, 100, 100).
dataFlow(piCamera2, imgQueue, picture, [], 0.5, 100, 100).

dataFlow(snsQueue, mainDB, snsLevel, [], 0.04, 90, 70).
dataFlow(ctrlQueue, mainDB, ctrlLevel, [], 0.08, 50, 70).
dataFlow(imgQueue, mainDB, picture, [], 0.5, 100, 200).

dataFlow(imgQueue, calibre, picture, [], 0.5, 100, 30).
dataFlow(calibre, piCamera1, calibrationData, [], 0.01, 50, 30).
dataFlow(calibre, piCamera2, calibrationData, [], 0.01, 50, 30).

dataFlow(imgQueue, rectify, picture, [], 0.5, 150, 30).
dataFlow(rectify, roiSel, rectPicture, [], 0.3, 100, 40).
dataFlow(rectify, recognizer, rectPicture, [], 0.3, 100, 40).
dataFlow(calibre, recognizer, calibrationData, [], 0.01, 50, 30).
dataFlow(roiSel, recognizer, regionData, [], 0.02, 50, 40).

dataFlow(recognizer, visualizer, projectionData, [], 0.02, 100, 50).
dataFlow(imgQueue, visualizer, picture, [], 0.5, 100, 50).
dataFlow(visualizer, arViewer, info, 0.8, 90, 60).