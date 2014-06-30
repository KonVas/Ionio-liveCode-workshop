	Ndef(\foo).fadeTime = 2;
	Ndef(\foo).play(0, 2);

	(
		Ndef(\foo, {|freq=220, pulse = 2, amp = 0.1|
		VarSaw.ar(
			freq.lag(0.6), mul:amp
			) * LFPulse.kr(pulse)
	});
		)


Ndef(\foo).set(\pulse, 1)//set the argument this way


Ndef(\ctlr).fadeTime = 2;
Ndef(\ctlr, { LFNoise1.kr(1).range(200, 1200)}); //make a control Ugen

Ndef(\foo).map(\freq, Ndef(\ctlr)) //map the argument to the control Ugen

Ndef(\foo).unmap(\freq, Ndef(\ctlr)) //unmap


//OR control this way through patterns

Ndef(\foo)[1] = \set -> Pbind(\dur, Pgeom(1.0, 1.1, inf), \freq, Pwhite(200, 1200), \pulse, Pwhite(0.5, 8))




	NdefMixer(s)
	Ndef(\foo).clear(8)