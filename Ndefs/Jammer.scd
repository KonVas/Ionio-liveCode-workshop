~speed = 8

Ndef(\crack,  { | in | Crackle.ar( LFNoise0.kr(~speed).range(0.1, 1.75), 0.1, 0.1 )  }).play

Ndef(\source, { Dust.ar( 1.75.dup ) }).play

Ndef(\beat, { Impulse.ar([1, ~speed]) * 0.8 }).play(0,2)


(
Ndef(\dust, {
	var in = Ndef(\crackle).ar;
	Splay.ar(
		Ringz.ar( in,
			{ ExpRand(200, 1200) }!4,
			\decay.kr(0.3, 0.5 )
		)
	)
})
)

Ndef(\dust).fadeTime = 0.4;
Ndef(\dust).play(0, 2);

(
Ndef(\crackle, {
	Crackle.ar(LFNoise0.kr(10).range(0.1, 2.0), 0.5, 0.5) * Ndef(\beat).ar
});
)

Ndef(\crackle).play(0, 2)

Ndef(\pad).play
Ndef(\pad).fadeTime = 2;

Ndef(\pad, { Resonz.ar( WhiteNoise.ar(0.3.dup, 0.5, 0.5), {ExpRand(220, 1220)}!8, 0.9.rand.max(0.1), mul:0.1) });

Tdef(\padTask, {
	loop{
		Ndef(\pad)[0] = { Resonz.ar( WhiteNoise.ar(0.3.dup, 0.5, 0.5), {ExpRand(220, 1220)}!8, 0.9.rand.max(0.1), mul:0.1) };
		3.wait
}
}).play

Ndef(\pad)[1] = \filter -> { |in| CombC.ar( CombC.ar( in, 0.6, 0.6 ), 0.02, 0.03 )}

Ndef(\pad)[2] = \filter -> { |in| PitchShift.ar ( in, 0.08, 1, 8, 0.5, add:in) }

Ndef(\pad)[3] = \filter -> { |in| RHPF.ar( in, 120, 0.6, 0.3 )}

Tdef(\padTask).play
Tdef(\padTask).stop

NdefMixer(s)
Ndef.clear(3)
