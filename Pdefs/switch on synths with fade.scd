/* switch between different synths using fade time */

p = ProxySpace.push(s.boot);

~synth.play;
~synth = \vint;


// (
// Tdef(\x,{
// 	loop{
// 		6.wait;
// 		~synth = [\grainSin, \vint, \grainBuf].choose;
// 	}
// }).play
// )
//Tdef(\x).stop

//:load a sound
b = Buffer.readChannel(s, Platform.resourceDir +/+ "sounds/a11wlk01.wav", channels: [0] );
//:test
b.plot;

(
SynthDef(\grainBuf, {| buf = 0, out, dens = 10, gate = 1, fadeTime = 8, amp = 0.1, sampFreq = 100 |
	var rate, pan, trig;
	pan = LFNoise1.kr(1).range(-1, 1);
	rate = \freq.kr(100, 0.3) / sampFreq;
	trig = Dust.ar(dens);
	OffsetOut.ar(out,
		Pan2.ar(
			PlayBuf.ar(buf.numChannels, buf, BufRateScale.kr(buf) * rate, trig, BufFrames.kr(buf) * \pos.kr(0.1, 0.3) ), pan )
		* EnvGen.kr(Env.asr(fadeTime,1,fadeTime), gate, doneAction:2) * amp;
	)
}).add;


SynthDef(\vint, {| gate = 1, amp = 0.1, out, fadeTime = 8 |
	c = VarSaw.ar( LFPulse.kr(3, 0, 0.3, 200, 200) ) * EnvGen.kr(Env.asr(fadeTime,1,fadeTime), gate, doneAction:2);
	Out.ar(out, c.dup * amp);
}).add;


SynthDef(\grainSin, {|out, fadeTime = 8, gate = 1, dens = 10, grainDur = 0.3, amp = 0.1, freqDev=1.5, freq=440|
	var pan, env, impulse, sig;
	impulse = Dust.ar(dens);
	pan = LFNoise1.kr(1).range(-1, 1);
	sig = GrainSin.ar(2, impulse, grainDur, freq * WhiteNoise.kr(freqDev, 1), pan, -1) *
	EnvGen.kr(Env.asr(fadeTime,1,fadeTime), gate, doneAction:2);
	OffsetOut.ar(out, sig * amp);
}).add
)

~synth.stop(3);
//:clean up
b.free;