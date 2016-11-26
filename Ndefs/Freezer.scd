// =====================================================================
// SuperCollider Workspace
// =====================================================================

/*
Freeze some input, use another Ndef from the examples, e.g 'BufRead' and pass it through this Freezer effect, this example is using the play ndef from grainBuf synth example inside Synth folder.
*/

(
Ndef(\freezer, {
	var  chain, in;
	in = Ndef(\playBuf).ar;
	chain = FFT(LocalBuf(2048), in);
	chain = PV_MagFreeze(chain, LFNoise0.kr(8).poll); 
	IFFT(chain).dup.sum * \amp.kr(0.6);
}).play(0, 2)
)

Ndef(\freezer)[1] = \filter -> {|in| CombC.ar(in)}

NdefMixer(s);

Ndef.clear(4)