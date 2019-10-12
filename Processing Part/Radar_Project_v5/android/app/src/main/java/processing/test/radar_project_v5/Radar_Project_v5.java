package processing.test.radar_project_v5;

import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import android.content.Intent; 
import android.os.Bundle; 
import ketai.net.bluetooth.*; 
import ketai.ui.*; 
import ketai.net.*; 
import oscP5.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Radar_Project_v5 extends PApplet {

//<>









byte[] z  ={'Z'} ;
KetaiBluetooth bt;
KetaiList klist;
String BTdevice ;



//----------------- Variables/Objects for Green lines ---------------------

greenLine greenlines ; 
boolean drawState = false ;

//------------------ Variables/Objects for red lines ----------------------

redLine redlines ;
int distance  ; // recieved distance

//-------------- Variables/Objects for serial communication ---------------


boolean init =false;
int bytesCount = 0;
byte serialArray [] = new byte[2];
int angle = 1; 

//-------------------------------------------------------------------------

Radar radar;
Text  text;

//****************************************************************
// The following code is required to enable bluetooth at startup.
//****************************************************************

public void onCreate(Bundle savedInstanceState) {
  super.onCreate(savedInstanceState);
  bt = new KetaiBluetooth(this);
}

public void onActivityResult(int requestCode, int resultCode, Intent data) {
  bt.onActivityResult(requestCode, resultCode, data);
}


//*****************************************************************




//================================ Setup ==================================
public void setup() {  

  //Basic setup
  orientation(LANDSCAPE);
  //size(displayWidth, displayHeight);
  

  // initializing the lines/objects

  greenlines = new greenLine();
  redlines = new redLine();
  radar = new Radar();
  text = new Text();

  // Setting up the serial comunication

 
 //start listening for BT connections
  bt.start();
  
 // finds paired device and connects to it
 klist = new KetaiList(this, bt.getPairedDeviceNames());

}

//======================= Drawing Processed data ==========================

public void draw() {

  if (drawState) {

    // Simulating the transition and the motion blur
    noStroke();
    fill(0, 4); 
    rect(0, 0, width, height); 

    //---------------------------------------------------------------------
    radar.Draw();  // Drawing the radar layout 
    greenlines.Draw(angle);   // Drawing the green lines 
    redlines.Draw(angle, distance);   // Draw the Scanner lines
    text.Draw() ;  // Drawing the text
    //---------------------------------------------------------------------

    bt.writeToDeviceName(BTdevice, z); // request for new data 
    drawState = false ; // stop the draw loop untill new data is recieved
   
  }
}



//=================== Event for BT devices selection =====================


public void onKetaiListSelection(KetaiList klist)
{
  String selection = klist.getSelection();
  bt.connectToDeviceByName(selection);
  BTdevice = selection ;
  //dispose of list for now
  klist = null;
}

//=========================== Receiving data ==============================

  //Call back method to manage data received
public void onBluetoothDataEvent(String who, byte[] Data){

  serialArray[bytesCount] = Data[0] ;
  bytesCount++;

  //----------------------- Saving Angle/Distance -------------------------
    
if (bytesCount == 2) {
    
      angle = PApplet.parseInt(serialArray[0]);
      distance = PApplet.parseInt(serialArray[1]);
      drawState = true ;
      bytesCount = 0; // resetting the byteCount counter
      
   }
}
class greenLine{

  public void Draw(int Angle){
    
    pushMatrix();
    strokeWeight(9);
    stroke(30,250,60);
    translate(displayWidth/2,displayHeight-80); // moves the starting coordinats to new location
    line(0,0,(width/2)*cos(radians(Angle)),-(width/2)*sin(radians(Angle))); // draws the line according to the angle
    popMatrix();
  }
}

class redLine{
float pixsDistance;

  public void Draw(int Angle,int Distance){
    
     pushMatrix();
  translate(displayWidth/2,displayHeight-80); // moves the starting coordinats to new location
  strokeWeight(9);
  stroke(255,10,10); // red color
  pixsDistance = map(Distance,0,50,0,width/2-100); // converts the distance from the sensor from cm to pixels
  // limiting the range to 50 cms
  if(distance<50){
    // draws the object according to the angle and the distance
  line(pixsDistance*cos(radians(Angle)),-pixsDistance*sin(radians(Angle))
  ,(pixsDistance+100)*cos(radians(Angle)),-(pixsDistance+100)*sin(radians(Angle)));
  }
  popMatrix();
  }
}
class Radar {
public void Draw() {
 
  pushMatrix();
  translate(displayWidth/2,displayHeight-80); // moves the starting coordinats to new location
  noFill();
  strokeWeight(2);
  stroke(98,245,31);
  // draws the arc lines
  arc(0,0,2*map(10,0,50,0,width/2-100),2*map(10,0,50,0,width/2-100),PI,TWO_PI);
  arc(0,0,2*map(20,0,50,0,width/2-100),2*map(20,0,50,0,width/2-100),PI,TWO_PI);
  arc(0,0,2*map(30,0,50,0,width/2-100),2*map(30,0,50,0,width/2-100),PI,TWO_PI);
  arc(0,0,2*map(40,0,50,0,width/2-100),2*map(40,0,50,0,width/2-100),PI,TWO_PI);
  arc(0,0,2*map(50,0,50,0,width/2-100),2*map(50,0,50,0,width/2-100),PI,TWO_PI);
  arc(0,0,2*map(60,0,50,0,width/2-100),2*map(60,0,50,0,width/2-100),PI,TWO_PI);
  
  
  // draws the angle lines
  line(-(width/2+50),0,(width/2+50),0);
  line(0,0,-(width/2+100)*cos(radians(30)),-(width/2+100)*sin(radians(30)));
  line(0,0,-(width/2+100)*cos(radians(60)),-(width/2+100)*sin(radians(60)));
  line(0,0,-(width/2+100)*cos(radians(90)),-(width/2+100)*sin(radians(90)));
  line(0,0,-(width/2+100)*cos(radians(120)),-(width/2+100)*sin(radians(120)));
  line(0,0,-(width/2+100)*cos(radians(150)),-(width/2+100)*sin(radians(150)));
  line(-(width/2+50)*cos(radians(30)),0,(width/2+50),0);
  popMatrix();
}
}

class Text{
public void Draw() { // draws the texts on the screen
  
 
  fill(98,245,31);
  textSize(20);
  text("10cm",width/2,height-80-map(10,0,50,0,width/2-100));
  text("20cm",width/2,height-80-map(20,0,50,0,width/2-100));
  text("30cm",width/2,height-80-map(30,0,50,0,width/2-100));
  text("40cm",width/2,height-80-map(40,0,50,0,width/2-100));
  text("50cm",width/2,height-80-map(50,0,50,0,width/2-100));
  text("60cm",width/2,height-80-map(60,0,50,0,width/2-100));
  
}}
}
