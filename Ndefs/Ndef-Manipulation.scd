// Some fun with Ndefs and Ndef Manipulation...

b = Buffer.read(s, "/Users/Home_KV/Desktop/audio-test.aiff");
b.plot;
b.free

Ndef(\playBuf).fadeTime = 0.2;

(
Ndef(\playBuf, {|rate = 1, mod = 0.7|
	PlayBuf.ar(b.numChannels, b, rate, loop:1) * SinOsc.kr(mod);
}).play(0, 2, vol:0.6);

Ndef(\pShift, {|pitch = 1, pDev = 0.1, time = 1|
	PitchShift.ar( Ndef(\playBuf).ar, pitch, pDev, time)
}).play(0, 2);

Ndef(\resonz, {
	Resonz.ar( Ndef(\pShift).ar, {ExpRand(120.0, 1220.0)}!8) / 8;
}).play(0, 2);
)


NdefMixer(s)

(
Ndef(\playBuf)[1] = \xset -> Pbind(\dur, 0.25,
	\rate, Pbrown(0.1, 4.0, 0.1),
	\mod, Pwhite(0.1, 1.0)
)
)

Ndef.clear;