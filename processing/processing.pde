import processing.serial.*;
Serial myPort;
Boolean mousePress = true;

float yoff=0; // variables for waterlevel
//float ylevel=400;

ArrayList<Bubbles> bubbles; //list of bubble objects

int waterLevelAvg = 0;
int[] waterLevel = new int[10];
int waterWeight = 0;

float cTemp = 0;
int[] cTempAvg_ = new int[10];
int cTempAvg = 0;

WaterLevel wl; //defining waterlevel object
Checkclick checkClick; //defining checkclick object
Kettle kettle; //kettle object

int timeCounter = 0;
int timeCounterTea = 0;
int timeCounterCoffee = 0;
int timeCounterNoodle = 0;

boolean teaOn = false;
boolean coffeeOn = false;
boolean noodleOn = false;
boolean pickedUp = false;
boolean teaWaterIsReady = false;
boolean coffeeWaterIsReady = false;
boolean noodleWaterIsReady = false;

PImage teabag;
PImage coffee;
PImage noodle;
PImage levels;
PImage off;
PImage stop;

void setup() {
  size(1080, 720);
  wl = new WaterLevel(); // new waterlevel named wl
  checkClick = new Checkclick();
  kettle = new Kettle();

  bubbles = new ArrayList<Bubbles>(); //setup the bubble array list

  // println(Serial.list());
  String portName = "/dev/tty.usbmodem1411";
  myPort = new Serial(this, portName, 9600); // starting new serial communication

  for (int i = 0; i<=9; i++) {
    waterLevel[i] = 0;
    cTempAvg_[i] = 0;
  }
  smooth();
  teabag= loadImage("btn_teabag.png");
  coffee= loadImage("btn_coffee.png");
  noodle= loadImage("btn_noodle.png");
  levels= loadImage("level_num.png");
  off= loadImage("off.png");
  stop= loadImage("stop.png");

  myPort.clear();//clears the serial buffer for proper communication
}

void draw() {
  background(98, 196, 171);
  noStroke();
  myPort.write(4); //handshaking serial data

  if ( frameCount % 4 ==0) { //this introduces new bubbles into the bubble array every 4 frames
    bubbles.add(new Bubbles(random(0, width), random(0, 200)));//random x position and random perlin x value (t)
  }                                                           //using random t means each bubble follows a different random path
  for (int i = 0; i < bubbles.size ()-1; i++) { //this displays and removes bubbles in the array
    bubbles.get(i).display(); 
    if (bubbles.get(i).offScreen()) { //removes bubbles if they go off screen. offscreen() is a boolean in the class
      bubbles.remove(i); //"Bubbles". this is not the best way to remove items from an array but it works well in this case
    }                    //the problem is that items will shift down as "i" is looped through, so they can be skipped
  }                      //however the number of bubbles stabilizes and is not problematic

  fill(77, 54, 80);
  wl.display(waterLevelAvg); //displays the water level - which is actually the purple region

  fill(150);
  
  textAlign(LEFT, BOTTOM);
  textSize(50); 
  text(int(cTempAvg)+"C", 65, 75); //this displays the averaged temperature reading 

  image(levels, 0, 0); //images for the buttons
  image(teabag, 50, 120);
  image(coffee, 50, 300);
  image(noodle, 50, 500);
  image(off, 50, 660);

  /////////////////////////////////////////////////////////////////////////////////////////////////////////
  //Turning on the kettle based on click check and pick up condition
  /////////////////////////////////////////////////////////////////////////////////////////////////////////


  if (checkClick.tea() && pickedUp == false) {//turn kettle on, check to see if picked up
    kettle.kettleOn();
    timeCounter = 0;
    teaOn = true;
  }

  if (checkClick.coffee() && pickedUp == false) {
    kettle.kettleOn();
    timeCounter = 0;
    coffeeOn = true;
  }

  if (checkClick.noodle() && pickedUp == false) {
    kettle.kettleOn();   
    timeCounter = 0;
    noodleOn = true;
  }
  if (checkClick.off() == true) { //turning off the kettle if the off button is pressed
    kettle.kettleOff();
  }
  /////////////////////////////////////////////////////////////////////////////////////////////////////////
  //Checking to see if the water is ready and shutting off the kettle when it is
  /////////////////////////////////////////////////////////////////////////////////////////////////////////

  if (teaOn == true) { //checks to see if water is 85c and turns off
    if (timeCounter > 240) {
      if (cTemp > 80) {
        kettle.kettleOff();
        teaOn = false;
        teaWaterIsReady = true;
      }
    }
  }
  if (coffeeOn == true) { //checks to see if water is 95c and turns off
    if (timeCounter > 240) {
      if (cTemp > 85) {
        kettle.kettleOff();
        coffeeOn = false;
        coffeeWaterIsReady = true;
      }
    }
  }
  if (noodleOn == true) { //check to see if the water is 100c and turns off
    if (timeCounter > 240) {
      if (cTemp > 95) {
        kettle.kettleOff();
        noodleOn = false;
        noodleWaterIsReady = true;
      }
    }
  }

  /////////////////////////////////////////////////////////////////////////////////////////////////////////
  //Checking to se if the kettle is picked up
  /////////////////////////////////////////////////////////////////////////////////////////////////////////


  if (waterWeight < -200 && pickedUp == false) {// this figures out if the weight is below zero
    pickedUp = true;
    if (coffeeOn == true || teaOn == true || noodleOn == true) { // checks to see if it is in boil cycle
      kettle.kettleOff();                         // turns off the kettle if it is picked up
      pickedUp = true;
    }
  }
  if (waterWeight >-200 && pickedUp == true) { //this 
    pickedUp = false;
  }
  if (pickedUp == true) {
    image(stop, 0, 0);
  }

  /////////////////////////////////////////////////////////////////////////////////////////////////////////
  //Notifications to let you know that the kettle is done
  /////////////////////////////////////////////////////////////////////////////////////////////////////////

  if (teaWaterIsReady == true) { //tea water ready notifiction
    if (timeCounterTea < 3600) {
      timeCounterTea++;
      textMode(CENTER);
      textSize(60);
      text("Tea Time!", (width/2) - 120, height/2);
      println(timeCounterTea);
    } else {
      timeCounterTea = 0;
      teaWaterIsReady = false;
    }
  }

  if (coffeeWaterIsReady == true) {
    if (timeCounterCoffee < 3600) {
      timeCounter++;
      textMode(CENTER);
      textSize(60);
      text("Coffee Time!", (width/2)-120, height/2);
    } else {
      timeCounterTea = 0;
      coffeeWaterIsReady = false;
    }
  }

  if (noodleWaterIsReady == true) {
    if (timeCounter < 3600) {
      timeCounter++;
      textMode(CENTER);
      textSize(60);
      text("Noodle Time!", (width/2)-120, height/2);
    } else {
      timeCounterNoodle = 0;
      noodleWaterIsReady = false;
    }

  }
  timeCounter ++;
}

