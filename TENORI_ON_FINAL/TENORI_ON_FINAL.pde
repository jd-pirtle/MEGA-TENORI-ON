//***********************************************************************
//  MEGA TENORI-ON
// 
//  JD Pirtle, 2012
//  Built for the Cyber-Commons wall at the Electronic Visualization Lab
//  at the Uniersity of Illinois Chicago
//
//  Uses Omicron API by Arthur Nishimoto 
//  (sites.google.com/site/arthurnishimoto)
//  and oscP5 by Andreas Schlegel (sojamo.de/oscp5)
//
//************************************************************************

import oscP5.*;
import netP5.*;
import processing.net.*;
import omicronAPI.*;


OmicronAPI omicronManager;
MyTouchListener touchListener;

// Link to this Processing applet - used for touchDown() callback example
PApplet applet;

// Override of PApplet init() which is called before setup()
public void init() {
  super.init();

  // Creates the OmicronAPI object. This is placed in init() since we want to use fullscreen
  omicronManager = new OmicronAPI(this);

  // Removes the title bar for full screen mode (present mode will not work on Cyber-commons wall)
  omicronManager.setFullscreen(true);
}

int space;
int sqSize;
float pace;
int cols = 47;
int rows = 11;
int preCol = -1;
int timer = 0;
boolean playFlag = false;
int curCol = 0;
int bpm = 10;
color paceColor = color(180, 18, 0);
int toneVal = 1;
int toneInc = 0;
boolean resetVal = false;
float amp = 0.5;
PImage topBar;
int toneSwitch = 1;
float pos = 0.0;
PFont font;

//init OSC stuff///
OscP5 oscP5;
int sendToPort;
int receiveAtPort;
String host;
String oscP5event;
///////////////////

//create 2d array to make grid of buttons
Button [][] notes = new Button [cols] [rows];

//create tone button
Button tone;

//create tempo buttons
beatButton increase;
beatButton decrease;

//reset array button
Button reset;

//switch instruments button
Button toneChange;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

void setup() {
  size(screenWidth, screenHeight, P3D);
  smooth();
  noStroke();
  initOsc();
  rectMode(CENTER);
  textAlign(CENTER);

  //top bar image
  topBar = loadImage("bar2.png");

  space = width/51;
  sqSize = width/78;
  pace = width/68.3;

  // Make the connection to the tracker machine
  omicronManager.ConnectToTracker(7001, 7340, "131.193.77.104");

  // Create a listener to get events
  touchListener = new MyTouchListener();

  // Register listener with OmicronAPI
  omicronManager.setTouchListener(touchListener);

  // Sets applet to this sketch
  applet = this;

  //for writing stuff...
  font = loadFont("LuxiSans-72.vlw"); 

  //intialize 2d array of buttons
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      notes[i][j] = new Button(i*space+sqSize, j*space+(sqSize*5), sqSize, sqSize);
    }
  }


  //switch instruments button
  toneChange = new Button(width-(width/20), height-920, width/51, width/100);

  //reset button
  reset = new Button(width-(width/20), height-770, width/51, width/100);

  //tone button
  tone = new Button(width-(width/20), height-620, width/51, width/100);

  //increase or decrease BPM
  increase = new beatButton(width-(width/20), height-470, width/51, width/100);
  decrease = new beatButton(width-(width/20), height-320, width/51, width/100);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

