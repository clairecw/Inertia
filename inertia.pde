Weight blue, pink, green, red;        // hanging masses
Obj solidSphere, hollowSphere, ring;  // objects (to be put on plate)
Obj pm1, pm2, pm3, pm4;

ArrayList<Weight> weights = new ArrayList<Weight>();
float accel = 0;
int currentWeight = -1;
ArrayList<Obj> objects = new ArrayList<Obj>();
ArrayList<Obj> currentObjects = new ArrayList<Obj>();
float m = 0;

// CONSTANTS //
static float G = 9.81;    // gravitational constant 
static float I0 = 0.03;   // inertia of rotating plate alone
static float R = 0.25;    // radius of rotating plate

PImage solidSphereImg;    // object images
PImage hollowSphereImg;
PImage ringImg;

boolean moving = false;   // system in motion or not.
boolean finished = false; // system finished one round of movement.

class Element {
  float ogX, ogY;    // object's original position.
  float xPos, yPos;  // object's current position.
  int size;          // object's radius.
  
  Element() {
  }
  
  boolean over() {
   return (mouseX >= xPos - 10 && mouseX <= xPos + size + 10
       && mouseY >= yPos - 10 && mouseY <= yPos + size + 10);
         
  }
}

class Weight extends Element {
  float mass;        // mass in grams.
  int R, G, B;
  float vel = 0;
  
  Weight(int m, int r, int g, int b, float x, float y) {
    mass = m;
    R = r;
    G = g;
    B = b;
    ogX = xPos = x;
    ogY = yPos = y;
    size = 20;
    switch (m) {
      case 10: size = 10; break;
      case 200: size = 20; break;
      case 500: size = 25; break;
      case 1000: size = 30; break;
    }
  }
  
  void display() {
    fill(R, G, B);
    ellipse(xPos, yPos, size, size);
  }
  
  void move() {
    vel += accel/1000;
    yPos += vel;
    if (yPos >= 400) {
      moving = false;
      finished = true;
    }
    delay(10);
  }
  
}

class Obj extends Element {
  float inertia;
  int mass;
  float radius;
  
  int type;
  // 0 = point mass
  // 1 = solid sphere
  // 2 = hollow sphere
  // 3 = ring
  
  Obj(int x, int y, int t, int m) {
    ogX = xPos = x;
    ogY = yPos = y;
    type = t;
    mass = m;
  }
  
  void display() {
    switch (type) {
      case 0: 
        switch (mass) {  
          case 56: 
            fill(54, 255, 41);
            stroke(54, 255, 41);
            break;
          case 250: 
            fill(255, 41, 56);
            stroke(255, 41, 56);
            break;
          case 500: 
            fill(44, 41, 255);
            stroke(44, 41, 255);
            break;
          case 1000:
            fill(45, 165, 13);
            stroke(45, 165, 13);
            break;
        }
        ellipse(xPos, yPos, 20, 20);
        size = 20;
        break;
      case 1:
        image(solidSphereImg, xPos, yPos, 40, 40);
        size = 40;
        break;
      case 2:
        image(hollowSphereImg, xPos, yPos, 40, 40);
        size = 40;
        break;
      case 3:
        image(ringImg, xPos, yPos, 100, 100);
        size = 100;
        break;
    }
  }
}

void setup() {
  size(1000, 600);
  
  solidSphereImg = loadImage("solid.png");
  hollowSphereImg = loadImage("hollow.png");
  ringImg = loadImage("ring.png");
  
  blue = new Weight(10, 91, 149, 245, 598, 400);
  pink = new Weight(200, 245, 91, 235, 620, 400);
  green = new Weight(500, 86, 255, 41, 650, 400);
  red = new Weight(1000, 255, 41, 56, 690, 400);
  
  weights.add(blue);
  weights.add(pink);
  weights.add(green);
  weights.add(red);
  
  solidSphere = new Obj(30, 400, 1, 10);
  hollowSphere = new Obj(80, 400, 2, 10);
  ring = new Obj(130, 380, 3, 10);
  
  objects.add(solidSphere);
  objects.add(hollowSphere);
  objects.add(ring);
}

void draw() {
  background(240);
  
  fill(41, 242, 2);
  stroke(41, 242, 2);
  ellipse(505, 75, 10, 10);
  
  stroke(0);
  fill(255);
  ellipse(150, 150, 200, 200);
  
  fill(0);                    // stick points for objects on the plate
  ellipse(150, 150, 5, 5);
  ellipse(50, 150, 5, 5);
  ellipse(100, 150, 5, 5);
  ellipse(200, 150, 5, 5);
  ellipse(250, 150, 5, 5);
  ellipse(150, 50, 5, 5);
  ellipse(150, 100, 5, 5);
  ellipse(150, 200, 5, 5);
  ellipse(150, 250, 5, 5);
  
  stroke(0);
  fill(255);
  if (mouseX >= 860 && mouseX <= 940 
      && mouseY >= 500 && mouseY <= 520) fill(200);
  rect(860, 500, 80, 20);
  
  fill(0);
  textSize(12);
  text("Release", 880, 515);
  textSize(20);
  text("Top View", 300, 50);
  text("Side View", 840, 50);
  line(460, 20, 460, 500);
  
  fill(200);
  rect(520, 55, 280, 20);
  line(500, 70, 800, 70);
  
  if (currentWeight < 0) line(500, 70, 500, 100);
  else { 
    Weight w = weights.get(currentWeight);
    line(500, 70, w.xPos, w.yPos);
    
  }
  
  if (finished) {
    textSize(16);
    fill(0);
    text("Average acceleration: " + accel, 500, 515);
  }
  
  if (moving) weights.get(currentWeight).move();
  for (int i = 0; i < weights.size(); i++) {
    weights.get(i).display();
  }
  
  for (int i = 0; i < objects.size(); i++) {
    objects.get(i).display();
  }
  
  for (int i = 0; i < objects.size(); i++) {
    objects.get(i).display();
  }
  
  if (moving) weights.get(currentWeight).move();
  for (int i = 0; i < weights.size(); i++) {
    weights.get(i).display();
  }
}

  void release() {
  if (currentWeight < 0) return;
  if (finished) {
    weights.get(currentWeight).vel = 0;
    finished = false;
  }
  float I = I0;
  for (int i = 0; i < currentObjects.size(); i++) {
    I += currentObjects.get(i).inertia;
  }
  m = weights.get(currentWeight).mass/1000;
  accel = G*m*R*R/(m*R*R+I);
  moving = true;
}

void mousePressed() {
  
}

void mouseClicked() {
  if (mouseX >= 860 && mouseX <= 940 
      && mouseY >= 500 && mouseY <= 520) {
        release();
  }
  
  for (int i = 0; i < weights.size(); i++) {
    Weight w = weights.get(i);
    if (w.over()) {
      if (currentWeight == i) {
        w.xPos = w.ogX;
        w.yPos = w.ogY;
        currentWeight = -1;
      }
      else {
        if (currentWeight > -1) {
          Weight prevW = weights.get(currentWeight);
          prevW.xPos = prevW.ogX;
          prevW.yPos = prevW.ogY;
        }
        currentWeight = i;
        w.xPos = 500;
        w.yPos = 100;
      }
    }
  }
}