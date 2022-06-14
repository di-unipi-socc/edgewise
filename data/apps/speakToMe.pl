% service(ServiceId, SWReqs, (Arch, HWReqs)).
service(storage, [ubuntu], (x86, 100)).
service(database, [mySQL, ubuntu], (x86, 50)).
service(queue, [python], (x86, 2)).
service(tts, [python, gcc], (arm64, 4)).

% function(FunctionId, SWPlatform, (Arch, HWReqs)).
function(uploadFun, python, (x86, 20)).
function(metadataFun, python, (arm64, 2)).
function(publishFun, python, (x86, 4)).
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
dataFlow(iphoneXS, uploadPost, post, [enc], 0.4, 5, 60).
dataFlow(uploadPost, textBucket, post, [enc], 0.4, 5, 80).
dataFlow(textBucket, metaPost, post, [enc], 0.4, 6, 40).
dataFlow(metaPost, mainDB, meta, [enc], 0.1, 6, 30).
dataFlow(textBucket, publishPost, post, [enc], 0.4, 5, 60).
dataFlow(publishPost, postQueue, post, [enc, zip], 0.2, 5, 50).
dataFlow(postQueue, convertTxt, post, [enc], 0.2, 8, 40).
dataFlow(convertTxt, converter, post, [enc], 0.2, 8, 40).
dataFlow(converter, convertTxt, speech, [enc], 0.2, 8, 30).
dataFlow(convertTxt, echoDot, speech, [enc], 0.5, 8, 30).
dataFlow(convertTxt, metaAudio, speech, [enc], 0.5, 8, 70).
dataFlow(metaAudio, mainDB, meta, [enc], 0.1, 10, 20).
dataFlow(convertTxt, uploadAudio, speech, [enc], 0.8, 8, 30).
dataFlow(uploadAudio, audioBucket, speech, [enc], 0.8, 8, 40).