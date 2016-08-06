int mode, spinDirect, pauseTime;
color _color, bgColor, strokeColor;
float colorCR, alphaCR, alpha, alphaMin, alphaMax,
  growth, x, y, z, w, h, d, spin, spinSpeed, growthPadding;
float[] red, green, blue;
boolean[] fatR, fatG, fatB;
boolean fatA, fatW, fatH, fatD, flattened, paused;

void setup() {
  size(displayWidth, displayHeight, P3D);
  shapeOrient(); colorOrient();
  background(bgColor);
  noStroke();
}

void draw() {
  //background(bgColor);
  //stroke(strokeColor);
  //strokeWeight(2.5);
  fill(_color, alpha);
  updateCube(); renderCube();
}

void renderCube() {
  pushMatrix();
  // move/change here
  translate(x, y, z);
  spin();
  box(w, h, d);
  popMatrix();
}

void updateCube() {
  listen();
  if (!paused) {
    // stops growth for viewing pleasures
    colorMorph(); shapeMorph();
  }
}

void listen() {
  // listens for all mouse/screen presses
  if (mousePressed) {
    if (pauseTime <= millis()-1000) {
      paused = !paused; pauseTime = millis();
    }
    if (paused) {
      w = h = d = 0;
    } else {
      w = random(1+growth, width);
      h = random(1+growth, height);
      d = random(1+growth, width);
      red[0] = random(255);
      green[0] = random(255);
      blue[0] = random(255);
      if (spinDirect < 5) {
        spinDirect++;
      } else {
        spinDirect = 0;
      }
      background(bgColor);
    }
    // when cube is clicked on
    //if (overCube()) {
    //}
  }
}

boolean overCube() {
  boolean over = false;
  float disX = x - mouseX;
  float disY = y - mouseY;
  if (sqrt(sq(disX) + sq(disY)) < (w+50)/2) {
    over = true;
  }
  return over;
}

void spin() {
  spin += spinSpeed;
  switch (int(spinDirect)) {
    case 0:
      rotateX(PI/5 - spin);
      rotateY(PI/5 - spin);
      break;
    case 1:
      rotateX(PI/5 + spin);
      rotateY(PI/5 + spin);
      break;
    case 2:
      rotateX(PI/5 + spin);
      rotateY(PI/5 - spin);
      break;
    case 3:
      rotateX(PI/5 - spin);
      rotateY(PI/5 + spin);
      break;
    case 4:
      rotateX(PI/5);
      rotateY(PI/5 + spin);
      break;
    case 5:
      rotateX(PI/5);
      rotateY(PI/5 - spin);
      break;
  }
}

void shapeOrient() {
  spinDirect = int(random(5));
  spin = 0; spinSpeed = 0.00175; // current spin state, spin speed
  growth = 1.75; // also rate of cube growth
  //w = h = d = 250; // all set to same value
  w = random(1+growth, width);
  h = random(1+growth, height);
  d = random(1+growth, width);
  fatW = fatH = fatD = flattened = false;
  paused = false; pauseTime = 0;
  x = width/2; y = height/2; z = 0;
  // to prevent cube going too far off edges
  growthPadding = 0.25;
}

void colorOrient() {
  red = new float[3]; green = new float[3]; blue = new float[3];
  fatR = new boolean[3]; fatG = new boolean[3]; fatB = new boolean[3];
  for (int i=0; i<3; i++) {
    red[i] = random(255);
    blue[i] = random(255);
    green[i] = random(255);
    fatR[i] = fatG[i] = fatB[i] = false;
  }
  _color = color(red[0], green[0], blue[0]);
  bgColor = color(red[1], green[1], blue[1]);
  strokeColor = color(red[2], green[2], blue[2]);
  alphaMin = 2.5; alphaMax = 175; fatA = false;
  alpha = random(alphaMin, alphaMax);
  alphaCR = 2.5; colorCR = 1.5;
}

void colorMorph() {
  // just 3 for the 3 color sets
  for (int i=0; i<3; i++) {
    // Red
    if (red[i] <= colorCR) {
      fatR[i] = false;
    } else if (red[i] >= 255-colorCR) {
        fatR[i] = true;
    } if (fatR[i]) {
        red[i] -= colorCR;
    } else red[i] += colorCR;
    // Green
    if (green[i] <= colorCR) {
      fatG[i] = false;
    } else if (green[i] >= 255-colorCR) {
        fatG[i] = true;
    } if (fatG[i]) {
        green[i] -= colorCR;
    } else green[i] += colorCR;
    // Blue
    if (blue[i] <= colorCR) {
      fatB[i] = false;
    } else if (blue[i] >= 255-colorCR) {
        fatB[i] = true;
    } if (fatB[i]) {
        blue[i] -= colorCR;
    } else blue[i] += colorCR;
    switch (i) {
      case 0:
        _color = color(red[i], green[i], blue[i]);
        break;
      case 1:
        bgColor = color(red[i], green[i], blue[i]);
        break;
      case 2:
        strokeColor = color(red[i], green[i], blue[i]);
        break;
    }
  }
  // fading opacity goes back and forth
  if (alpha <= alphaMin+alphaCR) {
    fatA = false;
  } else if (alpha >= alphaMax-alphaCR) {
      fatA = true;
  } if (fatA) {
      alpha -= alphaCR;
  } else alpha += alphaCR;
}
  
void shapeMorph() {
  // WIDTH
  if (w <= 1+growth) {
    fatW = false;
  } else if (w >= width-growth-(width*growthPadding)) {
      fatW = true;
  } if (fatW) {
      w -= growth;
  } else w += growth;
  // HEIGHT
  if (h <= 1+growth) {
      fatH = false;
  } else if (h >= height-growth-(width*growthPadding)) {
      fatH = true;
  } if (fatH) {
      h -= growth;
  } else h += growth;
  // DEPTH
  if (d <= 1+growth) {
      fatD = false;
  } else if (d >= width-growth-(width*growthPadding)) {
      fatD = true;
  } if (fatD) {
      d -= growth;
  } else d += growth;
}