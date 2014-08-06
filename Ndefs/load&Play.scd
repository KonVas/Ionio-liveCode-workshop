//Thu Jul 31 2014

//:
(
//if fancy make this to get a meter and a scope too.
s.scope;
s.meter;
)

//:
b = Buffer.cueSoundFile(s, "/Users/KV/Documents/tsepeLogReel.aiff", 0, 1);

Ndef(\play).fadeTime = 0.8;

Ndef(\play, { VDiskIn.ar(1, b, \rate.kr(1, 0.3), loop:0) }).play;

//Boiler plate code
//:
(
Ndef(\freezer).fadeTime = 2;

Ndef(\freezer, {
	var  chain, in;
	in = Ndef(\play).ar;
	chain = FFT(LocalBuf(2048), in);
	chain = PV_MagFreeze(chain, LFNoise1.kr(1).range(-1.0, 0.3) );
	IFFT(chain).dup * \amp.kr(0.8);
}).play(0, 2)
)

//:

(

Ndef(\mod, { var in = Ndef(\freezer).ar; SinOsc.ar(\freq.kr(220, 0.3)) * in }).play(0, 2);
Ndef(\ctl, { LFNoise1.kr(0.1).range(220, 1220)});

Ndef(\mod).map(\freq, Ndef(\ctl))

)

//:

Ndef('reson', { Resonz.ar(Ndef(\play).ar, LFNoise1.kr(1).range(220, 1220), 0.6)}).play(0, 2)

//:

NdefMixer(s)

//:

//Ndef.clear; //shut down all running ndefs.