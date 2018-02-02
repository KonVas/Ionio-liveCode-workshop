// Let's make a programme! It will be called "Hello World".

// Note: Everything to the left of // is a comment. That's for people to read, not computers

/* This is also a comment, but in a multi-line version.
We'll use comments to give you info.
Later, you'll comment your own code to help yourself and others understand */



// Okay, ready for the programme? Here it is:

"Hello World".postln; // put the cursor on this line and press Shift+Enter

/*
Look in the post window and see what you got. The first "Hello World" is there because of the 'postln' message, which says 'print a human understandable version of me and advance a line'. Code between double quotes, is a String, which is a bit of text.

The second Hello World, which comes after the arrow -> is the result of the last line of the code you just executed. The post window will give you lots of helpful info. Keep it visible!
*/



// we can have multiple lines. Note what we see in the post window with this.
// code within parens is by convention executed together as a block
(
// put the cursor inside these parens and press Cmd+Enter; that will select and execute the block, not just the line
"Hello World".postln;
"Goodbye World".postln;
)



// we can do some math operations
1 + 2;

40 * 20;

// we can store the result of an expression in a variable, to use it again
// variables should be declared at the top of a block, and must begin with a lower case letter and have no spaces
(
var result, result2; // the scope of these variables is limited to this block of code

result = 10 * 45.2;
result2 = 5.sqrt;
result + result2
)

// if we want persistent variables, we can use the letters a-z (but not s)
a = 2 + 2;
a // a contains 4

b = a + 5

c = a * b;

// or we can use what are called 'environment variables' which allow a more meaningful name. These are ~someName, etc.
~result = 10.squared;

~result
///// brackets

// parens mean calculate this first, like in math
10 + (4 * 20)

// unlike in math SC doesn't have the algebraic order of operations, so 10 + 4 * 20 is 280, not 90!

// Arrays [] are an ordered collection
~anArray = [1, 2, 3];

//this way below is just 'syntax' sugar' for writting the above
~anArray = (1..3);

// we can access elements using an index value, which is the offset from the start
~anArray[0]; // 1
~anArray[2]; // 3
~anArray[20]; // nil; nil is a special value meaning 'nothing' or 'empty'
~anArray.size; // we can check the size

// we can also put items at an index
~anArray[0] = "foo";
~anArray.postln;

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
