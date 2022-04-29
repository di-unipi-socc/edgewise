% service(ServiceId, SType, SWReqs, (Arch, HWReqs)).
service(s3, storage, [ubuntu], (x86, 50)).
service(dynamoDB, database, [mySQL, ubuntu], (x86, 30)).
service(sns, queue, [python], (x86, 2)).
service(polly, tts, [python, gcc], (arm64, 4)).

% function(FunctionId, FType, SWPlatform, (Arch, HWReqs)).
function(upload, uploadFun, python, (x86, 30)).
function(metadata, metadataFun, python, (arm64, 2)).
function(publish, publishFun, python, (x86, 4)).
function(txtToSpeech, ttsFun, python, (arm64, 30)).

% thing(ThingId, TType).
thing(smph, smartphone).
thing(spk, speaker).


% --- APPLICATION ---
% application(AppId, [Functions], [Services]).
application(speakToMe, [uploadPost,metaPost,publishPost,convertTxt,uploadAudio,metaAudio], [textBucket,audioBucket,mainDB,postQueue,converter]).

% serviceInstance(SIId, ServiceId).
serviceInstance(textBucket, s3).
serviceInstance(audioBucket, s3).
serviceInstance(mainDB, dynamoDB).
serviceInstance(postQueue, sns).
serviceInstance(converter, polly).

% functionInstance(FIId, FunctionId, (ReqXMonth, ReqDuration)).
functionInstance(uploadPost, upload, (1000, 30)).
functionInstance(metaPost, metadata, (1500, 8)).
functionInstance(publishPost, publish, (2000, 8)).
functionInstance(convertTxt, txtToSpeech, (2500, 30)).
functionInstance(uploadAudio, upload, (1000, 20)).
functionInstance(metaAudio, metadata, (2500, 130)).

% thingInstance(TIId, ThingId).
thingInstance(iphoneXS, smph).
thingInstance(echoDot, spk).

% dataFlow(Source, Dest, DataId, SecReqs, Size, Rate, MaxLat).
dataFlow(iphoneXS, uploadPost, post, [enc], 0.4, 5, 60).
dataFlow(uploadPost, textBucket, post, [enc], 0.4, 5, 80).
dataFlow(textBucket, metaPost, post, [enc], 0.4, 10, 40).
dataFlow(metaPost, mainDB, meta, [enc], 0.1, 10, 30).
dataFlow(textBucket, publishPost, post, [enc], 0.4, 5, 60).
dataFlow(publishPost, postQueue, post, [enc, zip], 0.2, 5, 50).
dataFlow(postQueue, convertTxt, post, [enc], 0.2, 8, 40).
dataFlow(convertTxt, converter, post, [enc], 0.2, 8, 40).
dataFlow(converter, convertTxt, speech, [enc], 0.2, 12, 30).
dataFlow(convertTxt, echoDot, speech, [enc], 0.5, 10, 30).
dataFlow(convertTxt, metaAudio, speech, [enc], 0.5, 10, 70).
dataFlow(metaAudio, mainDB, meta, [enc], 0.1, 15, 20).
dataFlow(convertTxt, uploadAudio, speech, [enc], 0.8, 10, 30).
dataFlow(uploadAudio, audioBucket, speech, [enc], 0.8, 10, 40).