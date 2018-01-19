s.boot; // this starts the Server app which processes audio

b = Buffer.loadDialog; // load a soundfile for processing
b.postln; // check details after load

// we probably don't need these, but just in case
s.recHeaderFormat = "aiff";
s.recSampleFormat = "float"; // floating point has the advantage of big dynamic range, but some older apps may not read it. "int24" is another possibility
s.recChannels = b.numChannels; // match number of chans in the file

(
// just plays back
SynthDef(\playbackSimp, {
	var pb;
	pb = PlayBuf.ar(b.numChannels, b, BufRateScale.kr(b), doneAction:2); // doneAction 2 frees the synth when finished playing
	Out.ar(0, pb); //play out bus 0 at rate 1;
}).add;

// plays back with distortion
SynthDef(\playbackDist, {|pre = 20| // pre is a parameter we can set
	var pb;
	pb = PlayBuf.ar(b.numChannels, b, BufRateScale.kr(b), doneAction:2);
	Out.ar(0, (pb * pre).distort);
}).add;

/// ...? other processes
)

// here we set the path for the output file
s.prepareForRecord("~/Desktop/testDist.aiff".standardizePath); // on the Desktop; standardizePath expands ~ to your home dir

(
s.makeBundle(nil, {
	s.record;
	Synth(\playbackDist);
});
SystemClock.sched(b.duration + 0.1, { s.stopRecording; \done.postln }); // automatically stop recording after a certain time
)

// set path again
s.prepareForRecord("~/Desktop/testMoreDist.aiff".standardizePath);

// different parameters
(
s.makeBundle(nil, {
	s.record;
	Synth(\playbackDist, [pre: 100]); // higher pre
});
)

// manually stop when finished
s.stopRecording // this needs to happen to close the file


// You can also start or stop recording by clicking on the server info lower left to get the popup menu.
// This will record in a default location (the 'Music/SuperCollider Recordings' on Mac) with a filename based on time and date