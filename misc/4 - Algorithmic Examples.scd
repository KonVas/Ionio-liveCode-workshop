// SC has great support for patterns and streams
// A stream is a stream of something. You can ask streams for their next value with the next method.
// All objects are trivially a stream of themselves

1.next; // do this lots of times ;-)

// Patterns are a template which can be used to create any number of more interesting streams. They have names beginning with P.

a = Prand([1, 2, 3], inf).asStream; // an infinite stream of a random choice of 1, 2, or 3.
a.next; // do this many times

// Event patterns make streams of events. Events are parameter names and parameters (which can themselves be streams), and some info on what to do with those parameters. The default event type is called a 'note' and plays a synth.

s.boot; // this starts the Server app which processes audio

Pbind().play; // an endless string of middle Cs. Note that this assumes a lot of defaults. 1 second, default synthdef, middle C.

// More interestingly, we can use our own synthdefs, and/or specify interesting parameter streams
(
Pbind(
	\degree, Pseq([Pseq([2, 1, 0], 2), Pseq([4, 3, 3, 2], 2)], 1), // |: Mi Re Do :||: So Fafa Mi :|
	\dur, Pseq([Pfin(6, 0.5), Pseq([0.5, 0.375, 0.125, 0.5], 2)]) // 0.5 secs 6 times, then |: 0.5 0.375 0.125 0.5 :|
).play;
)

// notice that the above makes a bunch of assumptions. There's a default sound (actually a SynthDef called 'default'), degree refers to a major scale, etc.

(
// a SynthDef
SynthDef(\blippy, { | out = 0, freq = 440, amp = 0.1, nharms = 10, pan = 0, gate = 1 |
    var audio = Blip.ar(freq, nharms, amp);
    var env = Linen.kr(gate, doneAction: 2);
    OffsetOut.ar(out, Pan2.ar(audio, pan, env) );
}).add;
)

(
Pbind(
	\instrument, \blippy,
	\freq, Prand([1, 1.2, 2, 2.5, 3, 4], inf) * 200, // use freq instead of degree
	\nharms, Pseq([4, 10, 40], inf),
	\dur, 0.1
).play;
)

// we can record them.

p = Pbind(\instrument, \blippy, \freq, Prand([1, 1.2, 2, 2.5, 3, 4], inf) * Pstutter(6, Pseq([100, 200, 300])), \nharms, Pseq([4, 10, 40], inf), \dur, 0.1); // just define, don't make a stream

p.play; // test

p.record("~/Desktop/patternTest.aiff".standardizePath, fadeTime:0.5); //fadeTime is how long to record after last event. Adjust to avoid click at end

// note to use Pattern:record, your SynthDef must have an 'out' argument

b = Buffer.read(s, "~/Desktop/patternTest.aiff".standardizePath); // read it in to check

b.plot

b.play



//// for an infinite pattern we can use the dur arg to 'render' to set a fixed recording time

// a SynthDef
(
SynthDef(\blippyDist, { | out = 0, freq = 440, amp = 0.1, nharms = 10, pan = 0, gate = 1, pre = 20 |
    var audio = Blip.ar(freq, nharms);
    var env = Linen.kr(gate, doneAction: 2);

	audio = (audio * pre).softclip * amp;
    OffsetOut.ar(out, Pan2.ar(audio, pan, env) );
}).add;
)

(
p = Pbind(
	\instrument, \blippyDist,
	\freq, Prand([1, 1.2, 2, 2.5, 3, 4], inf) * Pstutter(6, Pxrand([50, 100, 200, 300], inf)),
	\nharms, Pseq([4, 10, 40], inf),
	\dur, Pseq([3, Pbrown(0.1, 0.2, 0.05, 5)], inf)
);
)

p.play; //test it

p.record("~/Desktop/patternTest2.aiff".standardizePath, dur: 7); // will stop after 7 seconds. May need editing



// use a pattern to artificially generate something based on a soundfile

b = Buffer.loadDialog; // load a soundfile for processing
b.postln; // check details after load
b.play

// we probably don't need these, but just in case configure recording options
s.recHeaderFormat = "aiff";
s.recSampleFormat = "float"; // floating point has the advantage of big dynamic range, but some older apps may not read it. "int24" is another possibility
s.recChannels = b.numChannels; // match number of chans in the file

