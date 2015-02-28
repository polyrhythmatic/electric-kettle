#include <Servo.h>
char incomingByte = 0;
long cycleNum = 0;

Servo myservo;


void setup(){

  myservo.write(80);//servo setup
  pinMode(13, OUTPUT);
  myservo.attach(13);

  Serial.begin(9600);
}

void loop(){
  cycleNum ++;

  if (Serial.available() > 0){
    incomingByte = Serial.read();

    if (incomingByte == 2){
      kettleOn();
    }
    if (incomingByte == 3){
      kettleOff();
    }
    if(incomingByte == 4){
    temperatureCheck();
    Serial.print(",");
    weightCheck();
    Serial.print('\n');
  }
    else{
      kettleNeutral();
    }

  }
  
}

void temperatureCheck(){


  int thermoPin = A0;//variables for the temperature sensor reading
  int thermoVal = 0;
  float vTemp = 0;
  float cTemp = 0;  
  pinMode(thermoPin, INPUT);//sets the temp sensor pin to input  
  thermoVal = analogRead(thermoPin);
  delay(1);
  vTemp = thermoVal*4.88;
  cTemp = (vTemp-500)/10;
  Serial.print(cTemp);
  //  Serial.print(thermoVal);
  delay(1);

}

void weightCheck(){
  int weightSensor = analogRead(A1);
  int weight = map(weightSensor, 356, 754, 0, 1000);
  Serial.print(weight);
  delay(1);

}


void kettleOn(){
  myservo.write(150);
  delay(500);
  myservo.write(80);
  incomingByte = 0;

}

void kettleOff(){
  myservo.write(40);
  delay(250);
  myservo.write(80);
  incomingByte = 0;
}

void kettleNeutral(){
  myservo.write(80);

}













