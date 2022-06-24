service(serv1, [sw1, sw2], (x86, 50)).
service(serv2, [sw1], (arm64, 10)).

function(fun1, sw2, (x86, 5)).

thing(thg1, ttype).

application(es, [f1], [s1, s2]).

serviceInstance(s1, serv1).
serviceInstance(s2, serv2).

functionInstance(f1, fun1, (1000, 5)).

thingInstance(t1, thg1).

dataFlow(t1, s1, dd, [enc], 0.05, 10, 20).
dataFlow(s1, s2, dd, [enc], 0.1, 20, 30).
dataFlow(f1, s1, dd, [auth], 0.2, 20, 20).