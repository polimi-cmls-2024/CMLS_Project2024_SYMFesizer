// Boot the server
s.boot;
// Search for the plugin
VSTPlugin.search(nil,"D:/Documents/Polimi/LM/Year 1/Semester 2/Computer Music Languages and Systems/SYMFesizer/SYMFesizer/Builds/VisualStudio2022");


(
// Bus that takes synth sounds to the effects
~myBus = Bus.audio(s,2);

// Define SynthDef for plucked muted string
SynthDef(\muted_string, {
    arg out = 0, freq = 440, decayTime = 0.01;
    var env = EnvGen.kr(Env.perc(0.01, decayTime));
    var filteredNoise = BPF.ar(WhiteNoise.ar, freq,0.1);
    var sound = filteredNoise * env;
	sound = Pan2.ar(sound, 0);
    Out.ar(~myBus, sound);
}).add;

// Define SynthDef for strummed string
SynthDef(\string, {arg out=0, freq=440, pan=0, sustain=0.5, amp=0.5;
	var pluck, period, string;
	pluck = PinkNoise.ar(Decay.kr(Impulse.kr(0), 0.05));
	period = freq.reciprocal;
	string = CombL.ar(pluck, period, period, sustain*6);
	string = LeakDC.ar(LPF.ar(Pan2.ar(string, pan), 12000)) * amp;
	DetectSilence.ar(string);
	Out.ar(~myBus, string)
}).add;

// Define SynthDef to wrap the VSTPlugin UGen in a synth
SynthDef(\effetto, { arg bus;
	Out.ar(Bus.new('audio',0,2,s), VSTPlugin.ar(In.ar(bus, 2), numOut: `[2]));
}).add;

// control bus to receive kinect signal
~my_right_hand = Bus.control(s, 1);

// handle kinect signal
OSCdef(\receiveOSC_Y, {
	arg msg, time, addr, recvPort;
	~my_right_hand.set(msg[1]);
	//postln(msg[1]);
}, '\p1/hand_r:ty', nil, 57120);

)

(
// define effect synth
~fx = VSTPluginController(Synth(\effetto, [\bus, ~myBus])).open("SYMFesizer.vst3");
)

(
var maj,min,maj7,min7,dom7,min7b5,dim7;

// define threshold for each string. kinect signal range is from 0 to 50.
~stringThreshs = [22,23,24,25,26,27];

// functions that detect when kinect signal passes each string threshold and send a trigger
6.do({ |i|
	{
		var down, up;
		down = (In.kr(~my_right_hand.index) > ~stringThreshs[i]);
		up = (In.kr(~my_right_hand.index) < ~stringThreshs[i]);
		SendTrig.kr(down,i,0);
		SendTrig.kr(up,i,1);
	}.play.postln;
});




// function that converts an array of fret numbers to an array of MIDI values
~fretsToChord = { arg list;
	var open = [40, 45, 50, 55, 59, 64];
	var my_chord = [0, 0, 0, 0, 0, 0];
	6.do({ |index|
		if (list[index] == 'x') {
			my_chord[index] = 0;
		} {
			my_chord[index] = list[index] + open[index];
		}
	});
	my_chord;
};

// arrays of chord voicings as fret numbers
maj = [['x', 3, 2, 0, 1, 0],['x', 4, 6, 6, 6, 4],['x', 'x', 0, 2, 3, 2],['x', 6, 8, 8, 8, 6],[0, 2, 2, 1, 0, 0],[1, 3, 3, 2, 1, 1],[2, 4, 4, 3, 2, 2],[3, 2, 0, 0, 0, 3],[4, 6, 6, 5, 4, 4],['x', 0, 2, 2, 2, 0],
['x', 1, 3, 3, 3, 1],['x', 2, 4, 4, 4, 2]];
dom7 = [['x', 3, 2, 3, 1, 0],['x', 4, 6, 4, 6, 4],['x', 5, 7, 5, 7, 5],['x', 6, 8, 6, 8, 6],[0, 2, 0, 1, 0, 0],[1, 3, 1, 2, 1, 1],[2, 4, 2, 3, 2, 2],[3, 2, 0, 0, 0, 1],[4, 6, 4, 5, 4, 4],['x', 0, 2, 0, 2, 0],['x', 1, 3, 1, 3, 1],['x', 2, 4, 2, 4, 2]];
maj7 = [['x', 3, 2, 0, 0, 0],['x', 4, 6, 5, 6, 4],['x', 5, 7, 6, 7, 5],['x', 6, 8, 7, 8, 6],['x', 7, 9, 8, 9, 7],[1, 3, 3, 2, 1, 0],[2, 'x', 3, 3, 2, 'x'],[3, 'x', 4, 4, 3, 'x'],[4, 'x', 5, 5, 4, 'x'],['x', 0, 2, 1, 2, 0],['x', 1, 3, 2, 3, 1],['x', 2, 4, 3, 4, 2]];
min = [['x', 3, 5, 5, 4, 3],['x', 4, 6, 6, 5, 4],['x', 'x', 0, 2, 3, 1],['x', 6, 8, 8, 7, 6],[0, 2, 2, 0, 0, 0],[1, 3, 3, 1, 1, 1],[2, 4, 4, 2, 2, 2],[3, 5, 5, 3, 3, 3],[4, 6, 6, 4, 4, 4],['x', 0, 2, 2, 1, 0],['x', 1, 3, 3, 2, 1],['x', 2, 4, 4, 3, 2]];
min7 = [['x', 3, 5, 3, 4, 3],['x', 4, 6, 3, 5, 4],['x', 5, 7, 5, 6, 5],['x', 6, 8, 6, 7, 6],['x', 7, 9, 7, 8, 7],[1, 3, 1, 1, 1, 1],[2, 4, 2, 2, 2, 2],[3, 5, 3, 3, 3, 3],[4, 6, 4, 4, 4, 4],['x', 0, 2, 0, 1, 0],['x', 1, 3, 1, 2, 1],['x', 2, 4, 2, 3, 2]];
min7b5 = [['x', 3, 4, 3, 4, 'x'],['x', 4, 5, 3, 5, 'x'],['x', 5, 6, 5, 6, 'x'],['x', 6, 7, 6, 7, 'x'],['x', 7, 8, 7, 8, 'x'],['x', 8, 9, 8, 9, 'x'],['x', 9, 10, 9, 10, 'x'],[3, 'x', 3, 3, 2, 'x'],[4, 'x', 4, 4, 3, 'x'],[5, 'x', 5, 5, 4, 'x'],['x', 1, 2, 1, 2, 'x'],['x', 2, 3, 2, 3, 'x']   ];
dim7 = [['x', 3, 4, 2, 4, 'x'],['x', 4, 5, 3, 5, 'x'],['x', 5, 6, 4, 6, 'x'],['x', 6, 7, 5, 7, 'x'],['x', 7, 8, 6, 8, 'x'],['x', 8, 9, 7, 9, 'x'],['x', 9, 10, 8, 10, 'x'],[3, 'x', 2, 3, 2, 'x'],[4, 'x', 3, 4, 3, 'x'],[5, 'x', 4, 5, 4, 'x'],[6, 'x', 5, 6, 5, 'x'],['x', 2, 3, 1, 3, 'x']   ];

// combine chords in a 3d array: ~allChords[Type][Starting Note][String number]
~allChords = [maj,min,maj7,min7,dom7,min7b5,dim7];

// applies function to all the chords
7.do({|i|
	12.do({|j|
		~allChords[i][j] = ~fretsToChord.value(~allChords[i][j]);
	});
});

// INIT Preset
~preset = Array.fill(12, { Array.fill(6, { 0 }) });

~preset = [
	maj7[0],
	dom7[9],
	min7[2],
	dom7[11],
	min7[4],
	maj7[5],
	dom7[2],
	dom7[7],
	dom7[4],
	min7[9],
	dom7[0],
	min7b5[11]
];

// define socket
NetAddr("127.0.0.1", 57120);

// arrays to store current preset
~types = Array.fill(12,{0});
~roots = Array.fill(12,{0});

// function that updates preset
~updatePreset = {
	12.do({ |index|
		var type,root;
		type = ~types[index];
		root = ~roots[index];
		~preset[index] = ~allChords[type][root];
	});
	postln("preset updated");
};

// Functions that receive OSC Messages from the GUI
OSCdef('/chords',
	{
		arg msg;
		var roots = Array.newClear(12);
		12.do({ |index|
			roots[index] = msg[index+1];
		});
		~roots = roots.postln;
		~updatePreset.value;
}, "/chords", recvPort: 57120);

OSCdef('/type',
	{
		arg msg;
		var types = Array.newClear(12);
		12.do({ |index|
			types[index] = msg[index+1];
		});
		~types = types.postln;
		~updatePreset.value;
}, "/type", recvPort: 57120);

(
OSCdef('/chorus/rate', // 0,100
	{
		arg msg;
		x = msg[1];
		postln("Chorus Rate: "+x);
		~fx.set("Chorus Rate",x);

}, "/chorus/rate", recvPort: 57120);
);

(
OSCdef('/chorus/depth', // 0,1
	{
		arg msg;
		x = msg[1];
		postln("Chorus Depth: "+x);
		~fx.set("Chorus Depth",x);
}, "/chorus/depth", recvPort: 57120);
);

(
OSCdef('/chorus/centreDelay', //1,100
	{
		arg msg;
		x = msg[1];
		postln("x: "+x);
		postln("Chorus Centre Delay: "+x);
		~fx.set("Chorus Centre Delay",x);
}, "/chorus/centreDelay", recvPort: 57120);
);

(
OSCdef('/chorus/feedback', //-1,1
	{
		arg msg;
		x = msg[1];
		postln("Chorus Feedback: "+x);
		~fx.set("Chorus Feedback",x);
}, "/chorus/feedback", recvPort: 57120);
);

(
OSCdef('/chorus/mix', //0,1
	{
		arg msg;
		x = msg[1];
		postln("Chorus Mix: "+x);
		~fx.set("Chorus Mix",x);
}, "/chorus/mix", recvPort: 57120);
);

(
OSCdef('/phaser/rate', // 0,100
	{
		arg msg;
		x = msg[1];
		postln("Phaser Rate: "+x);
		~fx.set("Phaser Rate",x);

}, "/phaser/rate", recvPort: 57120);
);

(
OSCdef('/phaser/depth', //0,1
	{
		arg msg;
		x = msg[1];
		postln("Phaser Depth: "+x);
		~fx.set("Phaser Depth",x);
}, "/phaser/depth", recvPort: 57120);
);

(
OSCdef('/phaser/centreFrequency', //1,100
	{
		arg msg;
		x = msg[1];
		postln("Phaser CentreFrequency: "+x);
		~fx.set("Phaser CentreFrequency",x);
}, "/phaser/centreFrequency", recvPort: 57120);


);

(
OSCdef('/phaser/feedback',  //-1,1
	{
		arg msg;
		x = msg[1];
		postln("Phaser Feedback: "+x);
		~fx.set("Phaser Feedback",x);
}, "/phaser/feedback", recvPort: 57120);
);

(
OSCdef('/phaser/mix', //0,1
	{
		arg msg;
		x = msg[1];
		postln("Phaser Mix: "+x);
		~fx.set("Phaser Mix",x);
}, "/phaser/mix", recvPort: 57120);
);

(
OSCdef('/compressor/threshold', //-50,0
	{
		arg msg;
		x = msg[1];
		postln("Compressor Threshold: "+x);
		~fx.set("Compressor Threshold",x);
}, "/compressor/threshold", recvPort: 57120);
);

(
OSCdef('/compressor/ratio', //1,30
	{
		arg msg;
		x = msg[1];
		postln("Compressor Ratio: "+x);
		~fx.set("Compressor Ratio",x);
}, "/compressor/ratio", recvPort: 57120);
);

(
OSCdef('/compressor/attack', //0,200
	{
		arg msg;
		x = msg[1];
		postln("Compressor Attack: "+x);
		~fx.set("Compressor Attack",x);
}, "/compressor/attack", recvPort: 57120);
);

(
OSCdef('/compressor/release', //5,5000
	{
		arg msg;
		x = msg[1];
		postln("Compressor Release: "+x);
		~fx.set("Compressor Release",x);
}, "/compressor/release", recvPort: 57120);
);

(
OSCdef('/panner/value', //-1,1
	{
		arg msg;
		x = msg[1];
		postln("Pan: "+x);
		~fx.set("Pan",x);
}, "/panner/value", recvPort: 57120);
);


)


(
// Block that handles MIDI and receiving triggers from previous code to play the synths
var on,off;
var stringNotes = ~preset[0];
var stringSynths = Array.newClear(6);
var mute = true;    // flag for muted string sound
var midiArray = []; // to track pressed notes
var popped = 0;

MIDIClient.init;
MIDIIn.connectAll;

// triggered by pressing a MIDI key
on = MIDIFunc.noteOn({ |veloc, num, chan, src|
	stringNotes = ~preset[num%12];
	midiArray.add(num);
	mute=false;

});

// triggered by releasing a MIDI key
off = MIDIFunc.noteOff({ |veloc, num, chan, src|
	midiArray.remove(num);
	if(midiArray.isEmpty){
		mute = true;
	}/*else*/{
		stringNotes = ~preset[midiArray.last%12];
	};
});

// Receiving triggers from the server, play the notes based on the current preset and pressed key
OSCFunc({|msg, time, addr, recvPort| var freq,note;
			("string: " + msg[2] + (if(msg[3] == 0){" down"}{" up"})).postln;
	if( stringSynths[msg[2]].notNil == true ) {stringSynths[msg[2]].free};
	note = stringNotes[msg[2]];
	freq = note.midicps;

	if( (mute == true).or(note <40) )
	{stringSynths[msg[2]] = Synth.new(\muted_string,[\freq,freq])}
	{stringSynths[msg[2]] = Synth.new(\string,[\freq,freq])};
},'/tr', s.addr);
)
