class Radar {
void Draw() {
 
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
void Draw() { // draws the texts on the screen
  
 
  fill(98,245,31);
  textSize(20);
  text("10cm",width/2,height-80-map(10,0,50,0,width/2-100));
  text("20cm",width/2,height-80-map(20,0,50,0,width/2-100));
  text("30cm",width/2,height-80-map(30,0,50,0,width/2-100));
  text("40cm",width/2,height-80-map(40,0,50,0,width/2-100));
  text("50cm",width/2,height-80-map(50,0,50,0,width/2-100));
  text("60cm",width/2,height-80-map(60,0,50,0,width/2-100));
  
}}