// we hardcode the defs below to the buffers and their characteristics
(
// just plays back
SynthDef(\playbackSimpEnv, {|out = 0, rel = 0.5, pos = 0, rate = 1, level = 0.1|
	var pb;
	// we need to declare the number of channels here since that's fixed when we make the def
	pb = PlayBuf.ar(b.numChannels, b, BufRateScale.kr(b)  * rate, startPos: pos  * BufSampleRate.kr(b)); // pos in seconds
	pb = pb * Env.linen(releaseTime:rel, level: level).kr(2); // shape it with an envelope, kr is a shortcut for EnvGen
	Out.ar(out, pb); //play out bus 0 at rate 1;
}).add;

// this plays back with distortion
SynthDef(\playbackDist, {|out = 0, rel = 0.5, pre = 10, pos = 0, rate = 1, level = 0.1| // pre is a parameter we can set
	var pb;
	pb = PlayBuf.ar(b.numChannels, b, BufRateScale.kr(b) * rate, startPos:pos * BufSampleRate.kr(b), doneAction:2);
	pb = (pb * pre).distort;
	pb = pb * Env.linen(releaseTime:rel, level: level).kr(2); // shape it with an envelope
	Out.ar(out, pb);
}).add;

/// ...? other processes
)

(
Pbind(
	\instrument, \playbackSimpEnv,
	\dur, Pseq([Pgeom(0.01, 1.1707, 18).trace, 0.1,Pgeom(0.1, 0.94, 100).trace ]), // we use trace to post the vals
	\rel, 0.05
).play
)

// similar with random start pos
(
Pbind(
	\instrument, \playbackSimpEnv,
	\dur, Pseq([Pgeom(0.01, 1.1707, 18).trace, 0.1,Pgeom(0.1, 0.94, 100).trace ]), // we use trace to post the vals
	\rel, 0.05,
	\pos, Pbrown(0, 1) * b.duration // little more variation
).play
)

// mess with playback rate
(
Pbind(
	\instrument, \playbackSimpEnv,
	\dur, Pseq([Pgeom(0.01, 1.1707, 18).trace, 0.1,Pgeom(0.1, 0.94, 100).trace ]), // we use trace to post the vals
	\rel, 0.05,
	\pos, Pbrown(0, 1) * b.duration,
	\rate, Pbrown(0.95, 1.05, 0.01)
).play
)


// make a sequence of Patterns one after the other
(
Pseq([
	// 1
	Pbind(
	\instrument, \playbackSimpEnv,
	\dur, Pseq([Pgeom(0.01, 1.1707, 18).trace, 0.1,Pgeom(0.1, 0.94, 100).trace ]), // we use trace to post the vals
	\rel, 0.05,
	\pos, Pbrown(0, 1) * b.duration),
	// 2
	Pbind(
	\instrument, \playbackSimpEnv,
	\dur, Pseq([Pgeom(0.01, 1.1707, 18).trace, 0.1,Pgeom(0.1, 0.94, 100).trace ]), // we use trace to post the vals
	\rel, 0.05,
	\pos, Pbrown(0, 1) * b.duration,
	\rate, Pbrown(0.95, 1.05, 0.01))
]).play
)

// start overlapping ones at different times
(
{
	Pbind(
	\instrument, \playbackSimpEnv,
	\dur, Pseq([Pgeom(0.01, 1.1707, 18).trace, 0.1,Pgeom(0.1, 0.94, 100).trace ]), // we use trace to post the vals
	\rel, 0.05,
	\level, 0.05, // starts quieter
	\pos, Pbrown(0, 1) * b.duration).play;

	1.wait; // wait 1 second

	Pbind(
	\instrument, \playbackSimpEnv,
	\dur, Pseq([Pgeom(0.01, 1.1707, 18).trace, 0.1,Pgeom(0.1, 0.94, 100).trace ]), // we use trace to post the vals
	\rel, 0.05,
	\level, 0.06,
	\pos, Pbrown(0, 1) * b.duration,
	\rate, Pbrown(0.95, 1.05, 0.01)).play;

	1.wait;

	Pbind(
	\instrument, \playbackDist, // distorted version
	\dur, Pseq([Pgeom(0.01, 1.1707, 18).trace, 0.1,Pgeom(0.1, 0.94, 100).trace ]), // we use trace to post the vals
	\rel, 0.05,
	\level, 0.06,
	\pre, Env([0, 20], [3], \sin).asStream, // bring in distortion, Env:asStream makes it usable here
	\pos, Pbrown(0, 1) * b.duration,
	\rate, Pbrown(1.05, 1.5, 0.01)).play;

}.fork // this plays the Function on a Clock, it makes 'wait' work
)

