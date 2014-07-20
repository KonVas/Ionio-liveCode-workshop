Server.default.reboot; // run the server in case you haven't.

//:

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

x = Synth(\grainBuf, [\buf, b]); //just for test

//:

// play it with an Ndef, do not .play the Pdef


Pdef(\x,
	Pbind( \dur, Pgbrown(0.03, 0.125),
	\instrument, \grainBuf,
	\buf, b,
	\freq, Pwhite(0.1, 100.0),
	\pos, Pwhite(0.1, 1.0),
	\grainDur, Pwhite(0.1, 0.3) )
);

//:

/*
play the Ndef instead, bear in mind, in order to do the following, your SynthDef has to have an 'out' argument, otherwise it won't work!
*/

Ndef(\play)[0] = Pdef(\x); //Ndef's source is the Pdef. [0] is the source.
Ndef(\play).fadeTime=2;
Ndef(\play).play;

//:

Ndef(\ctl, { LFNoise1.kr(10).range(100, 1200.0)});

Ndef(\play).map(\freq, Ndef(\ctl))

//:

Ndef(\play).unmap(\freq, Ndef(\ctl));

//:

NdefMixer(s);

//:

Ndef(\play)[1] = \filter -> {|in| GVerb.ar(in)  }// pass through an effect this way.

//:

Ndef.clear(3);//clear the Ndef gradually

//:

//be tidy, clean up.

b.free;