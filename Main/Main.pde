int WIDTH = 1500;
int HEIGHT = 800;

float currRotation = random(2 * PI);
float SPEED_OF_ROTATION = 0.005;
float PIVOT_RADIUS = 5;
int N_PIVOTS = 5;
float CONTACT_THRESHOLD = SPEED_OF_ROTATION * 1.5;
ArrayList<PVector> pivots = new ArrayList<>();
PVector line;
int currentPivotIndex = (int) random(N_PIVOTS);
int previousPivotIndex = -1;
PVector slope;






void setup() {
  size(1500, 800);
  generatePivots();
  line = new PVector(random(WIDTH), random(HEIGHT));
  
}

void draw(){
  background(0);
  update();
  
  drawPivots();
  drawLine();
  
  stroke(255);
  fill(255);
}

void update(){
  updateSlopeRotation();
  changePivotIfNeeded();
  
}

void keyPressed() {
  if (keyCode == 82) { // R key
    totalRefresh();
  }
}


void changePivotIfNeeded(){
  for(int i=0; i<pivots.size(); i++){
    if(i != currentPivotIndex && i != previousPivotIndex && pointIsOnTheLine(pivots.get(i))){
      previousPivotIndex = currentPivotIndex; 
      currentPivotIndex = i;
      return;
    }
  }
}  


boolean pointIsOnTheLine(PVector p){  
  PVector slopeBetweenPoints = PVector.sub(p, pivots.get(currentPivotIndex));
  return PVector.angleBetween(slope, slopeBetweenPoints) <= CONTACT_THRESHOLD;
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
  PVector p = pivots.get(currentPivotIndex);
  
  float sx = (slope.x * 1000) + p.x, sy = (slope.y * 1000) + p.y;
  float ex = (-slope.x * 1000) + p.x, ey = (-slope.y * 1000) + p.y;
  line(sx, sy, ex, ey);
}


void drawPivots(){
   for(PVector pivot : pivots){    
      ellipse(pivot.x, pivot.y, PIVOT_RADIUS, PIVOT_RADIUS);
   }
}

void updateSlopeRotation(){
   currRotation += SPEED_OF_ROTATION;
   PVector rot = new PVector(line.x, line.y);
   rot.rotate(currRotation);
   slope = rot;   
}
