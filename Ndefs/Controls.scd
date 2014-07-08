//:

Ndef(\foo).fadeTime = 2;
Ndef(\foo).play(0, 2);

//:

Ndef(\foo, {|freq=220, amp = 0.1|
	VarSaw.ar(
		freq.lag(0.6), mul:amp
	).dup * LFPulse.kr(\pulse.kr(1) )
});

//:

Ndef(\foo).xset(\pulse, 10)//set the argument this way


Ndef(\ctlr).fadeTime = 2;
Ndef(\ctlr, { LFNoise1.kr(1).range(200, 1200)}); //make a control Ugen

Ndef(\foo).map(\freq, Ndef(\ctlr)) //map the argument to the control Ugen

Ndef(\foo).unmap(\freq, Ndef(\ctlr)) //unmap

Ndef(\ctrl2, { LFNoise0.kr(1).range(1, 10) });

Ndef(\foo).map(\pulse, Ndef(\ctrl2))

Ndef(\foo).unmap(\pulse) //unmap again



NdefMixer(s)
Ndef.clear(8)