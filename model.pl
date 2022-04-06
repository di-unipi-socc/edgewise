service(ServiceId, SType, SWReqs, (Arch, HWReqs)).
function(FunctionId, FType, SWPlatform, (Arch, HWReqs)).
thing(ThingId, TType).

% --- APPLICATION ---
application(AppId, [FunctionSet], [ServiceSet]).

serviceInstance(SIId, ServiceId).
functionInstance(FIId, FunctionId, (ReqXMonth, ReqDuration)).
thingInstance(TIId, ThingId).

% Source/Dest = {SIId, FIId, IoTId}
% UsedData = [DataIds] (???)
% MaxLat: time for data transfer
dataFlow(Source, Dest, DataId, SecReqs, Size, Rate, MaxLat).

/*
triggers(FIId, [(TriggerId, MaxLat, [DataIds])]).
destinations(FIId, [(DestinationId, MaxLat, [DataIds])]).

data(DataId, SecReqs, Size, Rate).

f2f(F1, F2, MaxLatency).
flowLatency([FIds], MaxLatency). % for critical paths
*/

% --- INFRASTRUCTURE ---
% IoTCaps = [IoTIds]
node(NodeId, NType, SWCaps, (Arch, HWCaps), SecCaps, IoTCaps).

link(N1, N2, Lat, BW).

domain(Area, [SubDomains]).

% --- REQS/COSTS SPECS ---
cost(NType, ServiceId, Cost).
% Type = {SType, FType, TType}
requirements(Type, Service, Node).
