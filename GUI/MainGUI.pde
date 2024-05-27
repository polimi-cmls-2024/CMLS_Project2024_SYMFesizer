//Importing all the library needed for our GUI, in this case:
//G4P = provides a graphical way to develop the project. It is used to give to the GUI an initial setup. 
//ControlP5 = provides some graphical elements such as lists and labels.
//oscP5 & netP5 = provide the comunication with SuperCollider by sending OSC messages.

import g4p_controls.*;
import controlP5.*;
import oscP5.*;
import netP5.*;

//------------------------------------

//Initializing cp5 and oscP5 classes
ControlP5 cp5; // you always need the main classes
OscP5 oscP5;

//----------------------------------------------------

//Creating the address where the OSC messages are sent
NetAddress myRemoteLocation;

//-----------------------------------------------------------------------------------------------------------------------------------------

//declarating in the order the variables for: images, OSC messagess, droplists both for chord and type of chord selection, effects' labels.
PImage img, logo;

float ratep, depthp, cfreq, feedbackp, mixp, rate, depth, cdelay, feedback, 
       mix, threshold, ratio, attack, release, pan;

DropdownList dl1, dl2, dl3, dl4, dl5, dl6, dl7, dl8, dl9, dl10, dl11, dl12;
DropdownList sl1, sl2, sl3, sl4, sl5, sl6, sl7, sl8, sl9, sl10, sl11, sl12;

Textlabel cRate, cDepth, cCDelay, cFeedback, cMix, pPan,                          
          pRatep, pDepthp, pCFrequency, pFeedbackp, pMixp, 
          cThreshold, cRatio, cAttack, cRelease;


