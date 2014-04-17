//:assign to synth
~synth = \grainBuf;

~synth.fadeTime = 3;

//:make scale
~scale = Scale.ionian

~detune = [20, 50, 80];

//:load some buffer
b = Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01.wav"); // or load yours
b.plot;

(
SynthDef(\grainBuf, {| buf = 0, out = 0, gate = 1, amp = 0.3, release = 0.2, sampFreq = 100 |
	var rate, pan, dev;
	pan = LFNoise1.kr(1).range(-1, 1);
	rate = \freq.kr(440, 0.3) / sampFreq;
	OffsetOut.ar(out,
		Pan2.ar(
			PlayBuf.ar(buf.numChannels, buf, BufRateScale.kr(buf) * rate, 1, \pos.kr(0.1, 0.3) * BufFrames.kr(buf) ), pan )
		* EnvGen.ar(Env.asr(releaseTime:release), gate, doneAction:2) * amp;
	)
}).add;


SynthDef(\vint, {| gate = 1, amp = 0.3, release = 0.2, out = 0 |
	c = VarSaw.ar( \freq.kr(100, 0.3) ) * EnvGen.ar(Env.asr(releaseTime:release), gate, doneAction:2);
	Out.ar(out, c.dup * amp);
}).add;

SynthDef(\grainSin, {|out = 0, gate = 1, grainDur=0.1, amp=0.3, release = 0.2, freqDev=0.01, freq=220|
	var pan, env, impulse, sig;
	pan = LFNoise1.kr(1).range(-1, 1);
	sig = GrainSin.ar(2, 1, grainDur, freq * WhiteNoise.kr(freqDev, 1), pan, -1) *
	EnvGen.ar(Env.asr(releaseTime:release), gate, doneAction:2);
	OffsetOut.ar(out, sig * amp);
}).add
)

(
Pbindef(\x, \dur, Pbrown(0.03, 0.08), \instrument, Pfunc({ ~synth }, inf), \degree, 1,
	\scale, Pfunc({ ~scale },inf), \amp, 0.1, \release, 0.1, \buf, b, \freqDev, 0.5, \detune, Pfunc{ ~detune }).play;
);
)