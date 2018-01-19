p = Platform.resourceDir +/+ "/sounds/";
b = Buffer.read(s, p +/+ "a11wlk01-44_1.aiff");

(
Ndef(\playbuf, {| buf = 0, rate = 1, dur = 2, dev = 0.3 |
        var clock= Impulse.ar(dur);
        var trigger= Impulse.ar(dur, TGaussRand.ar(dur-dev, dur+dev, clock));
        c = PlayBuf.ar(1, buf, rate, trigger, 0, 1);
        c.dup / 2
}).play(0, 2);
)

Ndef(\playbuf).set(\dur, 100);
Ndef(\playbuf).set(\dev, 100);
