(
//load your sounds.
p = Platform.resourceDir +/+ "/sounds/";
~sounds = [
	p +/+ "a11wlk01-44_1.aiff", //
	p +/+ "a11wlk01.wav",
	p +/+ "SinedPink.aiff"
]
)

(
//this will create an array with the loaded sounds.
~bufs = ~sounds.collect({| items |
	Buffer.read(s, items);
});
)

(
Ndef(\playbuf, {| buf = 0, rate = 1, dur = 1, dev = 0.1 |
	var trigger = Impulse.kr(BufDur.kr(buf).reciprocal / dur);
	c = PlayBuf.ar(1, buf.numChannels, rate, trigger);
	c.dup / 2
}).play(0, 2);
)


//Change the buffer in real time.
Ndef(\playbuf).set(\buf, ~bufs[1]);