/* use a Pbindef to change only the parameter you want */

Pbindef(\x, \instrument, \grain, \dur, 0.08, \freq, Prand( (200..600), inf) ).play

Pdef(\x, \instrument, \grain, \dur, 0.8, \freq, Prand( (200..600), inf) ).play

