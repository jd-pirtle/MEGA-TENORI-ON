// setup osc functioniality

void initOsc() {
  receiveAtPort = 12000;
  sendToPort = 57110; // supercollider server 
  host = "131.193.77.178";  //change to whatever the IP wants to recieve
  oscP5event = "oscEvent";  
  oscP5 = new OscP5(this, host, sendToPort, receiveAtPort, oscP5event);
}



