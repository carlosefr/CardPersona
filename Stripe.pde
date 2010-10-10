/*
 * Stripe.pde - A colored moving stripe for each character.
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


public class Stripe {
  private float x;
  private float stripeWidth;
  private color stripeColor;
  private int direction;
  private int last;
  
  public Stripe(float position, float w, color c, int direction) {
    this.stripeWidth = w;
    this.stripeColor = c;

    this.x = position - this.stripeWidth/2.0;
    this.direction = direction;
    
    this.last = millis();
  }
  
  public void update() {
    int now = millis();
    
    // Calculate the new position for the stripe...
    this.x +=  this.direction * (now - this.last) * this.stripeWidth/500.0;

    // The stripes loop around the screen continuously...
    if (this.x >= width) {
      this.x = 0;
    } else if (this.x + this.stripeWidth < 0) {
      this.x = width - this.stripeWidth;
    }
    
    this.last = now;
  }
  
  public void draw() {
    pushStyle();
    
    fill(this.stripeColor, 192);
    noStroke();
    
    // Draw the stripe (possibly clipped)...
    rect(this.x, 0, this.stripeWidth, height);

    // Draw the stripe overflow on the opposite side of the screen...
    if (this.x + this.stripeWidth > width) {
      rect(0, 0, (this.x + this.stripeWidth) - width, height);
    } else if (this.x < 0) {
      rect(width - abs(this.x), 0, width, height);
    }
    
    popStyle();
  }
}


/* EOF - Stripe.pde */
