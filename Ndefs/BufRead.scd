b = Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01-44_1.aiff");// or load yours.

(
Ndef(\playBuf, {| amp = 0.1 |
	BufRd.ar(b.numChannels, b, 
		Phasor.ar(1, \freq.kr(1, 0.3), 0, BufFrames.kr(b) ) ).dup
	* amp
}).play;
)
//:replace the source
(
	Ndef(\playBuf)[0] = ({| amp = 0.1 |
	BufRd.ar(b.numChannels, b, Phasor.ar(1, SinOsc.ar(\freq.kr(1, 0.3), Ndef.ar(\playBuf) ), 0, BufFrames.kr(b) ) ).dup
	* amp
}).distort;
)

Ndef(\playBuf).fadeTime = 2;
Ndef(\ctl).fadeTime = 2;

Ndef(\ctl, {LFNoise0.kr(1).exprange(1, 1200.0) });

Ndef(\playBuf).map(\freq, Ndef(\ctl))

Ndef(\playBuf).unmap(\freq, Ndef(\ctl) );

Ndef(\playBuf)[1..4] = \filter -> {|in| CombC.ar(in, 0.3.rand, 0.3.rand) }

Ndef(\playBuf)[1..8] = nil // turn of the effects.

(
Ndef(\playBuf)[9] = \set ->
Pbind(\dur, Pgeom( 1.0, 1.1,  inf),
	\freq, Pfunc{ Pbrown( 0.1, 1.0, 0.1,  inf) * 6.rand + 3.rand }
 )
)

NdefMixer(s)

//be tidy, cleap up!
Ndef.clear(3)
b.free