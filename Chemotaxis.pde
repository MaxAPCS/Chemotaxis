void setup() {
  size(500, 500);
  colorMode(HSB, 360, 100, 100, 255);
  instances.add(new Bacteria(250, 250));
}
void draw() {
  fill(0x11000000);
  rect(0, 0, 500, 500);
  for (Bacteria b : instances) 
    if (mousePressed && (mouseButton == RIGHT)) {b.wander();} else {b.run();}
 	for (Bacteria b : instances) b.draw();
}
void mouseClicked() {
  if (mouseButton != LEFT) return;
  boolean dirty = false;
  for (Bacteria b : new ArrayList<Bacteria>(instances)) 
    dirty = dirty || b.checkHit();
  if (!dirty) instances.add(new Bacteria(250, 250));
}
public double normalizeRadians(double r) {
  if (r < 0 || r > TWO_PI) r -= Math.floor(r/TWO_PI)*TWO_PI;
  return r;
}

private static java.util.List<Bacteria> instances = new ArrayList<Bacteria>();
class Bacteria {
  private final int hitbox = 14;
  private float[] coords;
  private float direction; // radians
  private final color colour;
  public Bacteria(int x, int y) {
    this.coords = new float[]{x,y};
    this.direction = (float)this.dirToMouse();
    this.colour = color((int)Math.round(Math.random()*255), 255, 255, 255);
  }
  
  public boolean checkHit() {
    if (Math.abs(this.coords[0]-mouseX) <= this.hitbox && Math.abs(this.coords[1]-mouseY) <= this.hitbox) {
      instances.remove(this);
      return true;
    }
    return false;
  }
  
  public void run() {
    this.direction += Math.min(Math.max(normalizeRadians(this.dirToMouse()-this.direction), radians(1)), radians(359));
    double distance = Math.sqrt(Math.pow(this.coords[1]-mouseY, 2) + Math.pow((this.coords[0]-mouseX), 2));
    double magnitude = /*Math.pow(Math.max(700 - distance, 1), 1/6d)*/ Math.pow(700-distance, 1/3f)/3;
    System.out.println(distance+" - "+magnitude);

    this.coords[0] += magnitude*Math.cos(this.direction);
    this.coords[1] += magnitude*Math.sin(this.direction);
    checkBounds();
  }
  
  public void wander() {
    this.direction += Math.random()*QUARTER_PI/4 - QUARTER_PI/8;
    double magnitude = 1;
    this.coords[0] += magnitude*Math.cos(this.direction);
    this.coords[1] += magnitude*Math.sin(this.direction);
    checkBounds();
  }
  
  private void checkBounds() {
    if (this.coords[0] > -20 && this.coords[0] < 520 && this.coords[1] > -20 && this.coords[1] < 520) return;
    this.coords[0] = Math.round(Math.random()*100+200);
    this.coords[1] = Math.round(Math.random()*100+200);
    this.direction = (float)this.dirToMouse();
  }
  
  public void draw() {
    pushMatrix();
    translate(this.coords[0], this.coords[1]);
    rotate(this.direction);
    noStroke();
    fill(this.colour);
    ellipse(0, 0, 16, 10);
    popMatrix();
  }
  
  private double dirToMouse() {
      return Math.atan((mouseY-this.coords[1])/( mouseX-this.coords[0])) + (mouseX > this.coords[0] ? PI : 0);
  }
}
