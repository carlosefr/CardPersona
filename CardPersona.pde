/*
 * CardPersona.pde - Using magnetic card data as a seed.
 *
 * Copyright (c) 2010 Carlos Rodrigues <cefrodrigues@gmail.com>
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */


import processing.opengl.*;
import javax.media.opengl.GL;

import processing.serial.*;


color fgColor = #ffffff;
color bgColor = #222222;

PFont nameFont;
Serial card;

// Data read from the card...
String cardData = "";
String cardOwner = "";

// Is there new card data pending?...
boolean cardPending = true;

Stripes stripes;
SoundTrack music;


void setup() {
  size(1024, 500, OPENGL);
  frameRate(30);
  smooth();

  // Force v-sync and anti-aliasing when using OpenGL...
  if (glRendererEnabled()) {
    glSetSync(true);
    glSetSmooth(true);
  }

  // Hide the cursor when in "present/fullscreen" mode...
  if (frame.isUndecorated()) {
    noCursor();
  }
  
  nameFont = loadFont("Eurostile-Bold-18.vlw");
  
  stripes = new Stripes();
  music = new SoundTrack();
  
  String[] ports = Serial.list();
  String arduino = "";
  
  for (int i = 0; i < ports.length; i++) {
    // Find the first USB serial device (Mac OS X only)...
    if (ports[i].startsWith("/dev/tty.usbserial-")) {
      arduino = ports[i];
      
      break;
    }
  }

  println("Serial device: " + arduino);
  
  card = new Serial(this, arduino, 9600);
  card.bufferUntil('\n');  // data from the card ends in a newline
  
  background(bgColor);
}


void draw() {
  if (cardPending) {
    // This makes each card random, but always identical to itself...
    randomSeed(cardData.hashCode());
    noiseSeed(cardData.hashCode());
    
    // The stripes are based on the full card data...
    stripes.clear();
    stripes.set(cardData);
    
    // The music corresponds to the card owner...
    music.clear();
    music.set(cardOwner);
    music.play();  // (non-blocking)
    
    cardPending = false;
  }
  
  background(bgColor);

  stripes.update();
  stripes.draw();
  
  fill(fgColor);
  textFont(nameFont);
  textAlign(RIGHT);
  text(cardOwner, width - 30, height - 30);
}


// Triggered when a card has been read successfully...
void serialEvent(Serial card) {
  cardData = card.readString();
  cardData = cardData.substring(0, cardData.length() - 1);  // drop the newline
  
  String[] fields = splitTokens(cardData, "%^=?");

  // Find the card owner's name...  
  for (int i = 0; i < fields.length; i++) {
    if (match(fields[i], "^[A-Z]{2,}") != null) {
      cardOwner = trim(fields[i]);

      break;
    }
  }
  
  // Signal that there's new card data available...
  cardPending = true;
}


/* EOF - CardPersona.pde */
