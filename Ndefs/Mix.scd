//add some Ndefs and route them to a main Ndef mix.
Ndef(\sine, {SinOsc.ar(\freq.kr(880, 0.3))}).playN([10, 11], vol:0.1)
Ndef(\saw, {VarSaw.ar(\freq.kr(180, 0.3))}).playN([10, 11], vol:0.1)
Ndef(\sine2, {SinOsc.ar([220, 221] * 0.5)}).playN([10, 11], vol:0.1)

//control the main output 
Ndef(\mix).fadeTime = 0.3;
Ndef(\mix, { Limiter.ar( In.ar([10, 11]) ).distort  }).play(0, 2, vol:0.2)

//add some effect
Ndef(\mix)[1] = \filter -> {|in| FreeVerb.ar(in, add:in) * SinOsc.ar([11, 11] * 0.5)}

NdefMixer(s)

Ndef.all

//clear all
Ndef.clear(3);
