p = Platform.resourceDir +/+ "sounds/a11wlk01.wav";
b = Buffer.read(s, p);
// b = Buffer.loadDialog;

(
SynthDef(\sineGrain, {|rate = 1, sustain = 1, amp = 0.1, pos = 0, out = 0|
	var pb;
	pb = PlayBuf.ar(b.numChannels, b, rate * BufRateScale.kr(b), startPos:pos, loop:1);
	pb = pb * EnvGen.ar(Env.sine(sustain, amp), doneAction:2);
	OffsetOut.ar(out, pb);
}).add;
)

~granPatt = Pbind(\instrument, \sineGrain, \dur, Pwhite(0.01, 0.05), \legato, Pwhite(4, 6), \pos, Env([0, b.numFrames], [b.duration * 2]), \out, Prand([0, 1], inf));

~granPatt.play

~granPatt2 = Pbind(\instrument, \sineGrain, \dur, Pwhite(0.01, 0.05), \legato, Pwhite(4, 6), \pos, Env([0, b.numFrames], [b.duration * 1]), \out, Prand([0, 1], inf), \rate, Pwhite(0.9, 1.1));

~granPatt2.play;

// loop the granulation
~granPatt3 = Pbind(\instrument, \sineGrain, \dur, Pwhite(0.01, 0.05), \legato, Pwhite(4, 6), \pos, Pseg(Pseq([0, b.numFrames], inf), Pseq([b.duration * 1, 0], inf)), \out, Prand([0, 1], inf), \rate, Pwhite(0.9, 1.1));

~granPatt3.play;