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
  static private final float NOTE_DENSITY = 0.8;
  static private final int TEMPO_BPM = 420;
  
  private final float[] pitches = { 62, 64, 60, 48, 55 };  // Close Encounters of the Third Kind...
  private final float[] instruments = { SoundCipher.ACOUSTIC_GRAND, SoundCipher.ACOUSTIC_GUITAR, SoundCipher.ACOUSTIC_BASS, SoundCipher.TROMBONE };

  private SoundCipher track;
  private ArrayList<Float> notes;
  private int noteRoot = 0;
  private int noteCounter;
  private int last;
  
  public SoundTrack() {
    this.track = new SoundCipher();
    this.notes = new ArrayList<Float>(80);
    
    this.clear();    
  }

  public void clear() {
    this.track.stop();
    this.track.instrument(this.instruments[round(random(this.instruments.length - 1))]);

    this.notes.clear();    
    this.noteRoot = 0;
    this.noteCounter = 0;
    
    this.last = millis();
  }
  
  public void add(char data) {
    this.notes.add(this.pitches[data % this.pitches.length]);
  }
  
  public void step() {
    // Nothing to play...
    if (this.notes.size() == 0) {
      return;
    }
    
    int now = millis();

    if (now - this.last >= (60.0/TEMPO_BPM) * 1000.0 && random(1.0) < NOTE_DENSITY) {
      float note = this.notes.get(this.noteCounter % this.notes.size()) + this.noteRoot;

      this.track.playNote(note, lerp(noise(this.noteCounter), 60, 100), 0.5);
            
      this.noteCounter++;
      this.last = now;
      
      if (this.noteCounter % this.notes.size() == 0) {
        this.noteRoot += (random(1.0) < 0.5) ? -12 : 12;    // change the root note...
        this.noteRoot = constrain(this.noteRoot, -12, 48);  // ...but keep it sane
      }
    }
  }
}


/* EOF - SoundTrack.pde */
