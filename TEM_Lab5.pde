 

// GAME STATES 
int state = 0;  //0=Start, 1=Play, 2=Game Over, 3=Win

float px, py;           // Player position
float vx, vy;           // Player velocity 
float pR = 18;          // Player radius

// Physics constants for smooth movement
float accel = 0.8;      // How fast player speeds up
float friction = 0.96;  // How quickly player slows down
float gravity = 0.7;    // Gravity strength
float jumpForce = -12;  //Jump strength 


float groundY;

// ENEMY VARIABLES 
int enemyCount = 8;                    // Number of enemies
float[] ex = new float[enemyCount];    // Enemy X positions
float[] ey = new float[enemyCount];    // Enemy Y positions
float[] evx = new float[enemyCount];   // Enemy X velocities
float[] evy = new float[enemyCount];   // Enemy Y velocities
float eR = 15;                         // Enemy radius


int lives = 3;              
int startTime;              
int gameDuration = 30;      
boolean canHit = true;      
int hitCooldownMs = 800;    
int lastHitTime;          

//  VISUAL VARIABLES
PFont titleFont;           
int flashTimer = 0;         


void setup() {
  size(800, 500);
  frameRate(60);
  
  
  titleFont = createFont("Arial", 32, true);
  

  groundY = height - 60;
  
  // Initialize player position
  px = width / 2;
  py = groundY;
  vx = 0;
  vy = 0;
  
  // Initialize enemies
  initEnemies();
}


void initEnemies() {
  for (int i = 0; i < enemyCount; i++) {
    
    ex[i] = random(eR, width - eR);
    ey[i] = random(eR, height - eR);
    
   
    evx[i] = random(-3, 3);
    evy[i] = random(-3, 3);
    
   
  }
}


void draw() {
  
  if (state == 0) {
    drawStartScreen();
  } else if (state == 1) {
    drawGameplay();
  } else if (state == 2) {
    drawGameOverScreen();
  } else if (state == 3) {
    drawWinScreen();
  }
}


void drawStartScreen() {
  background(20, 30, 45);  // Dark blue-black background
  
  // Title
  textFont(titleFont);
  textAlign(CENTER, CENTER);
  fill(255, 200, 100);
  text("DODGE & SURVIVE", width/2, height/3);
  
  // Instructions
  textFont(createFont("Arial", 18, true));
  fill(200);
  text("Survive for 30 seconds without touching the red enemies!", width/2, height/2 - 30);
  text("← → - Move smoothly |  SPACE - Jump", width/2, height/2 + 10);
  text("ENEMIES: 8 bouncing enemies | LIVES: 3", width/2, height/2 + 40);
  
  // Start prompt
  fill(100, 200, 100);
  textSize(24);
  text("PRESS ENTER TO START", width/2, height - 80);
  
  
}

void drawGameplay() {

  background(240, 245, 255);
  
  
  updatePlayerPhysics();
 
  updateEnemies();

  checkCollisions();
  
  checkWinCondition();

  drawGround();
  drawPlayer();
  drawEnemies();
  drawUI();
}


// UPDATE PLAYER PHYSICS (Acceleration + Friction + Gravity)

void updatePlayerPhysics() {
  // HORIZONTAL MOVEMENT (Acceleration + Friction) 
  if (keyPressed) {
    if (keyCode == RIGHT) {
      vx += accel;      // Accelerate right
    }
    if (keyCode == LEFT) {
      vx -= accel;      // Accelerate left
    }
  }
  
  // Apply friction (gradually slows down)
  vx *= friction;
  
  // Limit maximum horizontal speed 
  vx = constrain(vx, -12, 12);
  
  //VERTICAL MOVEMENT (Gravity) 
  vy += gravity;        // Gravity pulls down
  
  // Update position using velocity
  px += vx;
  py += vy;
  
  //  GROUND COLLISION 
  if (py + pR > groundY) {
    py = groundY - pR;  // Place player on ground
    vy = 0;              // Stop falling
  }
  
  //  CEILING COLLISION (prevent jumping through ceiling) 
  if (py - pR < 0) {
    py = pR;
    vy = 0;
  }
  
  //  WALL COLLISION (keep player inside screen) 
  px = constrain(px, pR, width - pR);
}




void updateEnemies() {
  for (int i = 0; i < enemyCount; i++) {
    // Move enemies
    ex[i] += evx[i];
    ey[i] += evy[i];
    
    // Bounce off walls (horizontal)
    if (ex[i] > width - eR) {
      ex[i] = width - eR;
      evx[i] *= -1;
    }
    if (ex[i] < eR) {
      ex[i] = eR;
      evx[i] *= -1;
    }
    
    // Bounce off walls (vertical)
    if (ey[i] > height - eR) {
      ey[i] = height - eR;
      evy[i] *= -1;
    }
    if (ey[i] < eR) {
      ey[i] = eR;
      evy[i] *= -1;
    }
  }
}


