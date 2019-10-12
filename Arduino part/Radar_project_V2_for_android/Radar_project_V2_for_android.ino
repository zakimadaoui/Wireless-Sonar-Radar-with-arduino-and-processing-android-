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



#include <Servo.h>
//===================== Pins ========================

int servoPin  = 7;
int buzzerPin = 8; 
int trigger   = 4; 
int echo      = 5; 

//=================== Variables =====================

Servo myServo     ;
int Direction  =1 ;
int angle      =1 ;
int distance  = 35  ;

boolean Start = true ;

//===================== Setup =======================
void setup() {
  
  Serial.begin(9600);
 
  myServo.attach(servoPin);
  pinMode(buzzerPin,OUTPUT);
  pinMode(trigger,OUTPUT);
  pinMode(echo,INPUT);

  pinMode(2,INPUT);

  //interrupt
 // attachInterrupt(0,buttonPressed,CHANGE);


//--------say Hello----------
    Serial.println(angle);
    Serial.println(distance);
}

//=================== Main Loop =====================

void loop() {

 // Serial.begin(9600);
  buttonPressed();//pause or continue to whole process
  if(Serial.available()>0 && Start){
  
  Serial.end();
  Serial.begin(9600);

//------------- Turn around at 180 or 0 -------------

  if  (angle == 180 || angle == 0){
    Direction = -Direction ;
  }

//---------------- Ckecking the area ----------------
 
  digitalWrite(trigger, LOW); 
  delayMicroseconds(2);
  digitalWrite(trigger, HIGH);
  delayMicroseconds(10);
  digitalWrite(trigger, LOW);
   
  // distance in centimeters
  distance = (int) pulseIn(echo, HIGH) / 58; 
 



  if(distance > 50 ){distance = 255 ;}
  

//----------- Moving the UltraSound(radar)-----------

  myServo.write(angle);

//---------- Sending Data to Processing ---------

  Serial.write(angle);
  Serial.write(distance);

//--------------- Make buzzing sound ----------------

  if(distance < 40 ){tone(buzzerPin,277);}
  else {noTone(buzzerPin);}
//  
//---------- Increment/Decrement the angle-----------
  angle = angle + Direction ;
//---------------------------------------------------
 

  }
 
}


void buttonPressed(){
  if(digitalRead(2)== HIGH){
  Start = !Start;

  delay(500);}
}
