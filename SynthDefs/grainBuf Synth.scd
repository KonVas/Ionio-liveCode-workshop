b = Buffer.read(s, "/Users/KV/Downloads/Sounds/changchang_long1.wav"); // or load yours
b.plot;

(
SynthDef(\grainBuf, {| buf = 0, out, sampFreq = 100 |
	var rate, pan;
	pan = LFNoise1.kr(1).range(-1, 1);
	rate = \freq.kr(100, 0.3) / sampFreq;
	OffsetOut.ar(out,
		Pan2.ar(
			PlayBuf.ar( buf.numChannels, buf, rate * BufRateScale.kr(buf), 1, \pos.kr(0.1, 0.3) * BufFrames.kr(buf) ), pan )
		* EnvGen.ar( Env.sine(\grainDur.kr(0.1, 0.3)), doneAction:2 )
	)
}).add;
)

x = Synth(\grainBuf, [\buf, b, \rate, 0.1]);//test

Pbindef(\x, \dur, Pgbrown(0.03, 0.2), \instrument, \grainBuf, \freq, 100, \pos, Pwhite(0.1, 1.0), \grainDur, Pwhite(0.1, 0.3) );


Ndef(\x)[0] = Pbindef(\x)

Ndef(\x).play

Ndef(\x)[1] = \filter -> {|in| SinOsc.ar( { ExpRand(200, 1200) } !8 ) * in }

Ndef(\ctl, { LFNoise1.kr(0.1).range(100, 120)})

Ndef(\x).fadeTime=2

Ndef(\x).unmap(\freq, Ndef(\ctl))

NdefMixer(s)
Ndef.clear
b.free

