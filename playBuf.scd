~b = BEERffers.loadDirectory("/Users/KV/Downloads/Sounds/");

~b.dict.keys.do(_.postln);


(
SynthDef(\playRate, {|out=0, freq=440, sampFreq=100, gate=1, buf, startPos=0, mix=0.0, room=0.0, maxdel=0.0, deltime=0.0, decay=0.0, amp=0.1|
	var sig, pan, del, rate;
	rate = freq / sampFreq;
	pan = LFNoise1.kr(1).range(-1, 1);
sig = FreeVerb.ar(
		PlayBuf.ar(buf.numChannels, buf, BufRateScale.kr(buf) * rate, startPos:startPos, loop:0, doneAction:2),
		mix, room);
	del = CombC.ar(sig, maxdel, deltime, decay, 1, sig);
	Out.ar(out,
		Rotate2.ar(sig, del, pan)
	) * amp
}).add; //a synth to play samples
)

/////
//////
////