void draw() {
  background(0);
  // For event and fullscreen processing, this must be called in draw()
  omicronManager.process();

  //draw top style bar
  noStroke();
  fill(200, 125);
  rect(width/2, width/204.8, width, width/341.3);
  //draw top thin bar
  fill(0, 125);
  rect(width/2, width/204.8, width, 1);
  //draw lower top style bar
  fill(200, 125);
  rect(width/2, width/21.3, width, width/341.3);
  //draw lower top thin bar
  fill(0, 125);
  rect(width/2, width/21.3, width, 1);
  //draw bottom style bar
  fill(200, 125);
  rect(width/2, height-(width/204.8), width, width/341.3);
  //draw bottom thin bar
  fill(0, 125);
  rect(width/2, height-(width/204.8), width, 1);

  //place top bar image
  image(topBar, 20, 60);


  //////tempo button stuff////////////////////////////////

  //increase BPM button
  increase.display();
  //decrease BPM button
  decrease.display();

  textFont(font, width/200);
  fill(255);
  text("faster", width-(width/40), height-460);

  textFont(font, width/200);
  fill(255);
  text("slower", width-(width/40), height-310);



  //////tone stuff/////////////////////////////////////////

  tone.displayRect();

  textFont(font, width/200);
  fill(255);
  text("tone", width-(width/40), height-610);

  //////reset stuff/////////////////////////////////////////

  reset.displayRect();

  textFont(font, width/200);
  fill(255);
  text("reset", width-(width/40), height-760);


  //////switch instruments stuff/////////////////////////////

  toneChange.displayRect();

  textFont(font, width/200);
  fill(255);
  text("inst", width-(width/40), height-910);

  ///////////////////////////////////////////////////////////

  //increment the global timer
  timer++;

  //increment curCol
  if (timer%bpm==0) {
    playFlag = true;
    if ( curCol == cols-1 ) {
      curCol = 0;
    }
    else curCol++;
  }
  else playFlag = false;

  //display grid of buttons
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      notes[i][j].display();
    }
  }

  //map column number to send speaker position argument
  pos = map(curCol, 0, 47, 0.0, 2.0);
  pos = constrain(pos, 0.0, 2.0)*0.8;

///////////////////////////////////////////////////////////

  //play sounds by row and column
  if (playFlag)
  {
    //row 
    for (int j = 0; j < rows; j++) 
    {
      //first column
      float freq = 0;
      int bufNum = 0;
      switch( j )
      {
      case 0: 
        freq = 1046.502; 
        bufNum = 0;
        break;
      case 1: 
        freq = 880.000;
        bufNum = 1;  
        break;
      case 2: 
        freq = 783.991;
        bufNum = 2;  
        break;
      case 3: 
        freq = 659.255; 
        bufNum = 3;
        break;
      case 4: 
        freq = 587.330;
        bufNum = 4; 
        break;
      case 5: 
        freq = 523.251; 
        bufNum = 5;
        break;
      case 6: 
        freq = 440.000;
        bufNum = 6;
        break;
      case 7: 
        freq = 391.995;
        bufNum = 7; 
        break;
      case 8: 
        freq = 329.628;
        bufNum = 8;
        break;
      case 9:
        freq = 293.665;
        bufNum = 9;
        break;
      case 10:
        freq = 261.626;
        bufNum = 10; 
        break;
      }
      notes[curCol][j].sound(freq, bufNum, toneVal, amp, pos);
    }
  }

  //change toneval
  switch(toneInc)
  {
  case 0:
    toneVal = 5;
    amp = 0.025;
    break;
  case 1:
    toneVal = 10;
    amp = 0.05;
    break;
  case 2:
    toneVal = 100;
    amp = 0.075;
    break;
  }
}

void touchDown(int ID, float xPos, float yPos, float xWidth, float yWidth) {
  //toggle on-off
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      notes[i][j].click(xPos, yPos);
    }
  } 

  reset.chkOver(xPos, yPos);
  reset.setReset();

  //reset all notes to "off"
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      notes[i][j].reset();
    }
  }

  increase.click(xPos, yPos);
  decrease.click(xPos, yPos);
  tone.chkOver(xPos, yPos);
  toneChange.chkOver(xPos, yPos);

  tone.toneCh();
  toneChange.toneInc();
  //mousePressed decreases or increases
  increase.less();
  decrease.more();

  println(toneSwitch);
}

void touchMove(int ID, float xPos, float yPos, float xWidth, float yWidth) {
}

void touchUp(int ID, float xPos, float yPos, float xWidth, float yWidth) {
}

