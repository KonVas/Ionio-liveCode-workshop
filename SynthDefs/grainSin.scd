(
SynthDef.new(\grainSin, {|out = 0, release = 0.2, grainDur=0.1, amp=0.1, freqDev=0.01, freq=220|
	var pan, env, impulse, sig;
	pan = LFNoise1.kr(1).range(-1, 1);
	sig = SinOsc.ar( freq * (1 + Rand(freqDev.neg, freqDev)) //not working deviation from freq
	) * EnvGen.kr(Env.perc(0.02, release, amp),  doneAction:2 );
	Out.ar(out,
		Pan2.ar(sig, pan)
	)
}).add
)

Pdef(\x, Pbind(\dur, 0.05, \instrument, \grainSin, \freqDev, 0.3, \freq, 440, \amp, 0.06)).play;