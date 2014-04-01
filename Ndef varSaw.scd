(
Ndef(\varSaw, {
	Splay.ar(
		VarSaw.ar({ExpRand(200, 1200)}!8,
			0,
			SinOsc.kr(0.2).range(0, 1) * 0.2, 0.1)
	)
}).play(0, 2)
)//:the source

(
Ndef(\varSaw)[0] =
	{
	Splay.ar(
		VarSaw.ar({ExpRand(200, 1200)}!18,
			0,
			LFNoise0.kr(0.2).range(0, 1) * 0.2, 0.1)
	)
})
)

Ndef(\varSaw)[1] = \filter -> {|in| HPF.ar(in, SinOsc.ar(220), LFNoise1.kr(10).range(0.1, 1) ) }

Ndef(\varSaw)[2] = \filter -> {|in| AdCVerb.ar(in * 0.25)}

Ndef(\varSaw)[3] = \filter -> {|in| in * SinOsc.ar(11)}

Ndef(\varSaw).clear(3) //dismiss

(
Ndef(\varSaw)[0] =
	{
	Splay.ar(
		VarSaw.ar({ExpRand(200, 1200)}!18,
			0,
			LFNoise0.kr(0.2).range(0, 1) * 0.2, 0.1)
	)
})
)