/*
 * Stripes.pde - animated stripes management.
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


public class Stripes {
  private List<Stripe> stripes;
  private float[] baseHues;
  
  
  public Stripes() {
    this.stripes = new ArrayList<Stripe>();
    this.baseHues = new float[3];

    this.clear();
  }
  
  public void clear() {
    // "Analogic" color selection...
    this.baseHues[0] = random(0, 360);
    this.baseHues[1] = (this.baseHues[0] - 30) % 360;
    this.baseHues[2] = (this.baseHues[0] + 30) % 360;
    
    this.stripes.clear();
  }
  
  public void set(String data) {
    // Using HSB makes it easier to control the colors...
    colorMode(HSB, 360.0, 1.0, 1.0);

    // The initial space between stripes...
    float spacing = width / (data.length() + 1.0);

    for (int i = 0; i < data.length(); i++) {
      char elem = data.charAt(i);
      float position = (i+1) * spacing;
      
      // We know that the characters on the card have a limited range...
      float w = map(elem, 32, 96, width/150.0, width/15.0);
      color c = color(this.baseHues[round(noise(elem, 0)) * (this.baseHues.length - 1)], noise(elem, 1), noise(elem, 2));
  
      this.stripes.add(new Stripe(position, w, c, noise(position) >= 0.5 ? 1 : -1));
    }

    // Revert back...
    colorMode(RGB);
  }
  
  public void update() {
    Iterator<Stripe> iterator = this.stripes.iterator();
  
    while (iterator.hasNext()) {
      iterator.next().update();
    }
  }
  
  public void draw() {
    Iterator<Stripe> iterator = this.stripes.iterator();
  
    while (iterator.hasNext()) {
      iterator.next().draw();
    }
  }
}


/* EOF - Stripes.pde */
