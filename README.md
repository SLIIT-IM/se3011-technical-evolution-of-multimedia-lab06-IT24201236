[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-22041afd0340ce965d47ae6ef1cefeee28c7c493a6346c4f15d667ab976d596c.svg)](https://classroom.github.com/a/aafjf78V)
[![Open in Visual Studio Code](https://classroom.github.com/assets/open-in-vscode-2e0aaae1b6195c2367325f4f02e2d04e9abb55f0b24a779b69b11b9e10269abc.svg)](https://classroom.github.com/online_ide?assignment_repo_id=23382345&assignment_repo_type=AssignmentRepo)
# SE3011-Technical-Evolution-of-Multimedia-Lab06

# In-Class Lab  — Processing  
# Animation Basics Part 02 

**Theme:** Advanced motion + interaction (still beginner-friendly)  
**Final Outcome:** A mini game **“Dodge & Survive”**

---

## How to Use This Lab Sheet 

For each activity:

1. **Create a new sketch** in Processing (**File → New**)
2. **Copy-paste the full code**
3. Click **Run**
4. Compare with the **Expected Output**
5. Do at least **one mini challenge** if you finish early

---

## Quick Basics

### Why animation works in Processing

- `setup()` runs **once** (initialize things)
- `draw()` runs **repeatedly** (updates & redraws)

Movement happens because:

- We store position in variables (`x`, `y`)
- We change position each frame inside `draw()`


---

# Activity 1 — Velocity Movement (Full Code + Reasons)

##  Goal
Move a ball left/right using **velocity** and bounce at the edges of the window.

---

##  Key Ideas (What these mean)

### 1) `x` (Position)
- `x` stores the ball’s **horizontal position** (where it is left-to-right).
- If `x` changes every frame, the ball will move.

### 2) `vx` (Velocity)
- `vx` stores the ball’s **horizontal speed and direction**.
- If `vx` is positive → ball moves right  
- If `vx` is negative → ball moves left

### 3) `r` (Radius)
- The ball is drawn using `ellipse(x, y, w, h)`
- If width/height is 40, radius is 20.
- We use radius in edge checks so the ball does not go half outside the window.

### 4) `if` statement (Decision)
- `if` checks a condition.
- We use it to detect if the ball reaches the left/right wall.
- When it reaches a wall, we reverse direction.

---

##  Full Code (Copy-Paste)

```java
// Activity 1: Velocity Movement (Full Code)

float x = 200;   // ball's horizontal position (left-to-right)
float vx = 4;    // ball's horizontal velocity (speed + direction)
float r = 20;    // radius of the ball (half of its size)

void setup() {
  size(700, 350);          // create window
  frameRate(60);           // smoother animation (optional)
}

void draw() {
  background(255);         // clear old frame (white)

  // 1) UPDATE POSITION USING VELOCITY
  // Why? Movement happens when position changes each frame.
  x = x + vx;

  // 2) EDGE CHECK (BOUNCE)
  // Why use r? So the ball edge touches the wall, not the center.
  if (x > width - r || x < r) {
    vx = vx * -1;          // reverse direction
  }

  // 3) DRAW THE BALL
  noStroke();
  fill(60, 120, 255);
  ellipse(x, height/2, r*2, r*2);

  // 4) DEBUG TEXT (helps you understand values)
  fill(0);
  textSize(16);
  text("x = " + nf(x, 1, 1) + "   vx = " + nf(vx, 1, 1), 20, 25);
}
```

---

##  Expected Output (What you should see)

- A blue ball moving left and right
- The ball bounces when it reaches the edges
- The text shows `x` and `vx`

---

##  Mini Challenges (Do at least ONE)

1. Change `vx` to `8` (faster) or `2` (slower)
2. Change the ball size by changing `r`
3. Make the ball move diagonally by adding `y` and `vy` (try after Activity 3)

---

---

#  Activity 2  — Acceleration + Friction (Full Code + Reasons)

##  Goal
Move a player smoothly:
- When you **hold RIGHT or LEFT**, the player speeds up gradually.
- When you **release the key**, the player slows down gradually.

This creates smooth, realistic movement instead of robotic movement.

---

##  Key Ideas (Understand Before Running)

###  `px` — Player Position
```java
float px = 350;
```
- Stores the player's horizontal position.
- If `px` changes → the player moves.

---

###  `vx` — Velocity
```java
float vx = 0;
```
- Stores horizontal speed.
- Starts at `0` because the player is not moving at the beginning.

Instead of moving position directly:
```java
px += 5;   //  robotic movement
```

We change velocity:
```java
vx += accel;
px += vx;
```

This creates smooth motion.

---

###  `accel` — Acceleration
```java
float accel = 0.6;
```
- Controls how fast speed increases.
- Higher value = faster acceleration.

---

###  `friction` — Slowing Down Effect
```java
float friction = 0.90;
```
- Every frame, we multiply velocity by 0.90.
- That means we keep only 90% of the speed.
- So velocity slowly reduces to zero.

Without friction → player never stops sliding.

---

###  `if` Statements (Decision Making)
```java
if (keyCode == RIGHT)
```
- Only increases velocity if RIGHT key is pressed.
- `if` means: do something only when condition is true.

---

###  `constrain()` — Keep Player Inside Screen
```java
px = constrain(px, r, width - r);
```
- Prevents player from going outside window.
- Uses radius `r` to keep full circle inside.

---

##  Full Code (Copy-Paste)

```java
// Activity 2: Acceleration + Friction (Full Code)

float px = 350;         // player horizontal position
float vx = 0;           // player horizontal velocity (speed)

float accel = 0.6;      // acceleration (how fast speed increases)
float friction = 0.90;  // friction (how quickly speed reduces)
float r = 20;           // radius (player size is 40)

void setup() {
  size(700, 350);       // create window
  frameRate(60);        // smooth animation
}

void draw() {
  background(240);      // clear screen each frame

  //  INPUT CHANGES VELOCITY (ACCELERATION)
  // We change velocity, not position directly.
  if (keyPressed) {
    if (keyCode == RIGHT) {
      vx = vx + accel;
    }
    if (keyCode == LEFT) {
      vx = vx - accel;
    }
  }

  //  APPLY FRICTION
  // Gradually reduces velocity every frame.
  vx = vx * friction;

  //  UPDATE POSITION
  px = px + vx;

  //  KEEP PLAYER INSIDE WINDOW
  px = constrain(px, r, width - r);

  //  DRAW PLAYER
  noStroke();
  fill(80, 160, 255);
  ellipse(px, height/2, r*2, r*2);

  //  SHOW DEBUG INFO
  fill(0);
  textSize(16);
  text("vx = " + nf(vx, 1, 2), 20, 25);
  text("Hold LEFT / RIGHT keys", 20, 45);
}
```

---

##  Expected Output

- Hold RIGHT → player speeds up smoothly.
- Release key → player slowly stops.
- Hold LEFT → moves smoothly in opposite direction.

---

##  Mini Challenges (Do At Least ONE)

1. Change `accel` to `1.0` → what happens?
2. Change `friction` to `0.95` → more slippery?
3. Change `friction` to `0.80` → stops faster?
4. Add vertical movement using `vy` (advanced attempt).

---


---

#  Activity 3  — Gravity + Jump (Full Code + Reasons)

##  Goal
Make a ball fall down due to gravity and jump when SPACE is pressed — similar to a simple platform game.

---

##  Key Ideas (Understand Before Running)

###  `y` — Vertical Position
```java
float y = 50;
```
- Stores the ball’s vertical position.
- Smaller `y` = higher on screen.
- Larger `y` = lower on screen.
- If `y` changes → the ball moves up or down.

---

###  `vy` — Vertical Velocity
```java
float vy = 0;
```
- Stores vertical speed.
- Positive `vy` → moves down.
- Negative `vy` → moves up.
- Starts at 0 because ball is not moving at beginning.

---

###  Gravity
```java
float gravity = 0.6;
```
Gravity increases `vy` every frame:

```java
vy = vy + gravity;
```

Why?
Because gravity constantly pulls objects downward.
This makes falling feel realistic (speed increases while falling).

---

###  Jump Force
```java
float jumpForce = -12;
```
Why negative?
In Processing:
- Down is positive Y
- Up is negative Y

So to move upward, we must use a negative value.

---

###  Ground Detection
```java
if (y > groundY)
```
Without this:
- The ball would fall forever.
- It would disappear off the screen.

We reset:
```java
y = groundY;
vy = 0;
```
This stops the ball at the ground.

---

###  `keyPressed()` Function
```java
void keyPressed()
```
This function runs once when a key is pressed.

We use:
```java
if (key == ' ')
```
To detect the SPACE key.

---

##  Full Code (Copy-Paste)

```java
// Activity 3: Gravity + Jump (Full Code)

float x = 350;        // fixed horizontal position
float y = 50;         // vertical position (starts near top)
float vy = 0;         // vertical velocity

float gravity = 0.6;  // gravity strength
float jumpForce = -12; // jump strength (negative = upward)

float r = 20;         // radius of ball
float groundY = 300;  // vertical position of the ground

void setup() {
  size(700, 350);     // create window
  frameRate(60);      // smooth animation
}

void draw() {
  background(255);    // clear screen

  //  APPLY GRAVITY
  // Every frame gravity increases downward speed
  vy = vy + gravity;

  //  UPDATE POSITION
  y = y + vy;

  //  GROUND COLLISION
  // Stop falling when touching the ground
  if (y > groundY) {
    y = groundY;  // place ball exactly on ground
    vy = 0;       // stop downward movement
  }

  // Draw ground line (visual reference)
  stroke(0);
  line(0, groundY + r, width, groundY + r);

  // Draw ball
  noStroke();
  fill(90, 200, 130);
  ellipse(x, y, r*2, r*2);

  // Instructions text
  fill(0);
  textSize(16);
  text("Press SPACE to jump", 20, 25);
}

void keyPressed() {
  // Allow jump only when on the ground
  if (key == ' ' && y == groundY) {
    vy = jumpForce;
  }
}
```

---

##  Expected Output

- Ball falls down naturally.
- Ball stops when it reaches the ground.
- Press SPACE → ball jumps.
- Ball falls back down again.

---

##  Mini Challenges

1. Increase `jumpForce` to `-16` → higher jump.
2. Increase `gravity` to `0.9` → heavier ball.
3. Add horizontal movement using `vx`.
4. Prevent double-jumping by improving the ground check.

---

---

#  Activity 4  — Arrays + Loops (Multiple Enemies)

##  Goal
Create multiple enemies moving on the screen **without writing separate variables for each one**.

Instead of writing:

```java
float ex1, ex2, ex3, ex4, ex5;
```

We will use **arrays** and a **for loop**.

---

#  Key Concepts (Read Carefully)

---

##  What is an Array?

An **array** stores multiple values under one name.

Example:

```java
float[] ex = new float[n];
```

This means:
- `ex` is a list of numbers.
- It can store `n` different x positions.
- We access each one using an index:
  - `ex[0]`
  - `ex[1]`
  - `ex[2]`
  - ...

If `n = 6`, then:
- ex[0] → enemy 0 position
- ex[1] → enemy 1 position
- ...
- ex[5] → enemy 5 position

---

##  Why We Need Arrays

We want:
- Multiple enemies
- Each enemy must have:
  - Its own x position
  - Its own y position
  - Its own x speed
  - Its own y speed

So we create 4 arrays:

```java
float[] ex;   // x positions
float[] ey;   // y positions
float[] evx;  // x speeds
float[] evy;  // y speeds
```

Each index `i` represents one enemy.

---

##  What is a For Loop?

A `for` loop repeats code multiple times.

```java
for (int i = 0; i < n; i++)
```

This means:

- Start with `i = 0`
- Run code while `i < n`
- After each loop, increase `i` by 1

So if `n = 6`, it runs:
- i = 0
- i = 1
- i = 2
- i = 3
- i = 4
- i = 5

Exactly 6 times.

We use this to:
- Initialize enemies
- Move enemies
- Draw enemies
- Check collisions later

---

#  Full Code (Copy-Paste)

```java
// Activity 4: Arrays + Loops (Full Code)

int n = 6;  // number of enemies

// Arrays to store enemy properties
float[] ex = new float[n];   // enemy x positions
float[] ey = new float[n];   // enemy y positions
float[] evx = new float[n];  // enemy x velocities
float[] evy = new float[n];  // enemy y velocities

float eR = 15;  // enemy radius (size = 30)

void setup() {
  size(700, 350);
  frameRate(60);

  // Initialize each enemy using a loop
  // Why? So each enemy gets different random values.
  for (int i = 0; i < n; i++) {

    // Random starting position
    ex[i] = random(eR, width - eR);
    ey[i] = random(eR, height - eR);

    // Random movement speed
    evx[i] = random(-3, 3);
    evy[i] = random(-3, 3);

    // Prevent enemies from being too slow
    if (abs(evx[i]) < 1) {
      evx[i] = 2;
    }

    if (abs(evy[i]) < 1) {
      evy[i] = -2;
    }
  }
}

void draw() {
  background(250);

  // Loop through all enemies
  for (int i = 0; i < n; i++) {

    //  Move enemy
    ex[i] = ex[i] + evx[i];
    ey[i] = ey[i] + evy[i];

    //  Bounce on walls
    if (ex[i] > width - eR || ex[i] < eR) {
      evx[i] = evx[i] * -1;
    }

    if (ey[i] > height - eR || ey[i] < eR) {
      evy[i] = evy[i] * -1;
    }

    //  Draw enemy
    noStroke();
    fill(255, 90, 120);
    ellipse(ex[i], ey[i], eR*2, eR*2);
  }

  fill(0);
  textSize(16);
  text("Enemies created using arrays and loops", 20, 25);
}
```

---

#  What You Should See

- 6 enemies bouncing around.
- Each one moving differently.
- No repeated code blocks for each enemy.

---

#  Mini Challenges

1. Change `n = 10` → what happens?
2. Increase speed range to `random(-5, 5)`
3. Give each enemy a random color.
4. Make enemies grow and shrink.

---


---

#  Activity 5  — Player + Enemies + Collision  
## (Full Code + Detailed Reasons)

---

##  Goal

- Add a **player** that can move using arrow keys.
- Keep the bouncing enemies from Activity 4.
- Detect when the player **touches an enemy**.
- Print `"HIT!"` in the Console when collision happens.

---

#  Key Idea: Collision Using Distance

Two circles touch when:

```
distance between centers < (radius1 + radius2)
```

We calculate distance using Processing’s built-in function:

```java
dist(x1, y1, x2, y2);
```

This returns the distance between two points.

---

#  What Variables We Need (Understand Before Coding)

##  Player Variables

```java
float px, py;
float pR;
```

- `px` → player x position  
- `py` → player y position  
- `pR` → player radius  

Why radius?  
Because collision is based on radius, not diameter.

---

##  Enemy Variables (Arrays)

```java
float[] ex;
float[] ey;
float[] evx;
float[] evy;
```

Each enemy has:
- Position (`ex[i]`, `ey[i]`)
- Velocity (`evx[i]`, `evy[i]`)

We use arrays because:
- We want multiple enemies.
- Writing `ex1, ex2, ex3...` is not practical.

---

##  For Loop

```java
for (int i = 0; i < n; i++)
```

This loop:
- Runs once for each enemy.
- Updates movement.
- Draws enemy.
- Checks collision.

Collision must be **inside this loop**, because we must check each enemy.

---

#  Full Code (Copy-Paste and Run)

```java
// Activity 5: Player + Enemies + Collision (Full Code)

// ---------------- PLAYER ----------------
float px = 350;   // player x position
float py = 175;   // player y position
float pR = 20;    // player radius (size = 40)
float step = 6;   // movement speed

// ---------------- ENEMIES ----------------
int n = 6;  // number of enemies

float[] ex = new float[n];   // enemy x positions
float[] ey = new float[n];   // enemy y positions
float[] evx = new float[n];  // enemy x velocities
float[] evy = new float[n];  // enemy y velocities

float eR = 15;  // enemy radius (size = 30)

void setup() {
  size(700, 350);
  frameRate(60);

  // Initialize enemies with random positions and speeds
  for (int i = 0; i < n; i++) {

    ex[i] = random(eR, width - eR);
    ey[i] = random(eR, height - eR);

    evx[i] = random(-3, 3);
    evy[i] = random(-3, 3);

    // Prevent enemies from being too slow
    if (abs(evx[i]) < 1) evx[i] = 2;
    if (abs(evy[i]) < 1) evy[i] = -2;
  }
}

void draw() {
  background(240);

  // ---------------- PLAYER MOVEMENT ----------------
  // Move only if key is pressed
  if (keyPressed) {
    if (keyCode == RIGHT) px += step;
    if (keyCode == LEFT)  px -= step;
    if (keyCode == DOWN)  py += step;
    if (keyCode == UP)    py -= step;
  }

  // Keep player fully inside window
  px = constrain(px, pR, width - pR);
  py = constrain(py, pR, height - pR);

  // Draw player
  noStroke();
  fill(60, 120, 220);
  ellipse(px, py, pR*2, pR*2);

  // ---------------- ENEMIES LOOP ----------------
  for (int i = 0; i < n; i++) {

    // Move enemy
    ex[i] += evx[i];
    ey[i] += evy[i];

    // Bounce enemy off walls
    if (ex[i] > width - eR || ex[i] < eR) {
      evx[i] *= -1;
    }

    if (ey[i] > height - eR || ey[i] < eR) {
      evy[i] *= -1;
    }

    // Draw enemy
    fill(255, 90, 120);
    ellipse(ex[i], ey[i], eR*2, eR*2);

    // ---------------- COLLISION CHECK ----------------
    // Calculate distance between player and this enemy
    float d = dist(px, py, ex[i], ey[i]);

    // If distance is smaller than sum of radii → collision
    if (d < pR + eR) {
      println("HIT enemy " + i);
    }
  }

  // Instruction text
  fill(0);
  textSize(14);
  text("Move with arrow keys. Touch enemy to see HIT in Console.", 20, 25);
}
```

---

#  What You Should See

- A blue player circle.
- 6 red enemies bouncing.
- When player touches an enemy:
  - `"HIT enemy X"` appears in the Console (bottom window).

---

#  Mini Challenges

1. Change enemy count to `n = 10`.
2. Change collision effect to:
   - Change player color when hit.
3. Add a score counter.
4. Add lives and reduce when collision happens.

---


---

#  FINAL TASK — “Dodge & Survive”  
## (Full Game Code + Detailed Reasons)

---

##  Game Rules

- **ENTER** starts the game  
- **LEFT / RIGHT** moves the player smoothly (**acceleration + friction**)  
- **SPACE** makes the player jump (**gravity**)  
- **8 enemies** bounce around (**arrays + loop**)  
- Touch an enemy → **lose 1 life** (start with **3 lives**)  
- Survive **30 seconds** → **YOU WIN**  
- If lives become **0** → **GAME OVER**  
- On WIN / GAME OVER, press **R** to restart

---

##  What You Must Have (Checklist)

1. Start screen  
2. State system (start / play / game over / win)  
3. Smooth movement (accel + friction)  
4. Jump physics (gravity + jump force)  
5. Multiple enemies using arrays  
6. Collision detection using distance  
7. Lives system  
8. Timer system  
9. Win & Game Over screens  

---

#  Important Variable Meanings (Read Before Coding)

## 1) `state` (Game Mode / Screen)
```java
int state = 0;
```
- `0` = Start screen  
- `1` = Playing screen  
- `2` = Game Over screen  
- `3` = Win screen  

Why?  
Because one sketch can show different screens depending on the state.

---

## 2) Timer Variables
```java
int startTime;
int duration = 30;
```
- `startTime` stores the time when the game started (`millis()`)  
- `duration` is total game time in seconds  

Why use `millis()`?  
Because Processing can measure real time using milliseconds since program started.

---

## 3) Player Variables (Physics Movement)
```java
float px, py;     // position
float vx, vy;     // velocity
float accel;      // acceleration
float friction;   // slowing down
float gravity;    // falling speed increases
float jumpForce;  // upward velocity when jumping
```

Why separate position and velocity?
- Position tells where the player is now.
- Velocity tells how fast player is moving.
- Acceleration changes velocity slowly (smooth movement).

---

## 4) Enemy Arrays (Multiple Enemies)
```java
float[] ex, ey;     // enemy positions
float[] evx, evy;   // enemy velocities
```

Why arrays?
Because we need 8 enemies, and each one needs its own position and speed.

---

## 5) Collision Variables
```java
float d = dist(px, py, ex[i], ey[i]);
if (d < pR + eR) ...
```

Why distance?
Two circles touch when the distance between centers is less than the sum of radii.

---

## 6) Hit Cooldown
```java
boolean canHit = true;
int hitCooldownMs = 800;
```

Why?  
Without cooldown, when player touches an enemy, the collision is true for many frames → player loses all 3 lives instantly.

Cooldown makes it lose only **1 life per hit**.




---

##  Expected Output

- Start screen appears first  
- Press ENTER → game starts  
- Player slides smoothly (accel + friction)  
- SPACE jumps  
- Enemies bounce around  
- Touch enemy → lives decrease by 1  
- Survive 30 seconds → WIN screen  
- Lose all lives → GAME OVER screen  
- Press R to restart  

---

##  Mini Challenges (Optional)

1. Increase difficulty: every 10 seconds multiply enemy speed by 1.2  
2. Add score: score increases every second survived  
3. Add a “safe zone” at the bottom where enemies can’t enter  
4. Add a second jump (double jump)  



---

<!-- ===================== GOOD LUCK FOOTER (CREATIVE) ===================== -->

<div align="center">

##  Good Luck, Creator! 

<!-- Animated typing headline -->
<img src="https://readme-typing-svg.demolab.com/?lines=GOOD+LUCK+STUDENTS!;You+can+do+this!;Animation+%3D+Math+%2B+Creativity;Build+your+own+mini+game+today!&center=true&width=720&height=55&size=26" />

<br><br>

<!-- Fun animated divider -->
<img src="https://capsule-render.vercel.app/api?type=waving&color=0:36d1dc,100:5b86e5&height=120&section=header&text=%20&fontSize=0" />

</div>

---

<div align="center">

###  You Just Unlocked These Skills

 Velocity (move with speed)  
 Acceleration + Friction (smooth control)  
 Gravity + Jump (platform physics)  
 Arrays + Loops (many enemies)  
 Collision Detection (touch = event)  
 States + Timer + Lives (real game logic)

</div>

---

<div align="center">


```text
✨  *  ✨     *      ✨   *    ✨
   *     ✨     *        *  
✨     *     🎉  GOOD LUCK!  🎉    *   ✨
   *       *       ✨      *    
✨  *   ✨     *     ✨   *    ✨
```

</div>

---

<div align="center">

###  Your Final Mission
**Don’t aim for perfect — aim for progress.**  
Try **one small improvement** after you finish:

 Add a score  
 Add difficulty over time  
 Add a new enemy type  
 Add a new player skin (shape/design)  
 Add particles / trails  

</div>

---

<div align="center">

<!-- Animated bottom wave -->
<img src="https://capsule-render.vercel.app/api?type=waving&color=0:5b86e5,100:36d1dc&height=120&section=footer&text=%20&fontSize=0" />



<br><br>

###  See you in the next lab!

</div>

---



