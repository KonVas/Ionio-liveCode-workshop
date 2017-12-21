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
Ndef(\playbuf, {| buf = 2, rate = 1, dur = 0.5, dev = 0.01 |
	var trigger = WhiteNoise.kr(Impulse.kr(BufDur.kr(buf).reciprocal / dur), dev);
	c = PlayBuf.ar(1, buf.numChannels, rate, trigger.lag(0.3));
	c.dup / 2
}).play(0, 2);
)

//Change the buffer in real time.
Ndef(\playbuf).set(\buf, ~bufs[0]);