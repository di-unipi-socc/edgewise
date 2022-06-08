% service(ServiceId, SType, SWReqs, (Arch, HWReqs)).
service(dynamoDB, database, [mySQL, ubuntu], (x86, 50)).
service(detekt, imageDetection, [python, gcc], (x86, 20)).
service(reko, imageRecognition, [python, gcc], (arm64, 10)).

% function(FunctionId, FType, SWPlatform, (Arch, HWReqs)).

% thing(ThingId, TType).
thing(secCam, camera).
% --- APPLICATION --- %
% application(AppId, [Functions], [Services]).

% serviceInstance(SIId, ServiceId).

% functionInstance(FIId, FunctionId, (ReqXMonth, ReqDuration)).

% thingInstance(TIId, ThingId).
thingInstance(cam11, secCam).
thingInstance(cam12, secCam).
thingInstance(cam21, secCam).
thingInstance(cam22, secCam).

% dataFlow(Source, Dest, DataId, SecReqs, Size, Rate, MaxLat).