public void setup(){
  
  //definig the size of the window of the GUI, deciding to make it not resizable 
  size(1040, 640, JAVA2D);
  
  //declaration of the functions used by the G4p library. They are autogenerated by using it.
  createGUI();
  customGUI();
  
  //---------------------------------------------------------------------------------------
  
  //loading images and setting their size. Keyboard and team's logo are inserted by this way.
  img = loadImage("Tastiera.png");
  img.resize(1000,340);
  logo = loadImage("logo.png");
  logo.resize(100,100);
 
  //---------------------------------------------------------------------------------------
  
  //creating instances of the 'ControlP5' and 'OscP5' classes, allowing you to use their methods and properties to work with UI elements and OSC messages, respectively.
  cp5 = new ControlP5(this);
  oscP5 = new OscP5(this, 12000);
  
  //defining the address which OSC messages are sent to. 
  myRemoteLocation = new NetAddress("127.0.0.1", 57120);
 
 
//-----------------------------------------------------------------------------------------

//Creating the droplists in order to provide the selection of the chords which the user wants to play on the keybord 

  dl1 = cp5.addDropdownList("Chord1")
                 .setPosition(61.5, 260)                 //setting all the droplists' parametres
                 .setSize(50, 150)                       //setting the size of the open droplist
                 .setItemHeight(30)                      //setting the height of every item 
                 .setBackgroundColor(color(37,233,237))  //setting the color of the list
                 .setBarHeight(40)                       //setting the height of the scrollbar
                 .setOpen(false)                         //making the lists be closed at the opening of the GUI
                 .setValue(0.0);                         //setting the default value of the keys in order to provide to the user an initial setup
                                                         
  // Adding the possibility to switch and select between every chord 
  dl1.addItem("C", 1);
  dl1.addItem("C#", 2);
  dl1.addItem("D", 3);
  dl1.addItem("D#", 4);
  dl1.addItem("E", 5);
  dl1.addItem("F", 6);
  dl1.addItem("F#", 7);
  dl1.addItem("G", 8);
  dl1.addItem("G#", 9);
  dl1.addItem("A", 10);
  dl1.addItem("A#", 11);
  dl1.addItem("B", 12);
  dl1.addItem("-", 13);
  
  
  
  dl2 = cp5.addDropdownList("Chord2")
                 .setPosition(133, 180) 
                 .setSize(50, 150) 
                 .setItemHeight(30)
                 .setBackgroundColor(color(37,233,237))
                 .setBarHeight(40)
                 .setOpen(false)                        //making the lists be closed at the opening of the GUI
                 .setValue(9.0);
                 
  dl2.addItem("C", 1);
  dl2.addItem("C#", 2);
  dl2.addItem("D", 3);
  dl2.addItem("D#", 4);
  dl2.addItem("E", 5);
  dl2.addItem("F", 6);
  dl2.addItem("F#", 7);
  dl2.addItem("G", 8);
  dl2.addItem("G#", 9);
  dl2.addItem("A", 10);
  dl2.addItem("A#", 11);
  dl2.addItem("B", 12);
  dl2.addItem("-", 13);
  
 
  
  dl3 = cp5.addDropdownList("Chord3")
                 .setPosition(200.5, 260) 
                 .setSize(50, 150) 
                 .setItemHeight(30)
                 .setBackgroundColor(color(37,233,237))
                 .setBarHeight(40)
                 .setOpen(false) 
                 .setValue(2.0);
                 
  dl3.addItem("C", 1);
  dl3.addItem("C#", 2);
  dl3.addItem("D", 3);
  dl3.addItem("D#", 4);
  dl3.addItem("E", 5);
  dl3.addItem("F", 6);
  dl3.addItem("F#", 7);
  dl3.addItem("G", 8);
  dl3.addItem("G#", 9);
  dl3.addItem("A", 10);
  dl3.addItem("A#", 11);
  dl3.addItem("B", 12);
  dl3.addItem("-", 13);
  
 
 
  dl4 = cp5.addDropdownList("Chord4")
                 .setPosition(276, 180) 
                 .setSize(50, 150) 
                 .setItemHeight(30)
                 .setBackgroundColor(color(37,233,237))
                 .setBarHeight(40)
                 .setOpen(false) 
                 .setValue(11.0);
        
  dl4.addItem("C", 1);
  dl4.addItem("C#", 2);
  dl4.addItem("D", 3);
  dl4.addItem("D#", 4);
  dl4.addItem("E", 5);
  dl4.addItem("F", 6);
  dl4.addItem("F#", 7);
  dl4.addItem("G", 8);
  dl4.addItem("G#", 9);
  dl4.addItem("A", 10);
  dl4.addItem("A#", 11);
  dl4.addItem("B", 12);
  dl4.addItem("-", 13);
  
  
 
  dl5 = cp5.addDropdownList("Chord5")
                 .setPosition(347.5, 260) 
                 .setSize(50, 150) 
                 .setItemHeight(30)
                 .setBackgroundColor(color(37,233,237))
                 .setBarHeight(40)
                 .setOpen(false) 
                 .setValue(4.0);
  
  dl5.addItem("C", 1);
  dl5.addItem("C#", 2);
  dl5.addItem("D", 3);
  dl5.addItem("D#", 4);
  dl5.addItem("E", 5);
  dl5.addItem("F", 6);
  dl5.addItem("F#", 7);
  dl5.addItem("G", 8);
  dl5.addItem("G#", 9);
  dl5.addItem("A", 10);
  dl5.addItem("A#", 11);
  dl5.addItem("B", 12);
  dl5.addItem("-", 13);
  
 
 
  dl6 = cp5.addDropdownList("Chord6")
                 .setPosition(489, 260)  
                 .setSize(50, 150) 
                 .setItemHeight(30)
                 .setBackgroundColor(color(37,233,237))
                 .setBarHeight(40)
                 .setOpen(false) 
                 .setValue(5.0);
 
  dl6.addItem("C", 1);
  dl6.addItem("C#", 2);
  dl6.addItem("D", 3);
  dl6.addItem("D#", 4);
  dl6.addItem("E", 5);
  dl6.addItem("F", 6);
  dl6.addItem("F#", 7);
  dl6.addItem("G", 8);
  dl6.addItem("G#", 9);
  dl6.addItem("A", 10);
  dl6.addItem("A#", 11);
  dl6.addItem("B", 12);
  dl6.addItem("-", 13);
  
  
  
  dl7 = cp5.addDropdownList("Chord7")
                 .setPosition(558, 180) 
                 .setSize(50, 150) 
                 .setItemHeight(30)
                 .setBackgroundColor(color(37,233,237))
                 .setBarHeight(40)
                 .setOpen(false) 
                 .setValue(2.0);
            
  dl7.addItem("C", 1);
  dl7.addItem("C#", 2);
  dl7.addItem("D", 3);
  dl7.addItem("D#", 4);
  dl7.addItem("E", 5);
  dl7.addItem("F", 6);
  dl7.addItem("F#", 7);
  dl7.addItem("G", 8);
  dl7.addItem("G#", 9);
  dl7.addItem("A", 10);
  dl7.addItem("A#", 11);
  dl7.addItem("B", 12);
  dl7.addItem("-", 13);
  
  
 
  dl8 = cp5.addDropdownList("Chord8")
                 .setPosition(630, 260) 
                 .setSize(50, 150) 
                 .setItemHeight(30)
                 .setBackgroundColor(color(37,233,237))
                 .setBarHeight(40)
                 .setOpen(false) 
                 .setValue(7.0);

  dl8.addItem("C", 1);
  dl8.addItem("C#", 2);
  dl8.addItem("D", 3);
  dl8.addItem("D#", 4);
  dl8.addItem("E", 5);
  dl8.addItem("F", 6);
  dl8.addItem("F#", 7);
  dl8.addItem("G", 8);
  dl8.addItem("G#", 9);
  dl8.addItem("A", 10);
  dl8.addItem("A#", 11);
  dl8.addItem("B", 12);
  dl8.addItem("-", 13);
  
  
  
  dl9 = cp5.addDropdownList("Chord9")
                 .setPosition(700, 180) 
                 .setSize(50, 150) 
                 .setItemHeight(30)
                 .setBackgroundColor(color(37,233,237))
                 .setBarHeight(40)
                 .setOpen(false) 
                 .setValue(4.0);
   
  dl9.addItem("C", 1);
  dl9.addItem("C#", 2);
  dl9.addItem("D", 3);
  dl9.addItem("D#", 4);
  dl9.addItem("E", 5);
  dl9.addItem("F", 6);
  dl9.addItem("F#", 7);
  dl9.addItem("G", 8);
  dl9.addItem("G#", 9);
  dl9.addItem("A", 10);
  dl9.addItem("A#", 11);
  dl9.addItem("B", 12);
  dl9.addItem("-", 13);
  
  
  
  dl10 = cp5.addDropdownList("Chord10")
                 .setPosition(773, 260) 
                 .setSize(50, 150) 
                 .setItemHeight(30)
                 .setBackgroundColor(color(37,233,237))
                 .setBarHeight(40)
                 .setOpen(false) 
                 .setValue(9.0);
 
  dl10.addItem("C", 1);
  dl10.addItem("C#", 2);
  dl10.addItem("D", 3);
  dl10.addItem("D#", 4);
  dl10.addItem("E", 5);
  dl10.addItem("F", 6);
  dl10.addItem("F#", 7);
  dl10.addItem("G", 8);
  dl10.addItem("G#", 9);
  dl10.addItem("A", 10);
  dl10.addItem("A#", 11);
  dl10.addItem("B", 12);
  dl10.addItem("-", 13);
  
  
  
  dl11 = cp5.addDropdownList("Chord11")
                 .setPosition(840, 180)
                 .setSize(50, 150) 
                 .setItemHeight(30)
                 .setBackgroundColor(color(37,233,237))
                 .setBarHeight(40)
                 .setOpen(false) 
                 .setValue(0.0);

  dl11.addItem("C", 1);
  dl11.addItem("C#", 2);
  dl11.addItem("D", 3);
  dl11.addItem("D#", 4);
  dl11.addItem("E", 5);
  dl11.addItem("F", 6);
  dl11.addItem("F#", 7);
  dl11.addItem("G", 8);
  dl11.addItem("G#", 9);
  dl11.addItem("A", 10);
  dl11.addItem("A#", 11);
  dl11.addItem("B", 12);
  dl11.addItem("-", 13);
  
  
  
  dl12 = cp5.addDropdownList("Chord12")
                 .setPosition(910, 260) 
                 .setSize(50, 150) 
                 .setItemHeight(30)
                 .setBackgroundColor(color(37,233,237))
                 .setBarHeight(40)
                 .setOpen(false) 
                 .setValue(11.0);
     
  dl12.addItem("C", 1);
  dl12.addItem("C#", 2);
  dl12.addItem("D", 3);
  dl12.addItem("D#", 4);
  dl12.addItem("E", 5);
  dl12.addItem("F", 6);
  dl12.addItem("F#", 7);
  dl12.addItem("G", 8);
  dl12.addItem("G#", 9);
  dl12.addItem("A", 10);
  dl12.addItem("A#", 11);
  dl12.addItem("B", 12);
  dl12.addItem("-", 13);
  
  
  
 
//----------------------------------------------------------------------------------------------------------------

//creating the dropdown lists that provide the selection of the chord's type

  sl1 = cp5.addDropdownList("Ctype1")
                 .setPosition(61.5, 35)                 //setting all the droplists' parametres as the previous case
                 .setSize(50, 150)      
                 .setItemHeight(30)
                 .setBackgroundColor(color(37,233,237))
                 .setBarHeight(40)
                 .setOpen(false);                       //making the lists be closed at the opening of the GUI
                 
  
  // Adding the possibility to switch and select between every major chord by adding items
  sl1.addItem("Maj", 1);
  sl1.addItem("min", 2);
  sl1.addItem("Maj7", 3);
  sl1.addItem("min7", 4);
  sl1.addItem("dom7", 5);
  sl1.addItem("min7b5", 6);
  sl1.addItem("dim7", 7);
  
  
  
  
  
  sl2 = cp5.addDropdownList("Ctype2")
                 .setPosition(133, 35) 
                 .setSize(50, 150) 
                 .setItemHeight(30)
                 .setBackgroundColor(color(37,233,237))
                 .setBarHeight(40)
                 .setOpen(false) 
                 .setValue(4.0);
                 
  sl2.addItem("Maj", 1);
  sl2.addItem("min", 2);
  sl2.addItem("Maj7", 3);
  sl2.addItem("min7", 4);
  sl2.addItem("dom7", 5);
  sl2.addItem("min7b5", 6);
  sl2.addItem("dim7", 7);
  
  
 
  
  sl3 = cp5.addDropdownList("Ctype3")
                 .setPosition(200.5, 35) 
                 .setSize(50, 150) 
                 .setItemHeight(30)
                 .setBackgroundColor(color(37,233,237))
                 .setBarHeight(40)
                 .setOpen(false) 
                 .setValue(3.0);
                 
  sl3.addItem("Maj", 1);
  sl3.addItem("min", 2);
  sl3.addItem("Maj7", 3);
  sl3.addItem("min7", 4);
  sl3.addItem("dom7", 5);
  sl3.addItem("min7b5", 6);
  sl3.addItem("dim7", 7);
  
 
 
  sl4 = cp5.addDropdownList("Ctype4")
                 .setPosition(276, 35) 
                 .setSize(50, 150) 
                 .setItemHeight(30)
                 .setBackgroundColor(color(37,233,237))
                 .setBarHeight(40)
                 .setOpen(false) 
                 .setValue(4.0);
        
  sl4.addItem("Maj", 1);
  sl4.addItem("min", 2);
  sl4.addItem("Maj7", 3);
  sl4.addItem("min7", 4);
  sl4.addItem("dom7", 5);
  sl4.addItem("min7b5", 6);
  sl4.addItem("dim7", 7);
  
  
  
 
  sl5 = cp5.addDropdownList("Ctype5")
                 .setPosition(347.5, 35) 
                 .setSize(50, 150) 
                 .setItemHeight(30)
                 .setBackgroundColor(color(37,233,237))
                 .setBarHeight(40)
                 .setOpen(false) 
                 .setValue(3.0);
  
  sl5.addItem("Maj", 1);
  sl5.addItem("min", 2);
  sl5.addItem("Maj7", 3);
  sl5.addItem("min7", 4);
  sl5.addItem("dom7", 5);
  sl5.addItem("min7b5", 6);
  sl5.addItem("dim7", 7);
  
 
 
  sl6 = cp5.addDropdownList("Ctype6")
                 .setPosition(489, 35) 
                 .setSize(50, 150) 
                 .setItemHeight(30)
                 .setBackgroundColor(color(37,233,237))
                 .setBarHeight(40)
                 .setOpen(false) 
                 .setValue(2.0);
 
  sl6.addItem("Maj", 1);
  sl6.addItem("min", 2);
  sl6.addItem("Maj7", 3);
  sl6.addItem("min7", 4);
  sl6.addItem("dom7", 5);
  sl6.addItem("min7b5", 6);
  sl6.addItem("dim7", 7);
  
  
  
  sl7 = cp5.addDropdownList("Ctype7")
                 .setPosition(558, 35) 
                 .setSize(50, 150) 
                 .setItemHeight(30)
                 .setBackgroundColor(color(37,233,237))
                 .setBarHeight(40)
                 .setOpen(false) 
                 .setValue(4.0);
            
  sl7.addItem("Maj", 1);
  sl7.addItem("min", 2);
  sl7.addItem("Maj7", 3);
  sl7.addItem("min7", 4);
  sl7.addItem("dom7", 5);
  sl7.addItem("min7b5", 6);
  sl7.addItem("dim7", 7);
  
  
  
 
  sl8 = cp5.addDropdownList("Ctype8")
                 .setPosition(630, 35) 
                 .setSize(50, 150) 
                 .setItemHeight(30)
                 .setBackgroundColor(color(37,233,237))
                 .setBarHeight(40)
                 .setOpen(false) 
                 .setValue(4.0);

  sl8.addItem("Maj", 1);
  sl8.addItem("min", 2);
  sl8.addItem("Maj7", 3);
  sl8.addItem("min7", 4);
  sl8.addItem("dom7", 5);
  sl8.addItem("min7b5", 6);
  sl8.addItem("dim7", 7);
  
  
  
  
  
  sl9 = cp5.addDropdownList("Ctype9")
                 .setPosition(700, 35) 
                 .setSize(50, 150) 
                 .setItemHeight(30)
                 .setBackgroundColor(color(37,233,237))
                 .setBarHeight(40)
                 .setOpen(false) 
                 .setValue(4.0);
   
  sl9.addItem("Maj", 1);
  sl9.addItem("min", 2);
  sl9.addItem("Maj7", 3);
  sl9.addItem("min7", 4);
  sl9.addItem("dom7", 5);
  sl9.addItem("min7b5", 6);
  sl9.addItem("dim7", 7);
  
  
  
  sl10 = cp5.addDropdownList("Ctype10")
                 .setPosition(773, 35) 
                 .setSize(50, 150) 
                 .setItemHeight(30)
                 .setBackgroundColor(color(37,233,237))
                 .setBarHeight(40)
                 .setOpen(false) 
                 .setValue(3.0);
 
  sl10.addItem("Maj", 1);
  sl10.addItem("min", 2);
  sl10.addItem("Maj7", 3);
  sl10.addItem("min7", 4);
  sl10.addItem("dom7", 5);
  sl10.addItem("min7b5", 6);
  sl10.addItem("dim7", 7);
  
  
  sl11 = cp5.addDropdownList("Ctype11")
                 .setPosition(840, 35) // Posiziona la dropdown 
                 .setSize(50, 150) //  grandezza della dropdown
                 .setItemHeight(30)
                 .setBackgroundColor(color(37,233,237))
                 .setBarHeight(40)
                 .setOpen(false) 
                 .setValue(4.0);

  sl11.addItem("Maj", 1);
  sl11.addItem("min", 2);
  sl11.addItem("Maj7", 3);
  sl11.addItem("min7", 4);
  sl11.addItem("dom7", 5);
  sl11.addItem("min7b5", 6);
  sl11.addItem("dim7", 7);
  
  
  
  sl12 = cp5.addDropdownList("Ctype12")
                 .setPosition(910, 35) 
                 .setSize(50, 150) 
                 .setItemHeight(30)
                 .setBackgroundColor(color(37,233,237))
                 .setBarHeight(40)
                 .setOpen(false) 
                 .setValue(6.0);
     
  sl12.addItem("Maj", 1);
  sl12.addItem("min", 2);
  sl12.addItem("Maj7", 3);
  sl12.addItem("min7", 4);
  sl12.addItem("dom7", 5);
  sl12.addItem("min7b5", 6);
  sl12.addItem("dim7", 7);
  
  
 
 
 
//----------------------------------------------------------------------------------------------------------------

//Creating the labels for each effect

  pRatep = cp5.addTextlabel("label")
                    .setText("Rate")
                    .setPosition(64,430)
                    .setColorValue(#FFD800)
                    .setFont(createFont("Arial",10))
                    ;
  
  pDepthp = cp5.addTextlabel("label2")
                    .setText("Depth")
                    .setPosition(170,430)
                    .setColorValue(#FFD800)
                    .setFont(createFont("Arial",10))
                    ;
                    
  pCFrequency = cp5.addTextlabel("label3")
                    .setText("Freq.")
                    .setPosition(280,430)
                    .setColorValue(#FFD800)
                    .setFont(createFont("Arial",10))
                    ;  
                    
  pFeedbackp = cp5.addTextlabel("label4")
                    .setText("Feedback")
                    .setPosition(375,430)
                    .setColorValue(#FFD800)
                    .setFont(createFont("Arial",10))
                    ; 
                    
  pMixp = cp5.addTextlabel("label5")
                    .setText("Mix")
                    .setPosition(498,430)
                    .setColorValue(#FFD800)
                    .setFont(createFont("Arial",10))
                    ;                        
  
  cRate = cp5.addTextlabel("label6")
                    .setText("Rate")
                    .setPosition(64,560)
                    .setColorValue(#FFD800)
                    .setFont(createFont("Arial",10))
                    ;
  
  cDepth = cp5.addTextlabel("label7")
                    .setText("Depth")
                    .setPosition(170,560)
                    .setColorValue(#FFD800)
                    .setFont(createFont("Arial",10))
                    ;
                    
  cCDelay = cp5.addTextlabel("label8")
                    .setText("Delay")
                    .setPosition(281,560)
                    .setColorValue(#FFD800)
                    .setFont(createFont("Arial",10))
                    ;  
                    
  cFeedback = cp5.addTextlabel("label9")
                    .setText("Feedback")
                    .setPosition(378,560)
                    .setColorValue(#FFD800)
                    .setFont(createFont("Arial",10))
                    ; 
                    
  cMix = cp5.addTextlabel("label10")
                    .setText("Mix")
                    .setPosition(498,560)
                    .setColorValue(#FFD800)
                    .setFont(createFont("Arial",10))
                    ;  
                    
  cThreshold = cp5.addTextlabel("label11")
                    .setText("Threshold")
                    .setPosition(755,450)
                    .setColorValue(#FFD800)
                    .setFont(createFont("Arial",10))
                    ;
                    
  cRatio = cp5.addTextlabel("label12")
                    .setText("Ratio")
                    .setPosition(922,450)
                    .setColorValue(#FFD800)
                    .setFont(createFont("Arial",10))
                    ;  
                    
  cAttack = cp5.addTextlabel("label13")
                    .setText("Attack")
                    .setPosition(767,550)
                    .setColorValue(#FFD800)
                    .setFont(createFont("Arial",10))
                    ; 
                    
  cRelease = cp5.addTextlabel("label14")
                    .setText("Release")
                    .setPosition(921,550)
                    .setColorValue(#FFD800)
                    .setFont(createFont("Arial",10))
                    ;    
                    
  pPan = cp5.addTextlabel("label15")
                    .setText("Pan")
                    .setPosition(622,570)
                    .setColorValue(#FFBF00)
                    .setFont(createFont("Arial",10))
                    ;                         
}



public void draw(){
  
  //setting the background color to white
  background(255);
  
  //setting the position of images
  image(img,20,20);
  image(logo,583,385);
 
 
  
}


//----------------------------------------------------------------------------------------------------------

//calling the G4p library's function in order to add UI elements
public void customGUI(){

}

//----------------------------------------------------------------------------------------------------------
//
//defining the comunication part by creating and sending OSC messages
/*
  
  in this case we decide to send only two messages to manage at the same time every droplist, 
  beacuse in this way when one chord is selected and set the value of one key on the MIDI keybord,
  all the other keys are setted to a null value, so you don't slip into a confusionary setting, but
  when you start to personalizing your set up, you only play the chords you want. 
  
*/


void controlEvent(ControlEvent event){

  
 //Messages related to the selction of the chords 
  OscMessage Chords = new OscMessage("/chords");
  Chords.add(dl1.getValue());                        //getting the value of the selected item from the droplists and adding it to the message
  Chords.add(dl2.getValue());
  Chords.add(dl3.getValue());
  Chords.add(dl4.getValue());
  Chords.add(dl5.getValue());
  Chords.add(dl6.getValue());
  Chords.add(dl7.getValue());
  Chords.add(dl8.getValue());
  Chords.add(dl9.getValue());
  Chords.add(dl10.getValue());
  Chords.add(dl11.getValue());
  Chords.add(dl12.getValue());
  
  oscP5.send(Chords, myRemoteLocation);              //sending the message to the addres
  Chords.print();                                    //printing the message sent on the post window
  
  //---------------------------------
  //message related to the chord type
  OscMessage Type = new OscMessage("/type");
  Type.add(sl1.getValue());                          //getting the value of the selected item from the droplists and adding it to the message
  Type.add(sl2.getValue());
  Type.add(sl3.getValue());
  Type.add(sl4.getValue());
  Type.add(sl5.getValue());
  Type.add(sl6.getValue());
  Type.add(sl7.getValue());
  Type.add(sl8.getValue());
  Type.add(sl9.getValue());
  Type.add(sl10.getValue());
  Type.add(sl11.getValue());
  Type.add(sl12.getValue());
  
  oscP5.send(Type, myRemoteLocation);                //sending the message to the addres
  Type.print();                                      //printing the message sent on the post window
  
 
}