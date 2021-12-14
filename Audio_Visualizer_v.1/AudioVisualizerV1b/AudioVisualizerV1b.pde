/*
Audio Visualizer V1, by Xavier Beech
Made for Comp.Lit. 240
Initial build, will continue work in future
12/13/21 v.1
*/

import processing.sound.*;
import processing.sound.SoundFile;
// Declare the processing sound variables
SoundFile sample;
Amplitude rms;
String fileName = "sample.wav";
//AudioPlayer player;
FFT fft;

final int timeSize = 512;
final float sampleRate = 44100;

final int HEIGHT = 780;
final int WIDTH = 1800;

boolean drawing = true;
float volThreshold = .01;

// Define how many FFT bands to use (this needs to be a power of two)
int bands = 512;

// Define a smoothing factor which determines how much the spectrums of consecutive
// points in time should be combined to create a smoother visualisation of the spectrum.
// A smoothing factor of 1.0 means no smoothing (only the data from the newest analysis
// is rendered), decrease the factor down towards 0.0 to have the visualisation update
// more slowly, which is easier on the eye. Default .2
float scalingFactor = .2;

int startingPxl = 20;

// Create a vector to store the smoothed spectrum data in
float[] sum = new float[bands];

// Declare a drawing variable for calculating the width of the
float barWidth;

float[] randR = new float[bands];
float[] randG = new float[bands];
float[] randB = new float[bands];

float frameNum = 0;
float speedScaler = 5;

public void settings() {
    
    size(WIDTH, HEIGHT);
}

public void setup() {
    
    // minim = new Minim(this);
    
    // player = minim.loadFile(fileName);
    
    //Create and patch the rms tracker
    rms = new Amplitude(this);
    rms.input(sample); //Processing amp lib
    
    //Calculate the width of the rects depending on how many bands we have
    barWidth = width / float(bands);
    
    //Load and play a soundfile and loop it.
    sample = new SoundFile(this, fileName);
    sample.play(); //Processing sound lib
    
    //Create the FFT analyzer and connect the playing soundfile to it.
    fft = new FFT(this, bands); //Processing FFT library
    //fft = new FFT(timeSize, sampleRate); //Minim FFT library
    fft.input(sample);
    
    for (int i = 0; i < bands; i++) {
        randR[i] = random(0,255);
        randG[i] = random(0,255);
        randB[i] = random(0,255);
    }
    background(51);
    
}

public void draw() {
    //Set background color, noStroke and fill color
    noStroke();
    
    //Wedraw a circle whose size is coupled to the audio analysis
    //Set background color, noStroke and fill color
    noStroke();
    
    //Perform the analysis
    fft.analyze();
    if (rms.analyze() > volThreshold)
        drawing = true;
    
    if (drawing)
        for (int i = 0; i < bands; i++) {
            // i= band number of given frequency measurement. 
            
            // Smooth the FFT spectrum data by smoothing factor
            sum[i] += ((fft.spectrum[i] - sum[i])) * scalingFactor;
            
            fill(randR[i], randG[i], randB[i]);
        
        //ellipse((WIDTH*(sample.percent() / 100)), i * (HEIGHT / bands), 1, sum[i] * (height / 2));
        
         ellipse((WIDTH*(sample.percent() / 100)),(sum[i] * (height / 2)) + (i * 10), 10, 10);
    }
    frameNum++;
}
