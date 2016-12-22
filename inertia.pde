Weight blue, pink, green, red;        // hanging masses
Obj solidSphere, hollowSphere, ring;  // objects (to be put on plate)
Obj pm1, pm2, pm3, pm4;

int[][] snapPoints = new int[][]{
  {150, 50},
  {50, 150},
  {150, 150},
  {100, 150},
  {200, 150},
  {250, 150},
  {150, 100},
  {150, 200},
  {150, 250}
};

float accel = 0;        // acceleration of system
float omega = 0;        // angular velocity of plate
float angle = 0;        // angular displacement of plate

int currentWeight = -1;      // current hanging mass
int draggedObject = -1;      // object currently being dragged by user

ArrayList<Weight> weights = new ArrayList<Weight>();    // all hanging masses
ArrayList<Obj> objects = new ArrayList<Obj>();        // all inertia objects
ArrayList<Obj> selectedObjects = new ArrayList<Obj>();  // inertia objects currently 
                                                        // on plate
float prevTime = 0;      // changing variable for timing the falling mass

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
      case 100: size = 10; break;
      case 200: size = 20; break;
      case 500: size = 25; break;
      case 1000: size = 30; break;
    }
  }
  
  void display() {
    fill(R, G, B);
    stroke(0);
    ellipse(xPos, yPos, size, size);
  }
  
  void move() {
    vel += accel / 10;
    yPos += vel * .56;
    if (yPos >= 400) {
      moving = false;
      finished = true;
    }
  }
  
}

class Obj extends Element {
  float inertia;
  float mass;
  float radius;
  float placedX, placedY;
  
  int type;
  // 0 = point mass
  // 1 = solid sphere
  // 2 = hollow sphere
  // 3 = ring
  
  Obj(int x, int y, int t, float m) {
    ogX = xPos = x;
    ogY = yPos = y;
    type = t;
    mass = m;
  }
  
