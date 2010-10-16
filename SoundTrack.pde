/*
 * SoundTrack.pde - sequence of notes.
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


import arb.soundcipher.*;


public class SoundTrack {
  // Close Encounters of the Third Kind... :)
  private final float[] pitches = { 62, 64, 60, 48, 55 };

  private SoundCipher track;  
  private float[] notes;
  private float[] dynamics;
  private float[] durations;
    
  public SoundTrack() {
    this.track = new SoundCipher();
    this.track.instrument(SoundCipher.ACOUSTIC_GUITAR);
  }

  public void clear() {
    this.track.stop();
    
    this.notes = null;
    this.dynamics = null;
    this.durations = null;
  }
  
  public void set(String data) {
    this.notes = new float[data.length()];
    this.dynamics = new float[data.length()];
    this.durations = new float[data.length()];
    
    for (int i = 0; i < data.length(); i++) {
      char elem = data.charAt(i);
      
      this.notes[i] = this.pitches[elem % this.pitches.length];
      this.dynamics[i] = (elem == ' ') ? 0 : random(60, 100);  // pause on spaces...
      this.durations[i] = 0.3;
    }
  }
  
  public void play() {
    this.track.playPhrase(this.notes, this.dynamics, this.durations);
  }
}


/* EOF - SoundTrack.pde */
