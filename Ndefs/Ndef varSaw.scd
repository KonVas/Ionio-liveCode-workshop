// Use at your own risk, always take care of the VOLUME!!!!!!!

Ndef(\source).fadeTime = 3; //: first do this, you can change later to any fadeTime you want.

NdefMixer(s); //:make a GUI

(
Ndef(\source, {
	var n = 4;
		VarSaw.ar({ExpRand(200, 1200)} ! n,
			0,
			SinOsc.kr(0.2).range(0, 0.6) * 0.2,
	) / n;
}).play
)//:the source

//:add some processing on the top of the source

Ndef(\source)[1] = \filter -> {|in| HPF.ar(in, SinOsc.ar(180), LFNoise1.kr(1).range(0.1, 1) ) }

Ndef(\source)[2] = \filter -> {|in| FreeVerb.ar(in * 0.3)}

Ndef(\source)[3] = \filter -> {|in| in * SinOsc.ar( rrand(0.7, 11) )}

Ndef(\source)[4] = \filter -> {|in| in * LFPulse.ar( LFNoise1.kr(1).range(1, 10) )}



//:to suspend make nil, e.g.
Ndef(\source)[1] = nil




(
Ndef(\source)[0] = {
	//:you can edit the source without dismissing the filterings !!
	var n = 20;
		SinOsc.ar({ExpRand(200, 1200)} ! n,
			0,
		SinOsc.kr( rrand(0.5, 1) ).range(0, 0.6) * 0.2,
	) / n;
}
)

//:any change you do will be faded in by fadeTime


Ndef(\source).clear(3) //:dismiss with a fade time:(3)
