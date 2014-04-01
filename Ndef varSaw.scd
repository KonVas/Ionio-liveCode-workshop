// Use at your own risk, always take care of the VOLUME!!!!!!!

Ndef(\varSaw).fadeTime = 3; //: first do this, you can change later to any fadeTime you want.

NdefMixer(s); //:make a GUI

(
Ndef(\varSaw, {
	var n = 8;
	Splay.ar(
		VarSaw.ar({ExpRand(200, 1200)}!n,
			0,
			SinOsc.kr(0.2).range(0, 1) * 0.2,
			0.3 / n)
	)
}).play(0, 2)
)//:the source

//:add some processing on the top of the source

Ndef(\varSaw)[1] = \filter -> {|in| HPF.ar(in, SinOsc.ar(180), LFNoise1.kr(1).range(0.1, 1) ) }

Ndef(\varSaw)[2] = \filter -> {|in| FreeVerb.ar(in * 0.3, add:in)}

Ndef(\varSaw)[3] = \filter -> {|in| in * SinOsc.ar( rrand(0.7, 11) )}

Ndef(\varSaw)[4] = \filter -> {|in| in * LFPulse.ar( LFNoise1.kr(1).range(1, 10) )}



//:to suspend make nil, e.g.
Ndef(\varSaw)[1] = nil



//:you can edit the source without dismissing the filterings !!
(
Ndef(\varSaw)[0] = {
	var n = 8;
	Splay.ar(
		VarSaw.ar({ExpRand(200, 1200)}!n,
			0,
			SinOsc.kr(0.2).range(0, 1) * 0.2,
			0.3 / n)
	)
}
)



//:any change you do will be faded in by fadeTime


Ndef(\varSaw).clear(3) //:dismiss with a fade time:(3)