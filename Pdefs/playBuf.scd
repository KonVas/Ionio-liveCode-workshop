b = Buffer.read(s,  Platform.resourceDir +/+ "sounds/a11wlk01.wav"); //:load your own sample

//:

SynthDef(\playRate, {|out=0, freq=440, sampFreq=100, buf, startPos=0.1, mix=0.0, room=0.0, maxdel=0.0, deltime=0.0, decay=0.0, amp=0.5|
	var sig, pan, del, rate;
	rate = freq / sampFreq;
	pan = LFNoise1.kr(1).range(-1, 1);

	sig = FreeVerb.ar(
    PlayBuf.ar(1, buf, BufRateScale.kr(buf) * rate,
		BufFrames.kr(buf) * startPos, loop:0),
		mix, room) * EnvGen.kr( Env.sine( \durPlay.kr(0.3, 0.3)), doneAction:2 );

    sig = sig * amp;
    del = CombC.ar(sig, maxdel, deltime, decay, 1, sig);
	Out.ar(out,
		Rotate2.ar(sig, del, pan)
	)
}).add;//:a synth to play samples


//:play through a Pdef to allow interaction

Pdef(\x,
	Pbind(
		\dur, Pgeom(0.03, 1.1),
		\instrument, \playRate,
		\freq, Pseq((100..40), 1), //pitch down incrementally, will do only once.
		\buf, b,
		\startPos, Pwhite(0.1, 1.0),
		\amp, 0.3 
	)
)

//experiment with other arguments via the Pdef, e.g, mix, room, etc.

//:

Pdef(\x).quant = 0; //:Quantization: 0 = no wait!
Pdef(\x).play;

//: be tidy, clean up!

Pdef(\x).stop;
b.free;
