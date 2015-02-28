class Bubbles {
  float radius = random(8, 20);//randomizing the initial bubble size

  float xPos;
  float yPos = height;
  float rise = 3;
  float jitter = 0;
  float t;
  
  Bubbles(float tempX, float tempT) {//takes in x seed and perlin noise t begin number 
    xPos = tempX;                   
    t = tempT;
  }
  void display() {
    fill(255, 255, 255, 70);
    ellipse(xPos, yPos, radius, radius);
    yPos -= rise; //rising the bubble
    jitter = noise(t); //jitter is the major movement of the bubble, more predictable/continuous
    xPos += map(jitter, 0, 1, -3, 3);
    xPos += random(-2, 2); //this adds a bit more randomness to the jitter
    t += 0.01;
  }
  boolean offScreen() {
    if (yPos < 0) {
      return true;
    } else {
      return false;
    }
  }
}
