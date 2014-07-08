(
SynthDef(\vint, {| freq = 440, out = 0 |
	c = VarSaw.ar(freq) * EnvGen.kr(Env.perc(0.03, 0.25), doneAction: 2);
	Out.ar(out, c.dup * 0.25);
}).add
)

~tunings = (\phrygian:Scale.phrygian, \ionian:Scale.ionian, \major:Scale.major, \minor:Scale.minor)

~scale = ~tunings[\minor] //swap scales from the above

Pdef(\x, Pbind(\dur, Pgbrown(0.05, 0.25, 0.1, inf), \instrument, \vint, \degree, Prand((1..8), inf), \scale, Pfunc{~scale} ))  // do not .play

Ndef(\x)[0] = Pdef(\x); //pass it through an Ndef.

Ndef(\x).fadeTime = 2;
Ndef(\x).play //play it.

//add some effects over the Ndef(\x)
Ndef(\x)[1] = \filter -> {|in|  FreeVerb.ar( in )  };
Ndef(\x)[2] = \filter -> {|in|  CombC.ar( in, 0.9.rand, 0.9.rand )  };

Ndef(\ring, { 
	{
		Splay.ar(
		Ringz.ar( 
			in: Ndef(\x).ar, 
			freq: ExpRand(100.0, 5000.0)
		) * 0.05
	)
	}!8
}).play;

Ndef(\pitcher, { PitchShift.ar( Ndef(\ring).ar, 0.2, \shift.kr(1, 0.3) * LFNoise1.kr(1).range(0.1, 8.0) ) }).play(0, 2);

NdefMixer(s);

Ndef.clear(8)

