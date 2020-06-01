import processing.sound.*;

void calibrateScaler() {
  println("updating Scaler...");
  
  Table scalerCalibrationTable = new Table();
  scalerCalibrationTable.addColumn("x");
  scalerCalibrationTable.addColumn("y");
  scalerCalibrationTable.addColumn("z");
  int background = 255;
  int textSize = 32;
  int sampleCount = 25;
  int waitTime = 5000;
  int samples;
  int poseStartTime;
  TableRow newRow;
  
  println("Get ready for calibration");
  delay(1000);
  println(3);
  delay(1000);
  println(2);
  delay(1000);
  println(1);
  delay(1000);

  println("Take on pose A (Chaturanga)");
 
  samples = 0;
  poseStartTime = millis();
  delay(1000);
  
  while (samples < sampleCount) {
    if (dataUpdated) {
      newRow = scalerCalibrationTable.addRow();
      newRow.setFloat("x", rawData[0]);
      newRow.setFloat("y", rawData[1]);
      newRow.setFloat("z", rawData[2]);
      samples++;
    }
  }
  while(poseStartTime + waitTime > millis()) ;

  println("Take on pose B (Upward Dog)");

  samples = 0;
  poseStartTime = millis();
  delay(1000);
  
  while (samples < sampleCount) {
    if (dataUpdated) {
      newRow = scalerCalibrationTable.addRow();
      newRow.setFloat("x", rawData[0]);
      newRow.setFloat("y", rawData[1]);
      newRow.setFloat("z", rawData[2]);
      samples++;
    }
  }
  while(poseStartTime + waitTime > millis()) ;

  println("Take on pose C (Downward Dog)");

  samples = 0;
  poseStartTime = millis();
  delay(1000);
  
  while (samples < sampleCount) {
    if (dataUpdated) {
      newRow = scalerCalibrationTable.addRow();
      newRow.setFloat("x", rawData[0]);
      newRow.setFloat("y", rawData[1]);
      newRow.setFloat("z", rawData[2]);
      samples++;
    }
  }
  while(poseStartTime + waitTime > millis()) ;

  println("Take on pose D (Resting pose)");

  samples = 0;
  poseStartTime = millis();
  delay(1000);
  
  while (samples < sampleCount) {
    if (dataUpdated) {
      newRow = scalerCalibrationTable.addRow();
      newRow.setFloat("x", rawData[0]);
      newRow.setFloat("y", rawData[1]);
      newRow.setFloat("z", rawData[2]);
      samples++;
    }
  }
  while(poseStartTime + waitTime > millis()) ;

  saveTable(scalerCalibrationTable, "data/scalerCalibrationTable.csv");
  println("saved calibration data as scalerCalibrationTable.csv");
}

class Interface {
  private PApplet parameter;

  private PImage img0;
  private PImage img1;
  private PImage img2;
  private PImage img3;

  private SoundFile file;
  private SoundFile file2;
  private SoundFile file3;
  private SoundFile file4;
  private SoundFile gong;

  protected boolean played = true;// false if you want the introduction
  protected boolean played2 = false;
  protected boolean played3 = false;
  protected boolean played4 = false;
  protected boolean playedGong= false;

  protected boolean pose0 = false; 
  protected boolean pose1 = false;
  protected boolean pose2 = false;
  protected boolean pose3= false;

  Interface(PApplet parameter) {
    this.file = new SoundFile(parameter, "Pose-1.wav");
    this.file2 = new SoundFile (parameter, "Pose-5.wav");
    this.file3= new SoundFile (parameter, "Pose-6.wav");
    this.file4 = new SoundFile(parameter, "Pose-7.wav");
    this.gong = new SoundFile (parameter, "gong.wav");
    this.gong.amp(0.2);


    this.img0= loadImage("3_poses_zonnegroet-04.png");
    this.img1= loadImage("3_poses_zonnegroet-01.png");
    this.img2= loadImage("3_poses_zonnegroet-02.png");
    this.img3= loadImage("3_poses_zonnegroet-03.png");
    thread("playImage");
  }

  void playImage(char pred) {
    println(pred);
    if (this.pose0 == false) {
      image(this.img0, 0, 0, width, height);
      this.playSound(0);
    }

    if (this.file.isPlaying() == false && this.pose0 == false) {
      image(this.img1, 0, 0, width, height);
      this.playSound(1);
      this.pose0= true;
    }

    // Pose A = first pose
    if (this.file2.isPlaying() == false && this.played2 == true && pred == 'A'  && this.gong.isPlaying() == false && this.playedGong == false && this.pose1 == false && this.pose0 == true) {
      this.gong.play();
      println(pred);
      this.playedGong = true;
      this.pose1 = true;
    }
    //reset gong and play next instuction
    if (this.gong.isPlaying() == false && this.playedGong == true && this.pose2 == false) {
      this.playedGong = false;
      image(this.img2, 0, 0, width, height);
      this.playSound(2);
    }


    //Pose B = second pose
    if (this.file3.isPlaying() == false && this.played3 == true && pred == 'B' && this.gong.isPlaying() == false && this.playedGong == false && this.pose1 == true && this.pose2 == false) {
      // sw2.start();
      this.gong.play();
      println(pred);
      this.playedGong = true;
      this.pose2= true;
    }
    //reset gong and play next instuction
    if (this.gong.isPlaying() == false && this.playedGong == true && this.pose3 == false) {
      this.playedGong = false;
      image(this.img3, 0, 0, width, height);
      this.playSound(3);
    }
    //Pose C = third pose
    if (this.file4.isPlaying() == false && this.played4 == true && pred=='C' && this.gong.isPlaying() == false && this.playedGong == false && this.pose1 == true && this.pose2 == true && this.pose3 == false) {
      // sw2.start();
      this.gong.play();
      println(pred);
      this.playedGong = true;
      this.pose3= true;
      println("Finished");
    }

    //reset gong and play next instuction
    if (this.gong.isPlaying() == false && this.playedGong == true && this.pose1 == true && this.pose2 == true && this.pose3 == true) {
      this.playedGong = false;
      println("Reset");
      this.resetPoses();
    }
  }

  void playSound(int i) {
    if (i==0 && played == false) {
      if (this.file.isPlaying() == false && this.file2.isPlaying() == false && this.file3.isPlaying() == false && this.file4.isPlaying() == false) {
        this.file.play();
        this.played = true;
      }
    }
    if (i == 1 && this.played2 == false) {
      if (this.file.isPlaying() == false && this.file2.isPlaying() == false && this.file3.isPlaying() == false && this.file4.isPlaying() == false) {
        this.file2.play();
        this.played2 = true;
      }
    }
    if (i ==2&& this.played3 == false ) {
      if (this.file.isPlaying() == false && this.file2.isPlaying() == false && this.file3.isPlaying() == false && this.file4.isPlaying() == false) {
        this.file3.play();
        this.played3 = true;
      }
    }
    if (i == 3 && played4 == false) {
      if (this.file.isPlaying() == false && this.file2.isPlaying() == false && this.file3.isPlaying()== false && this.file4.isPlaying()== false) {
        this.file4.play();
        this.played4 = true;
      }
    }
  }

  public void resetPoses() {
    this.played = true;
    this.played2 = false;
    this.played3 = false;
    this.played4 = false;
    this.playedGong= false;
    
    this.pose0= false;
    this.pose1= false;
    this.pose2 = false;
    this.pose3= false;
  }
}
