# SYMFesizer
## Project Settings
The project implemented by the SYMFesizer group for the "Computer Music: Languages and Systems" project consists of the development of an 'Air Guitar', i.e. an acoustic guitar in the air without the presence of any physical instrument. 

The sensor used is the KINECT, a sensor that allows human body parts to be picked up and scanned without the need to wear or hold anything. In particular, for the sake of time and simplicity, it was chosen to pick up the movements of the right hand only, along the y-coordinate to simulate real strumming which is affected by the speed.

The left hand on the other hand still determines the desired chord type, but without being tracked by the sensor, simply by pressing a key on a MIDI keyboard. This key will become the root of the chord, and the musician can choose the chord type himself, between  major
triad, minor triad, major 7<sup>th</sup>, minor 7<sup>th</sup>, dominant 7<sup>th</sup>, half-diminished 7<sup>th</sup> and diminished 7<sup>th</sup>.

Thus, the general architecture of the system provides that the movement of the right hand is processed by the Touch Design software, specific to the Kinect, which sends OSCmessages to SuperCollider. In it, the creation of SinOsc and the Sound Synthesis of the acoustic guitar takes place. 

Four effects, created with JUCE, are included in Supercollider that modify the audio output. In particular a chorus and phaser, responsible for modulating the sound in time and frequency, a compressor and a panner. 

The Graphical User Interface was realised with Processing and includes the replication of the MIDI keyboard with an octave. On each key there is a drop-down menu where you can select the chord you want. There are also knobs with which all JUCE effect parameters can be modified.  

### Kinect and Touch Design
info principali su cosa usare, e dove trovare le cose qui sulla cartella

### Supercollider
**SuperCollider** is an engine for sound synthesis and algorithmic music composition.
It is a real-time sound-based object oriented programming language. 
It is extensively used for music and acoustic research, algorithmic music, dynamic programming and live audio coding. SuperCollider consists of two components: a server (scsynth) and a client (sclang), which communicate through OSC (OpenSound Control) messages, i.e. using TCP/UDP protocol. 

The SuperCollider part of the project is the main part that connects everything together. In addition to generating synthesized guitar sound, it receives information from the **Kinect**, MIDI keyboard, and the user interface. Moreover, this is where the effects unit is instantiated.

#### Synthesis
The primary synthesis technique used is **Karplus-Strong synthesis**, which involves generating a noise burst to represent a pluck, and using a comb filter to simulate string resonance. This method could be seen as a form of subtractive synthesis, and is effective for creating realistic string instrument sounds in digital audio synthesis. The code is as follows:

```
SynthDef(\string, {arg out=0, freq=440, pan=0, sustain=0.5, amp=0.5;
	var pluck, period, string;
	pluck = PinkNoise.ar(Decay.kr(Impulse.kr(0), 0.05));
	period = freq.reciprocal;
	string = CombL.ar(pluck, period, period, sustain*6);
	string = LeakDC.ar(LPF.ar(Pan2.ar(string, pan), 12000)) * amp;
	DetectSilence.ar(string);
	Out.ar(~myBus, string)
}).add;
```
A burst of pink noise is generated triggered by an impulse, decaying over 0.05 seconds. This is then passed through a comb filter with delay time equal to the reciprocal of the frequency to simulate string resonance. The signal is then panned to two channels, passed through a low pass filter at 12 KHz, and the DC offset is removed. The silence is detected to free the synth when there is no more sound, and the 2 channels are sent to a bus. A second `SynthDef` was used to model the sound of muted strings using enveloped noise.

#### Receiving OSC and MIDI messages
OSC messages are received with information from the **GUI**, from the **Kinect**, and triggers from within SuperCollider to generate string sounds.

Messages from the **GUI** are used to adjust parameters for the effects, as well as assign chords to **MIDI** keys.

Handling messages from the **MIDI** input was implemented by using an array to store key presses. Whenever a key is pressed, its value is inserted as the last element in an array. And, when a key is released, its value is removed from the array. This ensures that the last element of the array is always the intended value to play a current chord.

#### Strumming Mechanism
The signal from the **Kinect** is received via OSC messages and sent to the `~my_right_hand` bus. There are anonymous functions that detect when the value in the bus passes certain boundaries set for the strings. Whenever a boundary is passed, a trigger message is sent with the string number and whether it is a down or up stroke. This could be used to trigger different sounds based on the stroke direction, although this isn't used in the current state of the project. Here is the code for the functions: 

```
6.do({ |i|
	{
		var down, up;
		down = (In.kr(~my_right_hand.index) > ~stringThreshs[i]);
		up = (In.kr(~my_right_hand.index) < ~stringThreshs[i]);
		SendTrig.kr(down,i,0);
		SendTrig.kr(up,i,1);
	}.play.postln;
});
```

These trigger messages are received, and then the corresponding sound is played, based on the current preset of chords, and the signal from the MIDI keyboard.

#### Chord Voicings
An important part of sounding like a guitar is to use typical guitar voicings. This was done by listing each possible chord as an array of fret numbers, or `'x'` to resemble a muted string. A function then converted these arrays into arrays of **MIDI** values. These are then converted to frequency values using the built-in `midicps` function when it is time to play a note. The chords are split into different arrays based on type of chord. The available types of chords are: major triad, minor triad, major 7<sup>th</sup>, minor 7<sup>th</sup>, dominant 7<sup>th</sup>, half-diminished 7<sup>th</sup>, and diminished 7<sup>th</sup>. Combining these arrays of chords creates a 3-dimensional array containing all the chords. The default preset assigns diatonic 7<sup>th</sup> chords in the key of C to the white keys, and secondary dominant chords to the black keys. This, of course, could be adjusted within the **GUI**.

#### Effects
A **SuperCollider** extension **VSTPlugin** was used to encapsulate the **JUCE** code inside a module with input and output. By exporting the **JUCE** project as a **VST3** plugin, this allowed the extension to load the plugin into **SuperCollider**. The output from the synths was routed into the plugin, and the output from the plugin was routed to the output bus. The plugin parameters were adjusted based on **OSC** messages from the **GUI**.

### JUCE
The project settings must be chosen as a 'Plugin->Basic' and named as desider. 
As Plugin Formats is set 'VST3' and as Plugin Characteristics any setting doesn't has to be set.
In Source, 'Editor.h', 'Editor.cpp', 'Processor.h' and 'Processor.cpp' are created by default. The first two couldn't be modified because they are important only for the graphic design of JUCE. The other two file must be filled following the comments on the code and the report. 
In addition to the modules added by deafult, the module juce_dsp has to be implemented, without this one any DSP effect can be set. 

In the project are implemented a chorus, a phaser, a compressor and a panner as effects and the connection with Supercollider, that sends OSCmessage to JUCE. 
### Processing
The GUI is developed by the use of Processing. For the setup you need to install the following libraries: "G4P", "ControlP5" and "oscP5". You can find them directly inside the software, in the "Tools" menu. 
From the GUI you can choose the chords you want to play on the MIDI keybord and also add and controlls each effect performed by JUCE.   
