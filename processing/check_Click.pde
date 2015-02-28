/////////////////////////////////////////////////////////////////////////////////////////////////////////
  //This class checks to see if the mouse has been clicked inside the squares where the tea/coffee/noodle
  //button images are rendered
/////////////////////////////////////////////////////////////////////////////////////////////////////////

class Checkclick {
  boolean tea() {
    if (mouseX>50 && mouseX<170 && mouseY>120 && mouseY<240) { // checks the teabag button
      if (mousePressed && mousePress) {
        return(true);
      }
    } 
    return(false);
  }

  boolean coffee() {
    if (mouseX>50 && mouseX<170 && mouseY>300 && mouseY<420) { // checks the coffee button
      if (mousePressed && mousePress) {
        return(true);
      }
    } 
    return(false);
  }

  boolean noodle() {
    if (mouseX>50 && mouseX<170 && mouseY>500 && mouseY<620) { // checks the noodle button
      if (mousePressed && mousePress) {
        return(true);
      }
    } 
    return(false);
  }

  boolean off() {
    if (mouseX >50 && mouseX <110 && mouseY > 660 && mouseY < 720) { // checks the off button
      if (mousePressed && mousePress) {
        return(true);
      }
    } 
    return(false);
  }
}
