// Functions { } are bits of reusable code
f = { 1 + 2 };
f.value; // evaluate the function using the value message

// this is maybe more useful, as we get a different result each time
f = { 300.0.rand };
f.value

// Functions have arguments, which let us pass a value in
(
f = {arg num1, num2;
	var result;
	result = num1 + num2;
	result + 2;
};
)

f.value(4, 5); // pass in args

f.value(2, 6); // pass in different args


(
f = {|num1, num2| // alternative arg list syntax; same meaning as above
	var result;
	result = num1 + num2;
	result + 2;
};
)

(
f = {|num1 = 2, num2 = 4| // arg list with defaults
	var result;
	result = num1 + num2;
	result + 2;
};
)

f.value;

///// We can also use Functions to make Sound.....

s.boot; // this starts the Server app, which makes sound; s is reserved for the default server

{ SinOsc.ar(440, 0, 0.1) }.play;// execute to start; Press  Cmd-. to stop

// {...}.play makes a Synth. We can store this in a variable
a = { SinOsc.ar(440, 0, 0.1) }.play;

a.free; // this frees the Synth

// SinOsc is a UGen. We can plug UGens together to make complicated behaviour
// modulate freq
{ SinOsc.ar(XLine.kr(2000, 200), 0, 0.5) }.play;

(
{
	var l;
	l = XLine.kr(2000, 200);
	SinOsc.ar(l, 0, 0.5)
}.play;
)

{ SinOsc.ar(SinOsc.ar(XLine.kr(1, 1000, 9), 0, 200, 800), 0, 0.25) }.play;

{ SinOsc.ar(SinOsc.ar(0.3).range(440, 660), 0, 0.5) * 0.1 }.play;