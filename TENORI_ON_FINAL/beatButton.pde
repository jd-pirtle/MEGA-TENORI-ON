
class beatButton {    

  float x;   
  float y;   
  float w; 
  float h;  
  color beatCol = color(70);  
  color hColor = 200;
  boolean over = false;
  int colorTimer = 0;

  beatButton(float tempX, float tempY, float tempW, float tempH) {    
    x = tempX;   
    y = tempY;   
    w = tempW; 
    h = tempH;
  }    


  void click(float mx, float my) {
    if (mx > x-w/2 && mx < x + w/2 && my > y-h/2 && my < y + h/2) {
      over = true;
    } 
    else {
      over = false;
    }
  }

  void display() {

    if (colorTimer > 0) {
      colorTimer++;
      if (colorTimer < 10) {
        beatCol = color(219, 162, 2);
      }
      else {
        beatCol = color(70);
        colorTimer = 0;
      }
    }
    strokeWeight(2);
    stroke(hColor);
    fill(beatCol);
    rect(x, y, w, h);
  }


  void more() {
    if (over == true) {
      bpm++;
      colorTimer = 1;
    }
  }

  void less() {
    if (over == true) {
      bpm--;
      colorTimer = 1;
    }
  }
}

