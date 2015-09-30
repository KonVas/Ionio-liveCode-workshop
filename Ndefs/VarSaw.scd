// Use at your own risk, always take care of the VOLUME!!!!!!!

s.boot;//Boot the Server to start sound.
s.meter; //Show server audio output meters.

Ndef(\source).fadeTime = 3; //: first do this, you can change later to any fadeTime you want.

NdefMixer(s); //:make a GUI

//the source
(
Ndef(\source, {
	var n = 4;
	 VarSaw.ar({ExpRand(200, 1200)} ! n + \freq.kr(0.5),
			0,
			SinOsc.kr(0.2).range(0, 0.6) * 0.2,
	) / n * SinOsc.ar(\mod.kr(0.7))
}).play
)

//:add some effect on the source

Ndef(\source)[1] = \filter -> {|in| HPF.ar(in, SinOsc.ar(180), LFNoise1.kr(1).range(0.1, 1) ) }

Ndef(\source)[2] = \filter -> {|in| FreeVerb.ar(in * 0.3)}

Ndef(\source)[3] = \filter -> {|in| in * SinOsc.ar( rrand(0.7, 11) )}

Ndef(\source)[4] = \filter -> {|in| in * LFPulse.ar( LFNoise1.kr(1).range(1, 10) )}



//:to suspend an effect make nil, use the number of the effect, e.g.
Ndef(\source)[1] = nil




(
Ndef(\source)[0] = {
	//:you can edit the source without dismissing the effects!!
	var n = 20;
		SinOsc.ar({ExpRand(200, 1200)} ! n,
			0,
		SinOsc.kr( rrand(0.5, 1) ).range(0, 0.6) * 0.2,
	) / n;
}
)

//:any change you do will be faded in by fadeTime


Ndef(\source).clear(3) //:dismiss with a fade time:(3)
