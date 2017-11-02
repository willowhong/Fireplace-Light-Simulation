import processing.serial.*;
import cc.arduino.*;
import oscP5.*;
import netP5.*;
import controlP5.*;

OscP5 oscP5;
PImage room;
int col;
int roomWidth = 30;
int roomLength = 100;
int seglength = 48;  //light segment length
int gaplength = 8;  //gap between 2 light fixtures
float initXpos =400.0; //initial x coordinate of squares
float initYpos =34.0; //initial y coordinate of squares
//Arduino variables
Arduino arduino; 
int inputPin = 0;
//slider variables
ControlP5 cp5;
int r1; 
int r2; 
int r3;
int r4; 
int g1; 
int g2; 
int g3;
int g4; 
int b1; 
int b2; 
int b3;
int b4;
//noise variables
float aoff = 0.0;
float boff = 0.0;
//lightmanager settings
boolean sending;
boolean bDrawLights;
LightManager lightManager;
void setup() {
  //layout initiation, 1 pixel = 1 inch (technically) 
  room = loadImage("roomimage.png"); 
  size(1200, 360);
  frameRate(30);
  background(0);
  oscP5 = new OscP5(this,57600);
  
  //Arduino initiation
  println(Arduino.list());
  arduino = new Arduino(this, "/dev/cu.usbmodem1441", 57600);
  arduino.pinMode(inputPin, Arduino.INPUT);
  //lightmanager initiation
  lightManager = new LightManager();
  lightManager.init("127.0.0.1", 12345);
  
  //color slider initiation
  cp5 = new ControlP5(this);
  cp5.addSlider("r1")
     .setPosition(100, 150)
     .setSize(10, 150)
     .setRange(0, 255)
     .setValue(217)
     .setColorCaptionLabel(color(255,255,255));
     
  cp5.addSlider("g1")
     .setPosition(150, 150)
     .setSize(10, 150)
     .setRange(0, 255)
     .setValue(51)
     .setColorCaptionLabel(color(255,255,255));
     
  cp5.addSlider("b1")
     .setPosition(200, 150)
     .setSize(10, 150)
     .setRange(0, 255)
     .setValue(41)
     .setColorCaptionLabel(color(255,255,255));
     
  cp5.addSlider("r2")
     .setPosition(400, 150)
     .setSize(10, 150)
     .setRange(0, 255)
     .setValue(242)
     .setColorCaptionLabel(color(255,255,255));
     
  cp5.addSlider("g2")
     .setPosition(450, 150)
     .setSize(10, 150)
     .setRange(0, 255)
     .setValue(113)
     .setColorCaptionLabel(color(255,255,255));
     
  cp5.addSlider("b2")
     .setPosition(500, 150)
     .setSize(10, 150)
     .setRange(0, 255)
     .setValue(39)
     .setColorCaptionLabel(color(255,255,255));
     
  cp5.addSlider("r3")
     .setPosition(700, 150)
     .setSize(10, 150)
     .setRange(0, 255)
     .setValue(242)
     .setColorCaptionLabel(color(255,255,255));
     
  cp5.addSlider("g3")
     .setPosition(750, 150)
     .setSize(10, 150)
     .setRange(0, 255)
     .setValue(166)
     .setColorCaptionLabel(color(255,255,255));
     
  cp5.addSlider("b3")
     .setPosition(800, 150)
     .setSize(10, 150)
     .setRange(0, 255)
     .setValue(73)
     .setColorCaptionLabel(color(255,255,255));
     
  cp5.addSlider("r4")
     .setPosition(1000, 150)
     .setSize(10, 150)
     .setRange(0, 255)
     .setValue(242)
     .setColorCaptionLabel(color(255,255,255));
     
  cp5.addSlider("g4")
     .setPosition(1050, 150)
     .setSize(10, 150)
     .setRange(0, 255)
     .setValue(212)
     .setColorCaptionLabel(color(255,255,255));
     
  cp5.addSlider("b4")
     .setPosition(1100, 150)
     .setSize(10, 150)
     .setRange(0, 255)
     .setValue(121)
     .setColorCaptionLabel(color(255,255,255));
}
void draw() {
  background(0);
  colorMode(RGB);
  ellipseMode(CENTER);
  
  // Arduino reading & mapping 
  int pinVal = arduino.analogRead(inputPin);
  println(pinVal);
  float input = (int)map(pinVal, 0, 1023, 0, 10);
  
  //noise creation for both square color and position
  aoff = aoff + 1;
  float aoffcol = noise(aoff) * 200;
  float aoffpos = noise(aoff) * 10;
    
  boff = boff + 2;
  float boffcol = noise(boff) * 200;
  float boffpos = noise(boff) * 10;
  
  pushMatrix();
  //1st square
  pushMatrix();  
  fill(aoffcol+r1, g1, b1);
  stroke(0);
  rect(initXpos, initYpos+aoffpos, 48, 48);
  popMatrix();
  
  //2nd square
  fill(boffcol+r2, g2, b2);
  stroke(0);
  rect(initXpos+seglength, (initYpos - input) +boffpos, 48, 48);
  
  //3rd square
  fill(aoffcol+r3, g3, b3);
  stroke(0);
  rect(initXpos+seglength*2, (initYpos - 2* input) +aoffpos, 48, 48);
  
  //4th square
  fill(boffcol+r4, g4, b4);
  stroke(0);
  rect(initXpos+seglength*3, (initYpos - 3* input) +boffpos, 48, 48);
  
  //5th square
  fill(boffcol+r4, g4, b4);
  stroke(0);
  rect(initXpos+seglength*4+gaplength, (initYpos - 3* input) +boffpos, 48, 48);
  
  //6th square
  fill(aoffcol+r3, g3, b3);
  stroke(0);
  rect(initXpos+seglength*5+gaplength, (initYpos - 2* input) +aoffpos, 48, 48);
  
  //7th square
  fill(boffcol+r2, g2, b2);
  stroke(0);
  rect(initXpos+seglength*6+gaplength, (initYpos - input) +boffpos, 48, 48);
  
  //8th square
  fill(aoffcol+r1, g1, b1);
  stroke(0);
  rect(initXpos+seglength*7+gaplength, initYpos+aoffpos, 48, 48);
   
  popMatrix();
  
  if (sending){
    lightManager.sendMessages();
    lightManager.display();
  }
}
void keyPressed() {
  if (key == 's') {
    sending = !sending;
  }
  lightManager.changeBufferSize(10);
}

void oscEvent(OscMessage theOscMessage) {
  if(theOscMessage.checkAddrPattern("/lights") == true){
    draw();
  }
}