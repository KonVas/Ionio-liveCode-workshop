(
SynthDef(\vint, {| freq = 440, out = 0 |
	c = VarSaw.ar(freq) * EnvGen.kr(Env.perc(0.03, 0.25), doneAction: 2);
	Out.ar(out, c.dup * 0.25);
}).add
)

~tunings = (\phrygian:Scale.phrygian, \ionian:Scale.ionian, \major:Scale.major, \minor:Scale.minor)

~scale = ~tunings[\ionian] //change a scale with one of the above

Pdef(\x, Pbind(\dur, Pgbrown(0.05, 0.25, 0.1, inf), \instrument, \vint, \degree, Prand((1..8), inf), \scale, Pfunc{~scale} )).play