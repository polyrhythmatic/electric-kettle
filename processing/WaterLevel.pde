/////////////////////////////////////////////////////////////////////////////////////////////////////////
  //This code has been borrowed and adapted from Dan Shiffman's "The Nature of Code"
/////////////////////////////////////////////////////////////////////////////////////////////////////////

class WaterLevel {  
  void display(float tempy) {
    beginShape(); 

    float xoff = 0;       // Option #1: 2D Noise
    // float xoff = yoff; // Option #2: 1D Noise
    float yLevel = tempy;
    // Iterate over horizontal pixels
    for (float x = 0; x <= width; x += 10) { // Calculate a y value according to noise, map to 
      float y = map(noise(xoff, yoff), 0, 1, yLevel-100, yLevel); // Option #1: 2D Noise

      // float y = map(noise(xoff), 0, 1, 200,300);    // Option #2: 1D Noise

      // Set the vertex
      vertex(x, y); 
      // Increment x dimension for noise
      xoff += 0.05;
    }
    // increment y dimension for noise
    yoff += 0.01;
    vertex(width, 0);
    vertex(0, 0);
    endShape(CLOSE);
  }
}
