//Omicron TouchListener library by Arthur Nishimoto



class MyTouchListener implements TouchListener{
 
  // Called on a touch down event
  public void touchDown(int ID, float xPos, float yPos, float xWidth, float yWidth){
    noFill();
    stroke(180, 18, 0);
    ellipse( xPos, yPos, space*0.25, space*0.25);
    
    // This is an optional call if you want the function call in the main applet class.
    // 'OmicronExample' should be replaced with the sketch name i.e. ((SketchName)applet).touchDown( ID, xPos, yPos, xWidth, yWidth );
    // Make sure applet is defined as PApplet and that 'applet = this;' is in setup().
   ((TENORI_ON_FINAL)applet).touchDown( ID, xPos, yPos, xWidth, yWidth );
  }
  
  // Called on a touch move event
  public void touchMove(int ID, float xPos, float yPos, float xWidth, float yWidth){
    noFill();
    stroke(180, 18, 0);
    ellipse( xPos, yPos, space*0.25, space*0.25);
    
    ((TENORI_ON_FINAL)applet).touchMove( ID, xPos, yPos, xWidth, yWidth );
  }
  
  // Called on a touch up event
  public void touchUp(int ID, float xPos, float yPos, float xWidth, float yWidth){
    noFill();
    stroke(180, 18, 0);
    ellipse( xPos, yPos, space*0.25, space*0.25);
    
    ((TENORI_ON_FINAL)applet).touchUp( ID, xPos, yPos, xWidth, yWidth );
  }
  
}
