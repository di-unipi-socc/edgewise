% service(ServiceId, SWReqs, (Arch, HWReqs)).
service(database, [mySQL, ubuntu], (x86, 50)).
service(imageDetection, [python, gcc], (x86, 20)).
service(imageRecognition, [python, gcc], (arm64, 10)).

% function(FunctionId, SWPlatform, (Arch, HWReqs)).
function(vehicleTrajectory, python, (x86, 5)).
function(updateStatus, js, (arm64, 2)).

% thing(ThingId, TType).
thing(secCam, camera).

% --- APPLICATION --- %
% application(AppId, [Functions], [Services]).
application(distSecurity, [traje, logger], [mainDB, detector, recognizer]).

% serviceInstance(SIId, ServiceId).
serviceInstance(mainDB, database).
serviceInstance(detector, imageDetection).
serviceInstance(recognizer, imageRecognition).

% functionInstance(FIId, FunctionId, (ReqXMonth, ReqDuration)).
functionInstance(traje, vehicleTrajectory, (1000, 5)).
functionInstance(logger, updateStatus, (1000, 2)).

% thingInstance(TIId, ThingId).
thingInstance(cam11, secCam).
thingInstance(cam12, secCam).
thingInstance(cam21, secCam).
thingInstance(cam22, secCam).

% dataFlow(Source, Dest, DataId, SecReqs, Size, Rate, MaxLat).
dataFlow(cam11, mainDB, detection, [enc], 0.02, 80, 20).
dataFlow(cam21, mainDB, detection, [enc], 0.02, 80, 20).
dataFlow(cam12, detector, detection, [enc], 0.02, 80, 20).
dataFlow(cam22, detector, detection, [enc], 0.02, 80, 20).
dataFlow(detector, recognizer, bbox, [enc], 0.03, 50, 20).
dataFlow(recognizer, traje, plateNumber, [enc], 0.01, 50, 20).
dataFlow(recognizer, mainDB, detection, [enc], 0.02, 50, 50).
dataFlow(mainDB, traje, detection, [enc], 0.1, 50, 20).
dataFlow(traje, logger, detection, [enc], 0.02, 50, 20).
dataFlow(logger, mainDB, status, [enc], 0.05, 50, 20).