# Live Coding in SuperCollider

[[https://supercollider.github.io/][SuperCollider]] (SC) is a programming language for audio synthesis; it provides a state of the art server to create sound and a programming language to interact and evaluate code, as well as a fully functional IDE and help browser. SC is oriented for sound synthesis and algorithmic composition providing a series of ready made classes to manipulate and create real time sound on the computer.

Creating sound with SC can be very rewarding using its ready made unit generators to build novel instruments and sound generators, but what happens when one wants to improvise the structure
of these instruments and change them on the fly.

## Live coding as a musical performance paradigm

Dynamic or interactive programming, commonly known as live coding (in electronic
music, and digital arts) is a performance paradigm that allows the performer(s)
to change the state of the program and thus expand it on the fly.

For this we will use JITLib shipped in SC optimized for _just in time_ programming, which allows the user to interact and interfere to the musical output without having to stop and update the synthesis processes while at run. This allows the performer to improvise and change the state of the sound manipulation dynamically, expanding the
interaction affordances of the software in real time.

For the workshop we will use examples made in SuperCollider and JITLib, which can be found at this repository (always pay attention to volume while interacting with the running processes). For more information about live coding as performance paradigm see this [[http://toplap.org][page]].

## Examples:
Define an Ndef, a synthesis proxy!

``` js
Ndef(\x).fadeTime = 2;

Ndef(\x).play;

Ndef(\x, {SinOsc.ar(\freq.kr(120.0, 0.3)) * 0.1 });

Ndef(\x, {SinOsc.ar([\freq.kr(120.0), \freq.kr + 2.01]) / 2 * 0.1});

Ndef(\x, {LFSaw.ar([\freq.kr(120.0), \freq.kr + 2.01]) / 2 * 0.1});

Ndef(\x, {LFSaw.ar([\freq.kr(120.0), \freq.kr + 2.01]) / 2 * Linen.kr(Impulse.kr(\speed.kr(1)))});

// Make an Ndef mixer to control the node definitions via a GUI

NdefMixer(s);
```

The most interesting feature in JITLib is that one can call things that do not exist as long as they are created later!/
#### For other conveniences see this repository and the JITLib Overview help file in SuperCollider

## Resources and acknowledgements
+ Download SuperCollider (latest stable) [[http://supercollider.github.io][here]].
+ [[http://doc.sccode.org/Overviews/JITLib.html][JITLib]] mainly created by Julian Rohrhuber, with contributions by Alberto De Campo.
+ [[http://ethos.bl.uk/OrderDetails.do?uin=uk.bl.ethos.682112][Chapter]] on live Coding of my PhD thesis including historical and recent practices (groups, software, etc.).