// panning version
(
// assumes mono input
SynthDef(\playbackSimpEnvPan, {|out = 0, rel = 0.5, pos = 0, rate = 1, level = 0.1, pan = 0|
	var pb;
	// we need to declare the number of channels here since that's fixed when we make the def
	pb = PlayBuf.ar(b.numChannels, b, BufRateScale.kr(b) * rate, startPos: pos  * BufSampleRate.kr(b)); // pos in seconds
	pb = pb * Env.linen(releaseTime:rel, level: level).kr(2); // shape it with an envelope
	pb = Pan2.ar(pb, pan);
	Out.ar(out, pb); //play out bus 0 at rate 1;
}).add;
)

// parallel with Ppar
(
Ppar([
	Pbind(
	\instrument, \playbackSimpEnvPan,
	\dur, Pseq([Pgeom(0.01, 1.1707, 18), 0.1,Pgeom(0.1, 0.94, 100), Pn(0.1) ]), // Pn outputs this value some number of times, inf by default
	\rel, 0.05,
	\level, 0.05,
	\pos, Pbrown(0, 1) * b.duration,
	\pan, Pwhite(Pseg([0, -1], 8, 'sin'), Pseg([0, 1], 8, 'sin'))),
	Pbind(
	\instrument, \playbackSimpEnvPan,
	\dur, Pseq([Pgeom(0.01, 1.1707, 18), 0.1,Pgeom(0.1, 0.94, 100), Pn(0.1) ]), // we use trace to post the vals
	\rel, 0.05,
	\level, Env([0, 0.05], [4], \sin).asStream,
	\pos, Pbrown(0, 1) * b.duration,
	\rate, Pbrown(1.9, 2.1, 0.01).trace,
	\pan, Pseg([-1, 1], 14, 'sin'))
]).play
)

// note if we try this with other inputs we may need to tweak the settings

// chords
(
// plays back with enevelope
SynthDef(\playbackEnvWithSustain, {|out = 0, rel = 0.5, pos = 0, rate = 1, level = 0.1, sustain = 1|
	var pb;
	// we need to declare the number of channels here since that's fixed when we make the def
	pb = PlayBuf.ar(b.numChannels, b, BufRateScale.kr(b)  * rate, startPos: pos  * BufSampleRate.kr(b)); // pos in seconds
	pb = pb * Env.linen(2, sustain, releaseTime:rel, level: level).kr(2); // shape it with an envelope, kr is a shortcut for EnvGen
	Out.ar(out, pb); //play out bus 0 at rate 1;
}).add;

)

(
Pbind(\instrument, \playbackEnvWithSustain,
	\rate, Pfunc({ [1, 1.5, 2, 2.5, 3, 3.5, 4].scramble.keep(3) }) * 0.25, // returns an array of 3 vals; a chord
	\dur, Pwhite(3, 4), // time between events starting
	\legato, 1.5 // events overlap a bit
).play
)

// with a Rest
(
Pbind(\instrument, \playbackEnvWithSustain,
	\rate, Pfunc({ [1, 1.5, 2, 2.5, 3, 3.5, 4].scramble.keep(3) }) * 0.25,
	\dur, Pseq([Pwhite(1, 2, 3), Rest(5)], inf), // time between events starting
	\legato, 1.5 // events overlap a bit
).play
)

/////////// Pdefs

// we can use Pdefs as a placeholder for a whole pattern, allowing us to modify a stream while it's running; a particularly useful form of live coding!

// take our blippy example

(
Pdef(\blippy, Pbind(
	\instrument, \blippy,
	\freq, Prand([1, 1.2, 2, 2.5, 3, 4], inf) * 200, // use freq instead of degree
	\nharms, Pseq([4, 10, 40], inf),
	\dur, 0.1
)).play;
)

// change the whole thing be redefining it

(
Pdef(\blippy, Pbind(
	\instrument, \blippy,
	\freq, Prand([1, 1.2, 2, 2.5, 3, 4], inf) * 400, // use freq instead of degree
	\nharms, Pseq([2, 5, 10], inf),
	\dur, 0.1
));
)

// change just one key Pbindef

Pbindef(\blippy, \freq, 100);

Pbindef(\blippy, \nharms, 6); // repeat with different vals

// We can use Pdefs anywhere you'd use a pattern...
// for value streams rather than event streams, use Pdefn

(
Pbind(
	\instrument, \blippy,
	\freq, Prand([1, 1.2, 2, 2.5, 3, 4], inf) * 400, // use freq instead of degree
	\nharms, Pseq([2, 5, 10], inf),
	\dur, Pdefn(\blipDur, 0.1) // Pdef here
).play;
)

Pdefn(\blipDur, Pbrown(0.01, 0.5));

// try other stuff!!

