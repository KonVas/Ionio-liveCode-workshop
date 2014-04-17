(
SynthDef.new(\blip, {| out = 0 |
        var sig, env;
	sig = SinOsc.ar(\freq.kr(220, 0.3));
	env = EnvGen.kr(Env.perc(\attack.kr(0.03, 0.3), \release.kr(0.5, 0.3)), doneAction: 2);
	sig = sig * env * \amp.kr(0.2, 0.3);
    sig = Pan2.ar(sig, LFNoise1.kr(1).range(-1,1));
    Out.ar(out, sig)
}).add;
)
//:test
x = Synth(\blip, [\freq, 440] )



