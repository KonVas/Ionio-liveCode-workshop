// =====================================================================
// SuperCollider Workspace
// =====================================================================

/*
Freeze some input, use another Ndef from the examples and pass it through this Freezer effect, this example is using the play ndef from grainBuf synth example inside Synth folder.
*/

//:

Ndef(\freezer, {
	var  chain, in;
	in = Ndef.ar(\play);
	chain = FFT(LocalBuf(2048), in);
	chain = PV_MagFreeze(chain, LFNoise0.kr(0.2)); 
	IFFT(chain).dup * \amp.kr(0.1);
}).play

//:

NdefMixer(s);
