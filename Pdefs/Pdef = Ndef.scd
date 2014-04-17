(
SynthDef(\vint, {| freq = 440, out = 0 |
	c = VarSaw.ar(freq) * EnvGen.kr(Env.perc(0.03, 0.25), doneAction: 2);
	Out.ar(out, c.dup * 0.25);
}).add
)

~tunings = (\phrygian:Scale.phrygian, \ionian:Scale.ionian, \major:Scale.major, \minor:Scale.minor)

~scale = ~tunings[\ionian] //change a scale with one of the above

Pdef(\x, Pbind(\dur, Pgbrown(0.05, 0.25, 0.1, inf), \instrument, \vint, \degree, Prand((1..8), inf), \scale, Pfunc{~scale} ))  // do not .play

Ndef(\x)[0] = Pdef(\x);

Ndef(\x).fadeTime = 2;
Ndef(\x).play

Ndef(\x)[1] = \filter -> {|in|  FreeVerb.ar( in )  };
Ndef(\x)[2] = \filter -> {|in|  CombC.ar( in )  };
Ndef(\x)[3] = \filter -> {|in|  in * EnvGen.kr( Env.perc(0.01, 0.2), Dust.kr( density:3 )) };

Ndef(\rverb, { FreeVerb.ar( Ndef(\x).ar, mix:0.8, room:0.8 ) }).play(0, 2)

Ndef(\pitcher, { PitchShift.ar( Ndef(\rverb).ar, 0.2, \shift.kr(1, 0.3) * LFNoise1.kr(1).range(0.6, 4.0) ) }).play(0, 2);

NdefMixer(s);

Ndef(\x).clear(8)

