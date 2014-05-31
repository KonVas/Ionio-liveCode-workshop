b = Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01-44_1.aiff");

Ndef(\playBuf, {| amp = 0.1 |
	BufRd.ar(b.numChannels, b, Phasor.ar(1, \freq.kr(1, 0.3), 0, BufFrames.kr(b) ) ).dup
	* amp
}).play;

//:replace the source
Ndef(\playBuf)[0] = ({| amp = 0.1 |
	BufRd.ar(b.numChannels, b, Phasor.ar(1, SinOsc.ar(\freq.kr(1, 0.3), Ndef.ar(\playBuf) ), 0, BufFrames.kr(b) ) ).dup
	* amp
}).distort;

Ndef(\playBuf).fadeTime = 2;
Ndef(\ctl).fadeTime = 2;

Ndef(\ctl, {LFNoise0.kr(1).exprange(1, 1200.0) });

Ndef(\playBuf).map(\freq, Ndef(\ctl))

Ndef(\playBuf).unmap(\freq, Ndef(\ctl) );

Ndef(\playBuf)[1..8] = \filter -> {|in| CombC.ar(in) }

Ndef(\playBuf)[1..8] = \filter -> {|in| CombN.ar(in) }

Ndef(\playBuf)[1..8] = \filter -> {|in| PitchShift.ar(in, 0.2, 1, 4.rand) }

Ndef(\playBuf)[9] = \set -> Pbind(\dur, 0.25, \amp, Prand([0.1, 0.3, 0.6], inf), \freq, Prand((220..440), inf))

NdefMixer(s)

Ndef.clear(3)
b.free