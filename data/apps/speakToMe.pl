% service(ServiceId, SWReqs, (Arch, HWReqs)).
service(storage, [ubuntu], (x86, 100)).
service(database, [mySQL, ubuntu], (x86, 50)).
service(queue, [python], (x86, 2)).
service(tts, [python, gcc], (arm64, 4)).

% function(FunctionId, SWPlatform, (Arch, HWReqs)).
function(uploadFun, python, (x86, 20)).
function(metadataFun, python, (arm64, 2)).
function(publishFun, js, (x86, 4)).
function(ttsFun, python, (arm64, 30)).

% thing(ThingId, TType).
thing(smph, smartphone).
thing(spk, speaker).


% --- APPLICATION ---
% application(AppId, [Functions], [Services]).
application(speakToMe, [uploadPost,metaPost,publishPost,convertTxt,uploadAudio,metaAudio], [textBucket,audioBucket,mainDB,postQueue,converter]).

% serviceInstance(SIId, ServiceId).
serviceInstance(textBucket, storage).
serviceInstance(audioBucket, storage).
serviceInstance(mainDB, database).
serviceInstance(postQueue, queue).
serviceInstance(converter, tts).

% functionInstance(FIId, FunctionId, (ReqXMonth, ReqDuration)).
functionInstance(uploadPost, uploadFun, (1000, 30)).
functionInstance(metaPost, metadataFun, (1500, 8)).
functionInstance(publishPost, publishFun, (2000, 8)).
functionInstance(convertTxt, ttsFun, (2500, 30)).
functionInstance(uploadAudio, uploadFun, (1000, 20)).
functionInstance(metaAudio, metadataFun, (2500, 130)).

% thingInstance(TIId, ThingId).
thingInstance(iphoneXS, smph).
thingInstance(echoDot, spk).

% dataFlow(Source, Dest, DataId, SecReqs, Size, Rate, MaxLat).
dataFlow(iphoneXS, uploadPost, post, [enc], 0.01, 5, 500).
dataFlow(uploadPost, textBucket, post, [enc], 0.01, 5, 500).
dataFlow(textBucket, metaPost, post, [enc], 0.01, 6, 500).
dataFlow(metaPost, mainDB, meta, [enc], 0.01, 6, 500).
dataFlow(textBucket, publishPost, post, [enc], 0.004, 5, 500).
dataFlow(publishPost, postQueue, post, [enc], 0.002, 5, 500).
dataFlow(postQueue, convertTxt, post, [enc], 0.002, 8, 400).
dataFlow(convertTxt, converter, post, [enc], 0.002, 8, 400).
dataFlow(converter, convertTxt, speech, [enc], 0.002, 8, 300).
dataFlow(convertTxt, echoDot, speech, [enc], 0.005, 8, 300).
dataFlow(convertTxt, metaAudio, speech, [enc], 0.005, 8, 700).
dataFlow(metaAudio, mainDB, meta, [enc], 0.001, 10, 2000).
dataFlow(convertTxt, uploadAudio, speech, [enc], 0.008, 8, 300).
dataFlow(uploadAudio, audioBucket, speech, [enc], 0.008, 8, 400).