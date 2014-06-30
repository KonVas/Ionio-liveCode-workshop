Server.default.reboot; // run the server in case you haven't.

b = Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01.wav"  ); // or load yours

b.plot; //see the content of the buffer.

//:

(
SynthDef(\grainBuf, {| buf = 0, out = 0, sampFreq = 100 |
	var rate, pan;
	rate = \freq.kr(100, 0.3) / sampFreq;
	OffsetOut.ar(out,
		PlayBuf.ar(1, buf, rate * BufRateScale.kr(buf), 1, \pos.kr(0.1, 0.3) * BufFrames.kr(buf) )
		* EnvGen.ar( Env.sine(\grainDur.kr(0.1, 0.3)), doneAction:2 )
	)
}).add;
)

//:

x = Synth(\grainBuf, [\buf, b, \rate, 1]); //just for test

//:

// play with a Pdef

Pdef(\x,
	Pbind( \dur, Pgbrown(0.03, 0.125),
	\instrument, \grainBuf,
	\buf, b,
	\freq, Pwhite(0.1, 100.0),
	\pos, Pwhite(0.1, 1.0),
	\grainDur, Pwhite(0.1, 0.3) )
);

//:

// play it through an Ndef - and process it more!

Ndef(\play)[0] = Pdef(\x);
Ndef(\play).fadeTime=2;
Ndef(\play).play;

//:


//:

Ndef(\ctl, { LFNoise1.kr(0.1).range(100, 120)});

//:

Ndef(\play).unmap(\freq, Ndef(\ctl))

//:

NdefMixer(s);

//:

//clean up when done!
Ndef.clear;

b.free;