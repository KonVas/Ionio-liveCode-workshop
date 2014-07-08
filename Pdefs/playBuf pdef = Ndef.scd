b = Buffer.loadDialog(s); //:load a sample
b.plot // see what's loaded

//:
SynthDef(\playRate, {|out=0, freq=440, sampFreq=100, buf, start=0, mix=0.0, room=0.0, maxdel=0.0, deltime=0.0, decay=0.0, amp=0.5|
	var sig, pan, del, rate, startPos;
	startPos = BufFrames.kr(buf) * start;
	rate = freq / sampFreq;
	pan = LFNoise1.kr(1).range(-1, 1);

	sig = FreeVerb.ar(
    PlayBuf.ar(buf.numChannels, buf, BufRateScale.kr(buf) * rate, startPos:startPos, loop:0),
		mix, room) * EnvGen.kr( Env.sine(\durPlay.kr(0.3, 0.3)), doneAction:2 );

    sig = sig * amp;
    del = CombC.ar(sig, maxdel, deltime, decay, 1, sig);
	Out.ar(out,
		Rotate2.ar(sig, del, pan)
	)
}).add;//:a synth to play samples

//:

x = Synth(\playRate, [ \buf, b])//test it!

Pdef(\x, Pbind(\dur, 0.125, \instrument, \playRate, \buf, b, \freq, Pwhite(120, 1200))); //do *not* make Pdef play!

Ndef(\x)[0] = Pdef(\x); // pass it through an Ndef!

Ndef(\x).play // and now play it.