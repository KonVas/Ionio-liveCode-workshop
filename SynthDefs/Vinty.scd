Server.default.boot; // run the server in case you havent!

//:

(
SynthDef(\vint, {| freq = 440, out = 0 |
	var sig, env;
	env = EnvGen.kr(Env.perc(\attack.kr(0.03, 0.3), \release.kr(0.5, 0.3)), doneAction: 2);
	sig = VarSaw.ar(freq) * EnvGen.kr(Env.perc(0.03, 0.25), doneAction: 2);
	sig = sig * env * \amp.kr(0.2, 0.3);
    sig = Pan2.ar(sig, LFNoise1.kr(1).range(-1,1));
	Out.ar(out, sig.dup * 0.25);
}).add;
)

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

Pbindef(\x, \dur, Pgeom( 0.125, 1.01, inf), \instrument, \vint, \degree, Prand((1..12), inf), \scale, Pfunc{~scale} ).play

//:

