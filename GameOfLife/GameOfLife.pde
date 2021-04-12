//credits:
//https://processing.org/examples/gameoflife.html


final int ALIVE = 1;
final int DEAD = 0;

int fps = 10;
int cellSize = 25;
int[][] curr_state;
int[][] next_state;
boolean pause = true;

color color_dead = color(0);
color color_alive = color(0, 255, 0);

void setup() {
  size (800, 600);

  curr_state = new int[height/cellSize][width/cellSize];
  next_state = new int[height/cellSize][width/cellSize];
  
  seed();
  stroke(48);
  frameRate(fps);
}

void draw() {
  background(0);
  for (int i = 0; i < curr_state.length; ++i) {
    for (int j = 0; j < curr_state[i].length; ++j) {
      if (curr_state[i][j] == ALIVE) {
        fill(color_alive);
      } else {
        fill(color_dead);
      }
      rect(j*cellSize, i*cellSize, cellSize, cellSize);
    }
  }
  if (!pause) {
    travel_time();
  }
}

void travel_time() {
  int[][] deltas = {{-1, -1}, {-1, 0}, {-1, 1}, {0, -1}, {0, 1}, {1, -1}, {1, 0}, {1, 1}};
  for (int i = 0; i < curr_state.length; ++i) {
    for (int j = 0; j < curr_state[i].length; ++j) {
      int neighbours = 0;
      for (int k = 0; k < deltas.length; ++k) {
        int x = j + deltas[k][1];
        int y = i + deltas[k][0];
        if (0 <= y && y < curr_state.length && 0 <= x && x < curr_state[i].length) {
           neighbours += curr_state[y][x];
        }
      }
      if (curr_state[i][j] == ALIVE && (neighbours < 2 || neighbours > 3)) {
        next_state[i][j] = DEAD;
      } else if (curr_state[i][j] == DEAD && neighbours == 3) {
        next_state[i][j] = ALIVE;
      } else {
        next_state[i][j] = curr_state[i][j];
      }
    }
  }
  for (int i = 0; i < curr_state.length; ++i) {
    for (int j = 0; j < curr_state[i].length; ++j) {
      curr_state[i][j] = next_state[i][j];
    }
  }
}

void seed() {
  int ancho = (int) width/cellSize;
  int alto = (int) height/cellSize;
  int cont = (int) random(ancho*alto);
  for (int k = 0; k < cont; ++k) {
    int pos = (int) random(ancho*alto);
    int y = (int) pos/ancho;
    int x = (int) pos%ancho;
    curr_state[y][x] = ALIVE;
  }
}

void clear_grid() {
  for (int i = 0; i < curr_state.length; ++i) {
    for (int j = 0; j < curr_state[i].length; ++j) {
      curr_state[i][j] = DEAD;
    }
  }
}

void mousePressed() {
  if (mouseButton == LEFT && pause) {
    int i = int(mouseY/cellSize);
    int j = int(mouseX/cellSize);
    curr_state[i][j] = 1-curr_state[i][j];
  }
}

void keyPressed() {
  if (key == ' ') {
    pause = !pause;
  }
  if (key == 'a') {
    clear_grid();
    seed();
  }
  if (key == 'c' || key == 'C') {
    clear_grid();
  }
  if (key == 'w' || key == 's') {
    int delta = key == 'w' ? 1 : -1;
    fps += delta;
    if (fps < 1 || fps > 120) fps -= delta;
    frameRate(fps);
  }
}
