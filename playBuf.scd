~b = Buffer.loadDialog(s); //:load your own sample

(
SynthDef(\playRate, {|out=0, freq=440, sampFreq=100, gate=1, buf, start=0, mix=0.0, room=0.0, maxdel=0.0, deltime=0.0, decay=0.0, amp=0.1|
	var sig, pan, del, rate, startPos;
	startPos = BufFrames.kr(buf) * start;
	rate = freq / sampFreq;
	pan = LFNoise1.kr(1).range(-1, 1);
sig = FreeVerb.ar(

		PlayBuf.ar(buf.numChannels, buf, BufRateScale.kr(buf) * rate, startPos:startPos, loop:0, doneAction:2),
		mix, room)
	*
        EnvGen.kr(Env.sine(BufDur.kr(buf)));

	del = CombC.ar(sig, maxdel, deltime, decay, 1, sig);
	Out.ar(out,
		Rotate2.ar(sig, del, pan)
	) * amp
}).add;//:a synth to play samples
)

//:play through a Pdef to allow interaction

Pdef(\x,
	Pbind(\instrument, \playRate,
	\freq, 100,
		\startPos, Pwhite(0.1, 1.0, inf),
	)
);

Pdef(\x).quant = 0; //:Quantization: 0 = no wait!
Pdef(\x).play;
Pdef(\x).stop;