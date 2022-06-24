bwTh(3).
hwTh(1).

node(n1, cloud, [sw1, sw2], (x86, 100), [enc, auth], []).
node(n2, isp, [sw2], (x86, 100), [enc, auth], []).
node(n3, cloud, [sw1], (arm64, 20), [enc, auth], [t1]).

link(n1, n2, 20, 50).
link(n2, n1, 20, 50).
link(n1, n3, 20, 50).
link(n3, n1, 20, 50).
link(n2, n3, 30, 100).
link(n3, n2, 30, 100).