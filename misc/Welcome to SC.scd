//Welcome to SuperCollider!

n=LFNoise1;Ndef(\x,{a=SinOsc.ar(65,Ndef(\x).ar*n.ar(0.1,3),n.ar(3,6)).tanh;9.do{a=AllpassL.ar(a,0.3,{0.2.rand+0.1}!2,5)};a.tanh}).play;

Ndef(\giMeBass, {SinOscFB.ar([80, 81])* EnvGen.ar(Env.sine(1).plot, Dust.ar(0.15))}).play;

(
Ndef('addy', {
	var out = {SinOsc.ar(ExpRand(120.0, 1220.0), phase:LFNoise1.kr(20).range(0.1, 10)* pi)}!8;
	out = HPF.ar(out, LFNoise1.kr(0.25).range(2, 200));
	out = Mix.ar(out)/8;
}).play;
)


(
Ndef(\dusty, {
	Ringz.ar(Dust.ar(0.3), 1220, 0.9);
}).play;
)

Ndef(\dusty)[1] = \filter -> {|in| PitchShift.ar(in, 1, 0.6, 0.3, add:in)};
