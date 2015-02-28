/////////////////////////////////////////////////////////////////////////////////////////////////////////
  //A simple class to handle turning the kettle on and off - would facilitate further expansion of 
  //the kettle on/off function 
/////////////////////////////////////////////////////////////////////////////////////////////////////////
class Kettle {

  void kettleOn() {

    myPort.write(2);
    mousePress = false;
    println("on");
  }

  void kettleOff() {
    myPort.write(3);
    mousePress = false;
    println("off");
    teaOn = noodleOn = coffeeOn = coffeeWaterIsReady = teaWaterIsReady = noodleWaterIsReady = false;
  }
}
