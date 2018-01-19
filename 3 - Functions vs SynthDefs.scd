//first a Function
{ SinOsc.ar(440, 0, 0.2) }.play;

// now here's an equivalent SynthDef
SynthDef("SinOsc", { Out.ar(0, SinOsc.ar(440, 0, 0.2)) }).add; // add sends the SynthDef to the server

// Notice we needed to add a name for the synthdef, and an Out UGen. Function:play creates an Out Ugen for you if you haven't done it already

// A SynthDef is a template for making synths on the Server. It's like a cookie cutter, and synths are the cookies!
// we can test the SynthDef by making an instance of the Synth class.
x = Synth("SinOsc")

x.free;

// In case you're wondering, Function:play makes a SynthDef, and then creates a Synth based on it. There's a bit of overhead with making a SynthDef, so in performance critical situations it's better not to.

// When you make Synths it's good to have a clean fadein or out. We can use the Envelope class for this.
// Env.linen is a simple trapezoidal Envelope.
e = Env.linen(0.1, 1, 0.5, 0.6); // attack time, sustain time, release time, level
e.plot;
e.test;

// Use it in a SynthDef with the EnvGen UGen
(
SynthDef("SinOscEnv", {|freq = 440, sustain = 1| // add a frequency argument
	var sin;
	sin = SinOsc.ar(freq, 0, 0.2);
	sin = sin * EnvGen.ar(Env.linen(sustainTime:sustain, releaseTime:0.1), doneAction:2); // doneAction 2 automatically frees the synth when done! No cleanup
	Out.ar(0, sin)
}).add;
)

Synth(\SinOscEnv);
Synth(\SinOscEnv, [\freq, 220]);



// Often we will use higher level approaches than the Synth class for making Synths, for example a pattern and stream.

Pbind(\instrument, \SinOscEnv, \dur, 0.1, \legato, 0.1).play // more about this later

/* A couple of things to note:
1) You can only use UGens in a SynthDef.
2) The 'paths' of a SynthDef are fixed once it's created, so you can't have the number of channels as an argument that you change at Synth creation time. So if you have a Synth with a Playbuf that plays mono files, you'd need an additional SynthDef to do the same thing with stereo files.
3) Constructs like 4.0.rand can be used in SynthDefs, but will be evaluated once, when the SynthDef is created. If you want a random value in every Synth created, you can use the Rand UGen, or its variants.
*/