void checkCollisions() {
  // Only check if player can be hit 
  if (canHit) {
    for (int i = 0; i < enemyCount; i++) {
      // Calculate distance between player and enemy
      float d = dist(px, py, ex[i], ey[i]);
      
      // If touching an enemy
      if (d < pR + eR) {
        // Lose one life
        lives--;
        
        // Start hit cooldown
        canHit = false;
        lastHitTime = millis();
        flashTimer = 10;  // Flash effect duration
        
        // Check if game over
        if (lives <= 0) {
          state = 2;  // Game Over
        }
        
        // Break out of loop (only one hit per frame)
        break;
      }
    }
  } else {
    // Cooldown: check if enough time has passed
    if (millis() - lastHitTime > hitCooldownMs) {
      canHit = true;
    }
  }
}


// CHECK WIN CONDITION 

void checkWinCondition() {
  int elapsedSeconds = (millis() - startTime) / 1000;
  
  if (elapsedSeconds >= gameDuration) {
    state = 3;  // Win screen!
  }
}

// DRAW GROUND

void drawGround() {
 
  fill(100, 80, 60);
  noStroke();
  rect(0, groundY, width, height - groundY);
  
  // Ground edge highlight
  stroke(150, 120, 90);
  strokeWeight(2);
  line(0, groundY, width, groundY);
  noStroke();
}


// DRAW PLAYER (with hit flash effect)

void drawPlayer() {
  // Flash effect when hit 
  if (flashTimer > 0) {
    fill(255, 255, 255);
    flashTimer--;
  } else {
    fill(60, 120, 220);  // Normal blue
  }
  
  noStroke();
  ellipse(px, py, pR * 2, pR * 2);
  
}


void drawEnemies() {
  for (int i = 0; i < enemyCount; i++) {
    // Gradient effect for enemies
    fill(255, 90, 120);
    ellipse(ex[i], ey[i], eR * 2, eR * 2);
    
    // Inner glow
    fill(255, 150, 170, 150);
    ellipse(ex[i], ey[i], eR * 1.2, eR * 1.2);
    
  }
}


void drawUI() {
  // Calculate elapsed time
  int elapsed = (millis() - startTime) / 1000;
  int remaining = max(0, gameDuration - elapsed);
  
  // Draw lives as o
  textAlign(LEFT, TOP);
  textSize(20);
  fill(200, 50, 50);
  for (int i = 0; i < lives; i++) {
    text("o", 15 + i * 30, 15);
  }
  
  // Draw timer
  fill(50, 50, 80);
  textSize(24);
  textAlign(RIGHT, TOP);
  text("Time: " + remaining + "s", width - 20, 15);
  
  // Draw instructions
  textSize(12);
  fill(150);
  textAlign(CENTER, BOTTOM);
  text("← → to move | SPACE to jump | Survive 30 seconds!", width/2, height - 10);
  
  // Draw hit cooldown indicator 
  if (!canHit) {
    fill(255, 0, 0, 100);
    noStroke();
    ellipse(px, py, pR * 2.5, pR * 2.5);
  }
}


// GAME OVER SCREEN

void drawGameOverScreen() {
  background(30, 20, 30);
  
  textAlign(CENTER, CENTER);
  textFont(titleFont);
  fill(255, 80, 80);
  text("GAME OVER", width/2, height/3);
  
  textFont(createFont("Arial", 20, true));
  fill(200);
  text("You were caught by the enemies!", width/2, height/2);
  
  fill(100, 200, 100);
  textSize(18);
  text("Press 'R' to Restart", width/2, height - 100);
}


// WIN SCREEN

void drawWinScreen() {
  background(30, 50, 30);
  
  textAlign(CENTER, CENTER);
  textFont(titleFont);
  fill(100, 255, 100);
  text("YOU WIN!", width/2, height/3);
  
  textFont(createFont("Arial", 20, true));
  fill(200);
  text("Congratulations! You survived 30 seconds!", width/2, height/2);
  text("Time survived: " + gameDuration + " seconds", width/2, height/2 + 40);
  
  fill(100, 200, 100);
  textSize(18);
  text("Press 'R' to Play Again", width/2, height - 100);
}



void keyPressed() {
  // SPACE to jump 
  if (state == 1 && key == ' ' && py + pR >= groundY - 1) {
    vy = jumpForce;
  }
  
  // ENTER to start game
  if (state == 0 && keyCode == ENTER) {
    startGame();
  }
  
  // R to restart 
  if ((state == 2 || state == 3) && (key == 'r' || key == 'R')) {
    startGame();
  }
}


void startGame() {
  // Reset game state
  state = 1;
  lives = 3;
  canHit = true;
  
  // Reset player
  px = width / 2;
  py = groundY - pR;
  vx = 0;
  vy = 0;
  
  // Reset enemies
  initEnemies();
  
  // Reset timer
  startTime = millis();
  
  // Reset cooldown
  lastHitTime = 0;
  flashTimer = 0;
}
