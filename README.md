# SYMFesizer
## Project Settings
The project implemented by the SYMFesizer group for the "Computer Music: Languages and Systems" project consists of the development of an 'Air Guitar', i.e. an acoustic guitar in the air without the presence of any physical instrument. 

The sensor used is the KINECT, a sensor that allows human body parts to be picked up and scanned without the need to wear or hold anything. In particular, for the sake of time and simplicity, it was chosen to pick up the movements of the right hand only, along the y-coordinate to simulate real strumming which is affected by the speed at which it is exercised and along the x-coordinate....???

The left hand on the other hand still determines the desired chord type, but without being tracked by the sensor, simply by pressing a key on a MIDI keyboard. This key will become the root of the chord, and the musician can choose the chord type himself, between major, minor, major7, minor7, dominant7, minor7b5 and diminished7.

Thus, the general architecture of the system provides that the movement of the right hand is processed by the Touch Design software, specific to the Kinect, which sends OSCmessages to SuperCollider. In it, the creation of SinOsc and the Sound Synthesis of the acoustic guitar takes place. 

Four effects, created with JUCE, are included in Supercollider that modify the audio output. In particular a chorus and phaser, responsible for modulating the sound in time and frequency, a compressor and a panner. 

The Graphical User Interface was realised with Processing and includes the replication of the MIDI keyboard with an octave. On each key there is a drop-down menu where you can select the chord you want. There are also knobs with which all JUCE effect parameters can be modified.  

### Kinect and Touch Design
info principali su cosa usare, e dove trovare le cose qui sulla cartella

### Supercollider
most important info about sound synthesis and location of files 

### JUCE

### Processing
