/*
Use Scale to control a SynthDef

Sat Jul 12 17:59:59 EEST 2014
*/


//:

SynthDef('foobar', {|freq = 220, out = 0|
	c = SinOsc.ar(freq.lag(0.3) ) * EnvGen.ar(Env.sine(0.1), doneAction:2);
	Out.ar(out, c.dup)
}).add;

//:

a = Scale;

{ loop({ c = a.choose.postln;  1.wait;}) }.fork;

p = Pbind(\dur, 0.125, \instrument, \foobar, \scale, Pfunc{ c },
	\degree, Pxrand((0..7) ++ (6..0) ++ [\rest], inf) 
);

//:

p.play
