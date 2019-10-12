class greenLine{

  void Draw(int Angle){
    
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

  void Draw(int Angle,int Distance){
    
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
