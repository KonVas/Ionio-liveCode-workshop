(
Ndef(\source, { | pul = 8 |
	Impulse.ar(pul)
}).play(0, 2, vol:0.2)
)

//:mix things up
Ndef(\source)[3] = \mix -> {  Dust.ar(3.dup) }

//:set with a patterns
Ndef(\source)[1] = \set -> Pbindef(\x, \pul, Prand([6, 8, 9], inf), \dur, Pbrown(1, 3, 0.5, inf));

//:pass an envelope
Ndef(\source)[2] = \filter -> {|in|  EnvGen.ar( Env.perc(0.03, 0.5, 1), TDuty.ar(Drand([0.1, 0.3], inf)) ) * in }

//:and filter out
Ndef(\source)[4] =  \filter -> { |in| RLPF.ar(in, LFNoise2.kr(1).exprange(300, 1000), 0.1) }

//:clear when done
Ndef(\source).clear(3)