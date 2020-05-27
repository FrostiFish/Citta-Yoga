//*********************************************
// Example Code for Interactive Intelligent Products
// Rong-Hao Liang: r.liang@tue.nl
//*********************************************

import processing.serial.*;
Serial port;
Interface programInterface;

int sensorNum = 3;
int[] rawData = new int[sensorNum];
boolean dataUpdated = false;

char guess;
boolean check = false;

void setup() {
  size(800, 450);             //set a canvas
  // fullScreen();
  
  //Initialize the serial port
  for (int i = 0; i < Serial.list().length; i++) println("[", i, "]:", Serial.list()[i]);
  String portName = Serial.list()[Serial.list().length-1];//MAC: check the printed list
  //String portName = Serial.list()[9];//WINDOWS: check the printed list
  port = new Serial(this, portName, 115200);
  port.bufferUntil('\n'); // arduino ends each data packet with a carriage return 
  port.clear();           // flush the Serial buffer
  
  programInterface = new Interface(this);

  loadTrainARFF(dataset="A012GestTest2.arff"); //load a ARFF dataset
  trainLinearSVC(C=1);               //train a linear SV classifier
  saveModel(model="LinearSVC.model"); //save the model

  background(52);
}

void draw() {

  //image (img1,0,0, width,height);
  if (dataUpdated) {
    //background(52);
    fill(255);
    float[] X = {rawData[0], rawData[1], rawData[2]}; 
    String Y = getPrediction(X);
    guess= Y.charAt(0);

    programInterface.playImage(guess);
    dataUpdated = false;
  }
}

void serialEvent(Serial port) {   
  String inData = port.readStringUntil('\n');  // read the serial string until seeing a carriage return
  if (!dataUpdated) 
  {
    if (inData.charAt(0) == 'A') {
      rawData[0] = int(trim(inData.substring(1)));
    }
    if (inData.charAt(0) == 'B') {
      rawData[1] = int(trim(inData.substring(1)));
    }
    if (inData.charAt(0) == 'C') {
      rawData[2] = int(trim(inData.substring(1)));
      dataUpdated = true;
    }
  }
}
