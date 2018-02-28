//SynthDefs, sound engines of our programs. 

s.boot;//First boot the server...

//functions inside synthdefs
x = {|amp = 0.6| 
	var sig; sig = SinOsc.ar([120.0, 121.0]); // a two output sine oscillator synth. 
	sig = sig / 2;
	sig * amp;
}.play;

(
SynthDef(\drony, {|out = 0, amp = 0.6, dur = 1, freq = 1|
	var sig, env;
	env = EnvGen.kr(Env.perc(0.01, dur), doneAction:2); //take care of doneAction!
	sig = SinOsc.ar([120.0, 121.0] * freq); //two output sine oscillator synth.
	sig = sig / 2;
	sig = sig.sum;
	Out.ar(out, sig * amp * env); //out creates a buss.
}).add;
)

(
SynthDef(\sawy, {|out = 0, speed = 1, amp = 0.6, dur, freq = 1|
	var env, sig;
	env = EnvGen.kr(Env.perc(0.01, dur), doneAction:2);
	sig = LFSaw.ar(LFNoise0.kr(speed).range(220, 1220.0));
	sig = sig * 0.5;
	Out.ar(out, sig * amp * env); 
}).add;
)

x = Synth(\drony, [\amp, 0.4, \out, 0, \dur, 1.0.rand]);
y = Synth(\sawy, [\amp, 0.4, \out, 0, \dur, 10, \speed, 10]);

//create many instances of our synths with ".do"
(
5.do{ 
	Synth(\drony, [\amp, 0.2, \freq, rrand(1, 5), \dur, 10.0.rand ]);
	Synth(\sawy, [\amp, 0.03, \out, 0, \dur, 10, \speed, 10]);
};
)

x.set(\freq, 0.5); //using set to control the freq parameter of the "drony" synth.
