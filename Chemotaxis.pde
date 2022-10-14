void setup() {
  size(500, 500);
  instances.add(new Bacteria(250, 250));
  instances.add(new Bacteria(250, 250));
}
void draw() {
  background(0);
  for (Bacteria b : instances) b.update();
 	for (Bacteria b : instances) b.draw();
}
void mouseClicked() {
  boolean dirty = false;
  for (Bacteria b : new ArrayList<Bacteria>(instances)) 
    dirty = dirty || b.check();
  if (!dirty) instances.add(new Bacteria(250, 250));
}

private static java.util.List<Bacteria> instances = new ArrayList<Bacteria>();
class Bacteria {
  private final int hitbox = 12;
  private float[] coords;
  private float direction; // radians
  private final color colour;
  public Bacteria(int x, int y) {
    this.coords = new float[]{x,y};
    this.direction = (float)Math.atan((this.coords[1]-mouseY)/(this.coords[0]-mouseX));
    this.colour = (int)Math.round(Math.random()*0xffffff) & 0x00ffffff | 0xff000000;
  }
  
  public boolean check() {
    if (Math.abs(this.coords[0]-mouseX) <= this.hitbox && Math.abs(this.coords[1]-mouseY) <= this.hitbox) {
      instances.remove(this);
      return true;
    }
    return false;
  }
  
  public void update() {
    this.direction = (float)(Math.atan((mouseY-this.coords[1])/(mouseX-this.coords[0])) + (mouseX > this.coords[0] ? PI : 0));
    double distance = Math.sqrt( Math.pow(this.coords[1]-mouseY, 2) + Math.pow((this.coords[0]-mouseX), 2));
    double magnitude = Math.pow(Math.max(700 - distance, 1), 1/5d);
    this.coords[0] += magnitude*Math.cos(this.direction);
    this.coords[1] += magnitude*Math.sin(this.direction);
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
}
