int WIDTH = 1500;
int HEIGHT = 800;

float currRotation = random(2 * PI);
float SPEED_OF_ROTATION = 0.005;
float PIVOT_RADIUS = 5;
int N_PIVOTS = 5;
ArrayList<PVector> pivots = new ArrayList<>();
PVector line;
int currentPivotIndex = (int) random(N_PIVOTS);





void setup() {
  size(1500, 800);
  generatePivots();
  line = new PVector(random(WIDTH), random(HEIGHT));
  
}

void draw(){
  background(0);
  
  drawPivots();
  drawLine();
  
  stroke(255);
  fill(255);
}

void keyPressed() {
  if (keyCode == 82) { // R key
    totalRefresh();
  }
}


// points must not be aligned with other two points
void generatePivots(){
  for(int i=0; i<N_PIVOTS; i++){
    float rx = map(random(WIDTH), 0, WIDTH, 300, 1200);
    float ry = map(random(HEIGHT), 0, HEIGHT, 150, 650);
    
    pivots.add(new PVector(rx, ry));    
  }
}

void totalRefresh(){
   refreshPivots();
   refreshSlope();
   currRotation = random(2*PI);
}

void refreshSlope(){
  line = new PVector(random(WIDTH), random(HEIGHT));
}

void refreshPivots(){
  pivots.clear();
  generatePivots();
}

void drawLine(){
  PVector newSlope = updatedSlope();
  PVector p = pivots.get(currentPivotIndex);
  
  float sx = (newSlope.x * 1000) + p.x, sy = (newSlope.y * 1000) + p.y;
  float ex = (-newSlope.x * 1000) + p.x, ey = (-newSlope.y * 1000) + p.y;
  line(sx, sy, ex, ey);
}


void drawPivots(){
   for(PVector pivot : pivots){    
      ellipse(pivot.x, pivot.y, PIVOT_RADIUS, PIVOT_RADIUS);
   }
}

PVector updatedSlope(){
   currRotation += SPEED_OF_ROTATION;
   PVector rot = new PVector(line.x, line.y);
   rot.rotate(currRotation);
   
   return rot;
}
