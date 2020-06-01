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
boolean run = true;

float[] scalerMean = new float[3]; 
float[] scalerVariance = new float[3]; ;

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

  File f = dataFile("scalerCalibrationTable.csv");
  String filePath = f.getPath();
  boolean exist = f.isFile();

  if (!exist) {
    calibrateScaler(rawData[0], rawData[1], rawData[2]);
  }

  loadScaler("scalerCalibrationTable.csv");
}

void draw() {

  //image (img1,0,0, width,height);
  if (dataUpdated) {
    //background(52);
    fill(255);
    float[] X = {(rawData[0] - scalerMean[0])/scalerVariance[0], (rawData[1] - scalerMean[1])/scalerVariance[1], (rawData[2] - scalerMean[2])/scalerVariance[2]}; 
    String Y = getPrediction(X);
    char guess= Y.charAt(0);

    if (run) {
      programInterface.playImage(guess);
    }
    
    dataUpdated = false;
  }
}

void loadScaler(String filePath) {
  Table calibrationTable = loadTable(filePath);
  calibrationTable.addColumn("x");
  calibrationTable.addColumn("y");
  calibrationTable.addColumn("z");

  float sumX = 0;
  float sumY = 0;
  float sumZ = 0;

  for (TableRow row : calibrationTable.rows()) {
    sumX += row.getFloat("x");
    sumY += row.getFloat("y");
    sumZ += row.getFloat("z");
  }

  float[] scalerMean_ = {sumX/calibrationTable.getRowCount(), sumY/calibrationTable.getRowCount(), sumZ/calibrationTable.getRowCount()};
  scalerMean = scalerMean_;

  float sqDiffX = 0;
  float sqDiffY = 0;
  float sqDiffZ = 0;
  for (TableRow row : calibrationTable.rows()) {
    sqDiffX += sq(row.getFloat("x") - scalerMean[0]);
    sqDiffX += sq(row.getFloat("y") - scalerMean[0]);
    sqDiffX += sq(row.getFloat("z") - scalerMean[0]);
  }
  
  float[] scalerVariance_ = {sqDiffX/calibrationTable.getRowCount(), sqDiffY/calibrationTable.getRowCount(), sqDiffZ/calibrationTable.getRowCount()};
  scalerVariance = scalerVariance_;
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

void keyPressed() {
  if (key != CODED && key == ' ') {
    run = !run;
    if (run) {
      println("Program continued");
    }
    else {
      println("Program paused");
    }
  }
  else if (key != CODED && key == 'c' || key == 'C') {
    calibrateScaler(rawData[0], rawData[1], rawData[2]);
    loadScaler("scalerCalibrationTable.csv");
  }
}
