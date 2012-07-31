
// based (copied) on Shiffman's excellent button exercise

class Button {    

  float x;   
  float y;   
  float w; 
  float h;  
  boolean on;
  boolean over = false;
  color bColor = color(70);  
  color hColor = 200;
  int colorTimer = 0;

  Button(float tempX, float tempY, float tempW, float tempH) {    
    x  = tempX;   
    y  = tempY;   
    w  = tempW; 
    h = tempH;    
    on = false;
  }    

  void click(float mx, float my) {
    if (mx > x-w/2 && mx < x + w/2 && my > y-h/2 && my < y + h/2) {
      on = (!on);
    }
  }

  //for momentary buttons
  void chkOver(float mx, float my) {
    if (mx > x-w/2 && mx < x + w/2 && my > y-h/2 && my < y + h/2) {
      over = true;
    } 
    else {
      over = false;
    }
  }

  void display() {
    strokeWeight(2);
    stroke(hColor);
    if (on) {
      bColor = color(219, 162, 2);
    } 
    else {
      bColor = color(70);
    }
    fill(bColor);
    ellipse(x, y, w, h);
  }

  void displayRect() {

    if (colorTimer > 0) {
      colorTimer++;
      if (colorTimer < 10) {
        bColor = color(219, 162, 2);
      }
      else {
        bColor = color(70);
        colorTimer = 0;
      }
    }
    strokeWeight(2);
    stroke(hColor);
    fill(bColor);
    rect(x, y, w, h);
  }


  //reset all notes to "off"
  void reset() {
    if (resetVal == true) {
      on = false;
    }
  }

  void setReset() {
    if (over == true) {
      resetVal = true;
      colorTimer = 1;
    }
    else {
      resetVal = false;
    }
  }

  //change tone of notes
  void toneCh() {
    if (over == true) {
      toneInc = (toneInc + 1) % 3;
      colorTimer = 1;
    }
  }

  //switch instruments
  void toneInc() {
    if (over == true) {
      toneSwitch++;
      colorTimer = 1;
    }
  }

  void sound(float freq, int bufNum, int toneVal, float amp, float pos) {

    if (on) {
      //send an OSC msg to either the sine or sample Synthdef 
      if (toneSwitch % 2 == 0) {
        OscMessage oscMsg1 = oscP5.newMsg("/s_new");
        oscMsg1.add("tenori");
        oscMsg1.add(-1);
        oscMsg1.add(0);
        oscMsg1.add(0);
        oscMsg1.add("freq");
        oscMsg1.add(freq);
        oscMsg1.add("tone");
        oscMsg1.add(toneVal);
        oscMsg1.add("amp");
        oscMsg1.add(amp);
        oscMsg1.add("pos");
        oscMsg1.add(pos);
        oscP5.send(oscMsg1);
      }
      else {
        OscMessage oscMsg2 = oscP5.newMsg("/s_new");
        oscMsg2.add("playSamp");
        oscMsg2.add(-1);
        oscMsg2.add(0);
        oscMsg2.add(0);
        oscMsg2.add("bufNum");
        oscMsg2.add(bufNum);
        oscMsg2.add("amp");
        oscMsg2.add(0.5);
        oscMsg2.add("pos");
        oscMsg2.add(pos);
        oscP5.send(oscMsg2);
      }

      //draw a little strobe effect for active notes
      int fade = 200;
      fade--;
      fill(255);
      ellipse(x, y, sqSize*1.3, sqSize*1.3);
    }
  }
}