  void display() {
    if (selectedObjects.contains(this) && (moving | finished)) {
      float phaseAngle = 0;
      int comparator = (int)placedY;
      if (type != 0) comparator += size / 2;
      switch (comparator) {
        case 50:
          phaseAngle = 3.14/2;
        case 250:
          phaseAngle = 3*3.14/2;
          break;
        case 100:
          phaseAngle = 3.14/2;
        case 200:
          phaseAngle = 3*3.14/2;
          break;
      }
      xPos = 150 + (int)(radius/.0025*cos(angle+phaseAngle)) - size / 2;
      yPos = 150 - (int)(radius/.0025*sin(angle+phaseAngle)) - size / 2;
      if (type == 0) {
        xPos += size / 2;
        yPos += size / 2;
      }
    }
    switch (type) {
      case 0: 
        switch ((int)(mass*10000)) {  
          case 625: 
            fill(54, 255, 41);
            stroke(54, 255, 41);
            break;
          case 2500: 
            fill(255, 41, 56);
            stroke(255, 41, 56);
            break;
          case 5000: 
            fill(44, 41, 255);
            stroke(44, 41, 255);
            break;
          case 10000:
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
    if (selectedObjects.contains(this) && draggedObject == -1) {
      float phaseAngle = 0;
      int comparator = (int)placedY;
      if (type != 0) comparator += size / 2;
      switch (comparator) {
        case 50:
          phaseAngle = 3.14/2;
        case 250:
          phaseAngle = 3*3.14/2;
          break;
        case 100:
          phaseAngle = 3.14/2;
        case 200:
          phaseAngle = 3*3.14/2;
          break;
      }
      
      
        int x = 0;
        switch ((int)(xPos + size/2)) {
          case 50: x = 520; break;
          case 100: x = 520 + 66; break;
          case 150: x = 520 + 66*2; break;
          case 200: x = 520 + 66*3; break;
          case 250: x = 520 + 66*4; break;
        }
        if (moving | finished) {
          x = 652 + (int)(radius/.00188*cos(angle+phaseAngle));
        }
        switch (type) {
          case 0: 
            switch ((int)(xPos)) {
              case 50: x = 520; break;
              case 100: x = 520 + 70; break;
              case 150: x = 520 + 70*2; break;
              case 200: x = 520 + 70*3; break;
              case 250: x = 520 + 70*4; break;
            }
            if (moving | finished) {
              x = 660 + (int)(radius/.00177*cos(angle+phaseAngle));
            }
            switch ((int)(mass*10000)) {  
              case 625: 
                fill(54, 255, 41);
                stroke(54, 255, 41);
                break;
              case 2500: 
                fill(255, 41, 56);
                stroke(255, 41, 56);
                break;
              case 5000: 
                fill(44, 41, 255);
                stroke(44, 41, 255);
                break;
              case 10000:
                fill(45, 165, 13);
                stroke(45, 165, 13);
                break;
            }
            ellipse(x, 52, 5, 5);
            break;
          case 1:
            image(solidSphereImg, x, 35, 20, 20);
            break;
          case 2:
            image(hollowSphereImg, x, 35, 20, 20);
            break;
          case 3:
            fill(153, 204, 155);
            stroke(153, 204, 155);
            rect(x - 60, 45, 140, 9);
            break;
        }
    }
  }
  
  void move() {
    if (type == 0) {
      xPos = mouseX;
      yPos = mouseY;
    }
    else {
      xPos = mouseX - size/2;
      yPos = mouseY - size/2;
    }
  }
  
  float inertia() {
    switch (type) {
      case 0: 
        return mass*radius*radius;
      case 1:
        return 0.0005 + mass*radius*radius;    // ???
      case 2:
        return 0.000833 + mass*radius*radius;  // ???
      case 3:
        return 0.015625 + mass*radius*radius;  // ???
    }
    return 0;
  }
}

void setup() {
  size(1000, 600);
  
  solidSphereImg = loadImage("solid.png");
  hollowSphereImg = loadImage("hollow.png");
  ringImg = loadImage("ring.png");
  
  blue = new Weight(100, 91, 149, 245, 590, 400);
  pink = new Weight(200, 245, 91, 235, 640, 400);
  green = new Weight(500, 86, 255, 41, 700, 400);
  red = new Weight(1000, 255, 41, 56, 765, 400);
  
  weights.add(blue);
  weights.add(pink);
  weights.add(green);
  weights.add(red);
  
  solidSphere = new Obj(30, 400, 1, 0.5);
  hollowSphere = new Obj(110, 400, 2, 0.5);
  ring = new Obj(190, 380, 3, 10);
  
  objects.add(ring);
  objects.add(solidSphere);
  objects.add(hollowSphere);
  objects.add(new Obj(50, 350, 0, 0.0625));
  objects.add(new Obj(90, 350, 0, 0.25));
  objects.add(new Obj(130, 350, 0, 0.5));
  objects.add(new Obj(170, 350, 0, 1));
}

void draw() {
  background(240);
  
  textSize(11);
  fill(0);
  text("100g", 575, 440);
  text("200g", 625, 440);
  text("500g", 685, 440);
  text("1000g", 750, 440);
  
  text("Solid\nSphere", 35, 460);
  text("Hollow\nSphere", 110, 460);
  text("Ring", 230, 435);
  text("62.5g", 38, 380);
  text("250g", 76, 380);
  text("500g", 115, 380);
  text("1000g", 155, 380);
  
  textSize(12);
  text("Point Masses", 90, 330);
  
  fill(41, 242, 2);
  stroke(41, 242, 2);
  ellipse(505, 75, 10, 10);
  
  stroke(0);        // rotating plate
  fill(255);
  ellipse(150, 150, 200, 200);
  
  stroke(255, 0, 0);
  
    translate(150, 150);      // put (0, 0) in the middle of the screen
    //angle = frameCount;    // draw spinning line
    line(0, 0, 100 * cos(angle), -100 * sin(angle));
    translate(-150, -150);
  if (!moving && !finished) {
    line(150, 150, 250, 150);
    fill(0);                    // snap points for objects on the plate
    stroke(0);
    ellipse(150, 150, 5, 5);
    ellipse(50, 150, 5, 5);
    ellipse(100, 150, 5, 5);
    ellipse(200, 150, 5, 5);
    ellipse(250, 150, 5, 5);
    ellipse(150, 50, 5, 5);
    ellipse(150, 100, 5, 5);
    ellipse(150, 200, 5, 5);
    ellipse(150, 250, 5, 5);
  }
  
  stroke(0);
  fill(255);
  if (mouseX >= 860 && mouseX <= 940 
      && mouseY >= 500 && mouseY <= 520) fill(200);
  rect(860, 500, 80, 20);
  fill(255);
  if (mouseX >= 860 && mouseX <= 940
      && mouseY >= 530 && mouseY <= 550) fill(200);
  rect(860, 530, 80, 20);
  
  fill(0);
  textSize(12);
  if (finished) text("Go Again", 875, 515);
  else text("Release", 880, 515);
  text("Reset", 885, 545);
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
    text("Average acceleration: " + round(accel*10000)/10000.0 + " m/s^2", 500, 515);
  }
  
  for (int i = 0; i < objects.size(); i++) {
    if (i == draggedObject) objects.get(i).move();
    objects.get(i).display();
  }
  
  if (moving && tick()) {
    weights.get(currentWeight).move();
    float alpha = accel * .25;
    omega += alpha / 100;
    angle += omega * .461;
  }
  for (int i = 0; i < weights.size(); i++) {
    weights.get(i).display();
  }
}

void release() {
  if (currentWeight < 0) return;
  
  ArrayList<Obj> temp = new ArrayList<Obj>();    // remove dupes
  for (Obj o : selectedObjects) {
    if (!temp.contains(o)) temp.add(o);
  }
  selectedObjects.clear();
  selectedObjects.addAll(temp);
  
  float I = I0;
  for (int i = 0; i < selectedObjects.size(); i++) {
    println(selectedObjects.get(i).inertia());
    I += selectedObjects.get(i).inertia();
  }
  float m = weights.get(currentWeight).mass/1000;
  accel = G*m*R*R/(m*R*R+I);
  println(accel);
  moving = true;
  prevTime = millis();
}

boolean tick() {    // true if 0.01 seconds passed since start of timer or since last tick.
  if (millis() - prevTime >= 100) {
    prevTime = millis();
    return true;
  }
  return false;
}

void mousePressed() {
  for (int i = 0; i < objects.size(); i++) {
    Obj o = objects.get(i);
    if (o.over()) {
      draggedObject = i;
    }
  }
}

void mouseReleased() {
  ArrayList<Obj> temp = new ArrayList<Obj>();    // remove dupes
  for (Obj o : selectedObjects) {
    if (!temp.contains(o)) temp.add(o);
  }
  selectedObjects.clear();
  selectedObjects.addAll(temp);
  
  if (draggedObject > -1) {
    Obj o = objects.get(draggedObject);
    for (int i = 0; i < snapPoints.length; i++) {
      float xc1, xc2, yc1, yc2;
      if (o.type == 0) {
        xc1 = o.xPos - o.size / 2;
        xc2 = o.xPos + o.size / 2;
        yc1 = o.yPos - o.size / 2;
        yc2 = o.yPos + o.size / 2;
      }
      else {
        xc1 = o.xPos;
        xc2 = o.xPos + o.size;
        yc1 = o.yPos;
        yc2 = o.yPos + o.size;
      }
      if (xc1 < snapPoints[i][0] && xc2 > snapPoints[i][0]
          && yc1 < snapPoints[i][1] && yc2 > snapPoints[i][1]) {
        if (o.type == 3) {
          if (snapPoints[i][0] == 50 || snapPoints[i][0] == 250 
              || snapPoints[i][1] == 50 || snapPoints[i][1] == 250) {
              o.xPos = o.ogX;
              o.yPos = o.ogY;
              selectedObjects.remove(o);
              draggedObject = -1;
              return;
          }
        }
        if (o.type == 0) {
          o.xPos = o.placedX = snapPoints[i][0];
          o.yPos = o.placedY = snapPoints[i][1];
        }
        else {
          o.xPos = o.placedX = snapPoints[i][0] - o.size / 2;
          o.yPos = o.placedY = snapPoints[i][1] - o.size / 2;
        }
        selectedObjects.add(o);
        o.radius = (snapPoints[i][0] - 150 + snapPoints[i][1] - 150) * 0.0025;
        draggedObject = -1;
        return;
      }
    }
    o.xPos = o.ogX;
    o.yPos = o.ogY;
    selectedObjects.remove(o);
    for (int i = 0; i < selectedObjects.size(); i++) {
      if (selectedObjects.get(i).xPos == selectedObjects.get(i).ogX
          && selectedObjects.get(i).yPos == selectedObjects.get(i).ogY)
          selectedObjects.remove(i);
    }
    for (Obj l : selectedObjects) {
      println(l.type + ", " + l.radius);
    }
    draggedObject = -1;
  }
}

void mouseClicked() {
  if (moving) return;
  if (mouseX >= 860 && mouseX <= 940 
      && mouseY >= 500 && mouseY <= 520) {
        if (finished) {
          if (currentWeight > -1) {
            Weight w = weights.get(currentWeight);
            w.vel = 0;
            w.xPos = 500;
            w.yPos = 100;
          }
          angle = 0;
          omega = 0;
          finished = false;
          for (Obj o : selectedObjects) {
            o.xPos = o.placedX;
            o.yPos = o.placedY;
          }
        }
        else release();
  }
  
  if (mouseX >= 860 && mouseX <= 940
      && mouseY >= 530 && mouseY <= 550) {
        selectedObjects.clear();
        if (currentWeight > -1) {
          Weight w = weights.get(currentWeight);
          w.xPos = w.ogX;
          w.yPos = w.ogY;
          w.vel = 0;
          angle = 0;
          omega = 0;
          currentWeight = -1;
        }
        for (Obj o : objects) {
          o.xPos = o.ogX;
          o.yPos = o.ogY;
        }
        finished = false;
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