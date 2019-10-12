/*
 * Copyright 2019 Zakaria Madaoui. All rights reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * http://www.apache.org/licenses/LICENSE-2.0
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
 
import android.content.Intent;
import android.os.Bundle;

import ketai.net.bluetooth.*;
import ketai.ui.*;
import ketai.net.*;

import oscP5.*;

byte[] z  ={'Z'} ;//any random byte or character
KetaiBluetooth bt;
KetaiList klist;
String BTdevice ;

//private long lastDrawTime = millis()*1000;



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

void onCreate(Bundle savedInstanceState) {
  super.onCreate(savedInstanceState);
  bt = new KetaiBluetooth(this);
}

void onActivityResult(int requestCode, int resultCode, Intent data) {
  bt.onActivityResult(requestCode, resultCode, data);
}


//*****************************************************************




//================================ Setup ==================================
void setup() {  

  //Basic setup
  orientation(LANDSCAPE);
  frameRate(30);
  

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

void draw() {

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

    bt.writeToDeviceName(BTdevice, z); // signal to request for new data 
    
    drawState = false ; // stop the draw loop untill new data is recieved
   
   
  }

}



//=================== Event for BT devices selection =====================


void onKetaiListSelection(KetaiList klist)
{
  String selection = klist.getSelection();
  bt.connectToDeviceByName(selection);
  BTdevice = selection ;
  //dispose of list for now
  klist = null;
}

//=========================== Receiving data ==============================

  //Call back method to manage data received
void onBluetoothDataEvent(String who, byte[] Data){

  if(Data.length == 1){
  
  serialArray[bytesCount] = Data[0] ;
  bytesCount++;
  
  if (bytesCount == 2) {
    
      angle = int(serialArray[0]);
      distance = int(serialArray[1]);
      drawState = true ;
      bytesCount = 0; 
      
   }
 }
 else {
 
      angle = int(Data[0]);
      distance = int(Data[1]);
      drawState = true ;
      bytesCount = 0;
 }
 
}
