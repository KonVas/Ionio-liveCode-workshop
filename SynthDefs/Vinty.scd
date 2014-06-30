Server.default.boot; // run the server in case you havent!

//:

SynthDef(\vint, {| freq = 440, out = 0 |
	c = VarSaw.ar(freq) * EnvGen.kr(Env.perc(0.03, 0.25), doneAction: 2);
	Out.ar(out, c.dup * 0.25);
}).add;

//:

~tunings = (\phrygian:Scale.phrygian, \ionian:Scale.ionian, \major:Scale.major, \minor:Scale.minor);

//choose random tunings from the above

Tdef(\scaler, {
	var time = 1.0 + 0.5.rand;
	loop{
		time.wait;
		~scale = ~tunings.choose;
		( "scale is:" ++ ~scale ).postln;
	};
}).play

//:

//Here using a Pbindef to change only the scale

Pbindef(\x, \dur, Pgeom(0.1, 1.0, inf), \instrument, \vint, \degree, Prand((1..8), inf), \scale, Pfunc{~scale} ).play

//:

