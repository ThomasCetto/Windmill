int W = width;
int H = width;

final float TEXT_SIZE = 20;

final float LINE_STROKE = 2;
float SPEED_OF_ROTATION = 0.02;
final float PIVOT_RADIUS = 5;
final int N_PIVOTS = 1;
float CONTACT_THRESHOLD = SPEED_OF_ROTATION * 1.15;

float currRotation = random(2 * PI);
ArrayList<PVector> pivots = new ArrayList<>();
PVector line;
int currentPivotIndex = (int) random(N_PIVOTS);
PVector slope;

PVector BUTTON_POS = new PVector(300, 50);
final float BUTTON_SIZE = 30;
boolean buttonSelected = false;
final float CIRCLE_SIZE = 175;
final float CIRCLE_COUNT = 128;

int framesPassed = 0;
int lastPivotTouchedAtFrameX = -60;





void setup() {
  fullScreen();
  stroke(255);
  fill(255);
  textSize(TEXT_SIZE);
  generatePivots();
  line = new PVector(random(W), random(H));
}

void draw() {
  ++framesPassed;
  background(0);
  update();

  drawPivots();
  drawLine();

  showCircleButton();

  text("R to reload \nMouse click to add a pivot \n+ to increment speed \n- to decrease speed \n\nCurrent speed: " + (SPEED_OF_ROTATION*50), 10, 50);
  strokeWeight(LINE_STROKE);
  
}

void update() {
  updateSlopeRotation();
  changePivotIfNeeded();
}

void keyPressed() {
  if (keyCode == 82) { // R key
    totalRefresh();
  }
  if (keyCode == 521) { // + key
    SPEED_OF_ROTATION *= 1.1;
    CONTACT_THRESHOLD = SPEED_OF_ROTATION * 1.15;
  }
  if (keyCode == 45) { // - key
    SPEED_OF_ROTATION *= 0.9;
    CONTACT_THRESHOLD = SPEED_OF_ROTATION * 1.15;
  }
}

void mouseClicked() {
  PVector mouseCoords = new PVector(mouseX, mouseY);
  if (PVector.dist(mouseCoords, BUTTON_POS) <= BUTTON_SIZE) { // button clicked
    buttonSelected = !buttonSelected;
    return;
  }

  if (buttonSelected) {
    generateCircle(mouseCoords);
    return;
  }

  addPivot(mouseX, mouseY);
}

void generateCircle(PVector mouseCoords){
  float curr = 0; 
  float increment = (2*PI) / CIRCLE_COUNT;
  for(int i=0; i<CIRCLE_COUNT; i++){
     addPivot(mouseCoords.x + (CIRCLE_SIZE * cos(curr)), mouseCoords.y + (CIRCLE_SIZE * sin(curr)));
     curr += increment;
  }
}

void showCircleButton() {
  fill(buttonSelected ? 255 : 0, 0, buttonSelected ? 0 : 255); // red if selected, else blue
  ellipse(BUTTON_POS.x, BUTTON_POS.y, BUTTON_SIZE, BUTTON_SIZE);
  fill(255);
}

void addPivot(float x, float y) {
  pivots.add(new PVector(x, y));
}


void changePivotIfNeeded() {
  if (framesPassed - lastPivotTouchedAtFrameX < 3) return; // to prevent reswapping with the last pivot used, if it has been to little time ago
  
  for (int i=0; i<pivots.size(); i++) {
    if (i != currentPivotIndex && pointIsOnTheLine(pivots.get(i))) {
      currentPivotIndex = i;
      lastPivotTouchedAtFrameX = framesPassed;
      return;
    }
  }
}


boolean pointIsOnTheLine(PVector p) {
  PVector slopeBetweenPoints = PVector.sub(p, pivots.get(currentPivotIndex));
  return PVector.angleBetween(slope, slopeBetweenPoints) <= CONTACT_THRESHOLD;
}



// points must not be aligned with other two points
void generatePivots() {
  for (int i=0; i<N_PIVOTS; i++) {
    float rx = map(random(W), 0, W, 300, 1200);
    float ry = map(random(H), 0, H, 150, 650);

    pivots.add(new PVector(rx, ry));
  }
}

void totalRefresh() {
  refreshPivots();
  refreshSlope();
  currRotation = random(2*PI);
  currentPivotIndex = (int) random(N_PIVOTS);

  SPEED_OF_ROTATION = 0.02;
  CONTACT_THRESHOLD = SPEED_OF_ROTATION * 1.15;
}

void refreshSlope() {
  line = new PVector(random(W), random(H));
}

void refreshPivots() {
  pivots.clear();
  generatePivots();
}

void drawLine() {
  PVector p = pivots.get(currentPivotIndex);

  float sx = (slope.x * 1000) + p.x, sy = (slope.y * 1000) + p.y;
  float ex = (-slope.x * 1000) + p.x, ey = (-slope.y * 1000) + p.y;
  line(sx, sy, ex, ey);
}


void drawPivots() {
  for (PVector pivot : pivots) {
    ellipse(pivot.x, pivot.y, PIVOT_RADIUS, PIVOT_RADIUS);
  }
}

void updateSlopeRotation() {
  currRotation += SPEED_OF_ROTATION;
  PVector rot = new PVector(line.x, line.y);
  rot.rotate(currRotation);
  slope = rot;
}
