b = Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01-44_1.aiff");// or load yours.

(
Ndef(\playBuf, {| amp = 0.1 |
	BufRd.ar(b.numChannels, b, 
		Phasor.ar(1, \rate.kr(1, 0.3), 0, BufFrames.kr(b) ) )
	* amp
}).play;
)
//:replace the source
(
	Ndef(\playBuf)[0] = ({| amp = 0.1 |
	BufRd.ar(b.numChannels, b, Phasor.ar(1, SinOsc.ar(\rate.kr(0.1, 0.3), Ndef.ar(\playBuf) ), 0, BufFrames.kr(b) ) )
	* amp;
});
)

Ndef(\playBuf).fadeTime = 2;
Ndef(\ctl).fadeTime = 2;

Ndef(\ctl, {LFNoise0.kr(1).exprange(1.0, 100.0) });
Ndef(\playBuf).map(\rate, Ndef(\ctl));
Ndef(\playBuf).unmap(\rate, Ndef(\ctl) );

Ndef(\playBuf)[1] = \set -> Pbind(\dur, Pgeom(0.25, 1, inf), \rate, Pstutter(4, Pxrand((1..100).midicps, inf)) ).trace;

NdefMixer(s);

//be tidy, cleap up!
Ndef.clear(3);
Buffer.free
