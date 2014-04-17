(
SynthDef.new(\grainSin, {|out = 0, release = 0.2, grainDur=0.1, amp=0.6, freqDev=0.01, freq=220|
	var pan, env, impulse, sig;
	pan = LFNoise1.kr(1).range(-1, 1);
	sig = GrainSin.ar(2, 1, grainDur, freq * WhiteNoise.kr(freqDev, 1), pan, -1) *
	EnvGen.kr(Env.perc(0.02, release, amp),  doneAction:2 );
	OffsetOut.ar(out, sig);
}).add
)

//:test
x = Synth(\grain, [\freq, 800])
