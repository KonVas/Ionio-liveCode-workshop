/* switch between different synths using fade time, for this example we will use ProxySpace, see helpfile! */

p = ProxySpace.push(s.boot);

~synth.play;
~synth.fadeTime = 8;
~synth = \grainBuf; //:choose manually but first load the synths below!


//:variate synths through a Tdef

Tdef(\x,{
	var time;
	loop{
		time = rrand(0.3, 10.0);
		~synth.fadeTime = time;
		~synth = [\grainSin, \vint, \grainBuf].choose;
		( "will fade in: " ++ ~synth.at(0)  ++ " fadeTime: " ++ time.round ++ " secs" ).postln;
		0.5.rand + time.wait;

	}
}).play

//:


b = Buffer.readChannel(s, Platform.resourceDir +/+ "sounds/a11wlk01.wav", channels: [0] );
//:test
b.plot;

//:

SynthDef(\grainBuf, {| out, dens = 10, gate = 1, fadeTime = 8, amp = 0.3, sampFreq = 100 |
	var rate, pan, trig;
	pan = LFNoise1.kr(1).range(-1, 1);
	rate = \freq.kr(100, 0.3) / sampFreq;
	trig = Dust.ar(dens);
	OffsetOut.ar(out,
		Pan2.ar(
			PlayBuf.ar(b.numChannels, b, BufRateScale.kr(b) * rate, trig, BufFrames.kr(b) * MouseX.kr(0.1, 0.99, lag:0.3) ), pan, amp )
		* EnvGen.kr(Env.asr(fadeTime,1,fadeTime), gate, doneAction:2);
	)
}).add;


SynthDef(\vint, {| gate = 1, amp = 0.1, out, fadeTime = 8 |
	a = SinOsc.ar(0.1).range(0.1, 0.6);
	c = Splay.ar( SinOsc.ar( {ExpRand(220, 1220.0)}!18, mul:a )  )
	* EnvGen.kr(Env.asr(fadeTime,1,fadeTime), gate, doneAction:2);
	Out.ar(out, c * amp);
}).add;


SynthDef(\grainSin, {|out, fadeTime = 8, gate = 1, dens = 10, grainDur = 0.3, amp = 0.1, freqDev=2|
	var pan, env, impulse, sig, freq;
	impulse = Dust.ar(dens);
	pan = LFNoise1.kr( 1 ).range(-1, 1);
	freq = LFNoise0.kr( 0.1 ).exprange( 200, 1200 );
	sig = GrainSin.ar(2, impulse, grainDur, freq * WhiteNoise.kr(freqDev, 1), pan, -1) *
	EnvGen.kr(Env.asr(fadeTime,1,fadeTime), gate, doneAction:2);
	OffsetOut.ar(out, sig * amp);
}).add

//:

~synth.stop(3);
//:clean up
b.free;