void mouseReleased() {
  mousePress = true; //simple toggle to prevent holding the mouse down from counting as more than one click
  //(continuous vs momentary click)
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////
//Section below is the serial communication with the arduino
/////////////////////////////////////////////////////////////////////////////////////////////////////////
void serialEvent(Serial myPort) { 
  String myString = myPort.readStringUntil('\n');
  if (myString != null) {

    print("myString = ");
    println(myString);
    String myString_ = trim(myString);
    String[] list = split(myString_, ','); 
    cTemp = float(trim(list[0]));
    waterWeight = int(list[1].trim());

    for (int i = 0; i <= 8; i++) {//I used this section to average out the weight and temperature data 
      waterLevel[i] = waterLevel[i+1]; //to reduce the jitter we were seeing 
      cTempAvg_[i] = cTempAvg_[i+1]; //it averages the past ten values
    }
    waterLevel[9] = int(map(waterWeight, 0, 1000, height, height*.125)); //set the 9th value equal to current value
    cTempAvg_[9] = int(cTemp);
    cTempAvg = 0; //reset the avg holders
    waterLevelAvg = 0;
    for (int i = 0; i <= 9; i++) { //add up the 10 values of the array 
      waterLevelAvg = waterLevelAvg + waterLevel[i];
      cTempAvg = cTempAvg + cTempAvg_[i];
      // println("water level avg = "+waterLevelAvg); //troubleshooting print line - serial communication is fickle sometimes
    }                                                  //and doesn't give you feedback!

    waterLevelAvg = waterLevelAvg / 10; //then divide by 10
    cTempAvg = cTempAvg/10;

    // I used the below printouts to make sure the data I was getting was correct
    // println(waterLevel);
    println(cTempAvg_);

    println("Water level avg = " + waterLevelAvg);
    println("cTemp = "+cTemp);
    println("cTempAvg = "+cTempAvg);
    println("waterWeight = "+waterWeight);
    // print('\n');
  }
}
