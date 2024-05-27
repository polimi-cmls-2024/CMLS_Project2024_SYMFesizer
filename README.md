# SYMFesizer
## Project Settings
The project implemented by the SYMFesizer group for the "Computer Music: Languages and Systems" project consists of the development of an 'Air Guitar', i.e. an acoustic guitar in the air without the presence of any physical instrument. 

The sensor used is the KINECT, a sensor that allows human body parts to be picked up and scanned without the need to wear or hold anything. In particular, for the sake of time and simplicity, it was chosen to pick up the movements of the right hand only, along the y-coordinate to simulate real strumming which is affected by the speed.

The left hand on the other hand still determines the desired chord type, but without being tracked by the sensor, simply by pressing a key on a MIDI keyboard. This key will become the root of the chord, and the musician can choose the chord type himself, between  major
triad, minor triad, major 7<sup>th</sup>, minor 7<sup>th</sup>, dominant 7<sup>th</sup>, half-diminished 7<sup>th</sup> and diminished 7<sup>th</sup>.

Thus, the general architecture of the system provides that the movement of the right hand is processed by the Touch Design software, specific to the Kinect, which sends OSCmessages to SuperCollider. In it, the creation of SinOsc and the Sound Synthesis of the acoustic guitar takes place. 

Four effects, created with JUCE, are included in Supercollider that modify the audio output. In particular a chorus and phaser, responsible for modulating the sound in time and frequency, a compressor and a panner. 

The Graphical User Interface was realised with Processing and includes the replication of the MIDI keyboard with an octave. On each key there is a drop-down menu where you can select the chord you want. There are also knobs with which all JUCE effect parameters can be modified.  

## Kinect
This project uses a Kinect sensor and TouchDesigner to capture the Y-axis movement of the right hand, simulating the action of playing a guitar. 
This setup enables real-time interaction and creative applications, ideal for performances, installations, or experimental music interfaces.
### Installation:

**Hardware Setup**: Connect the Kinect sensor to your computer.

**Software Requirements**:

- **TouchDesigner**: A versatile tool for real-time interactive multimedia creation. [Download TouchDesigner](https://derivative.ca/)
- **Kinect Drivers**: Ensure your Kinect sensor is fully operational by installing the necessary components:
  - **Kinect SDK**: The essential software development kit for Kinect. [Get Kinect SDK](https://developer.microsoft.com/en-us/windows/kinect)
  - **Kinect Toolkit**: Additional utilities for enhanced development. [Download Kinect Toolkit](https://www.microsoft.com/en-us/download/details.aspx?id=40276)
  - **Kinect Runtime**: Required runtime for running applications. [Download Kinect Runtime](https://www.microsoft.com/en-us/download/details.aspx?id=44561)

### Usage:
- Open the `KinectSC.toe` file in TouchDesigner. 
- Ensure the Kinect is properly connected and recognized by the system. 
- Run the project on SuperCollider.
  
Move your right hand up and down in front of the Kinect sensor. The Y-axis movement will be mapped to simulate strumming a guitar.


## Synthesis and Control: SuperCollider
[VSTPlugin](https://git.iem.at/pd/vstplugin) is used to import the JUCE plugin inside SuperCollider.
In SuperCollider, load the script `strum.scd`, and run the blocks of code in order. Make sure that the path to the **JUCE** build (where the `.vst3` file is) is set correctly in the `VSTPlugin.search` function.

These are the functions of each block:
- Start the server, search for **VST** plugin
- Define busses and SynthDefs, handle kinect signal
- Define effect synth
- Handle note triggers, define list of chords, handle **GUI** messages
- Handle MIDI, and play synth sound based on available data

## Effects: JUCE
The project settings must be chosen as a 'Plugin->Basic' and named as desider. 
As Plugin Formats is set 'VST3' and as Plugin Characteristics any setting doesn't has to be set.
In Source, 'Editor.h', 'Editor.cpp', 'Processor.h' and 'Processor.cpp' are created by default. The first two couldn't be modified because they are important only for the graphic design of JUCE. The other two file must be filled following the comments on the code and the report. 
In addition to the modules added by deafult, the module juce_dsp has to be implemented, without this one any DSP effect can be set. 

In the project are implemented a chorus, a phaser, a compressor and a panner as effects and the connection with Supercollider, that sends OSCmessage to JUCE. 

## GUI: Processing
The GUI is developed by the use of Processing. For the setup you need to install the following libraries: "G4P", "ControlP5" and "oscP5". You can find them directly inside the software, in the "Tools" menu. 
From the GUI you can choose the chords you want to play on the MIDI keybord and also add and controlls each effect performed by JUCE.   
