void setup() {
  size(500, 500);
  noStroke();
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
  private float[] coords;
  private double magnitude = 2;
  private float direction; // radians
  private final color colour;
  public Bacteria(int x, int y) {
    this.coords = new float[]{x,y};
    this.direction = (float)Math.atan((this.coords[1]-mouseY)/(this.coords[0]-mouseX));
    this.colour = (int)Math.round(Math.random()*0xffffff) & 0x00ffffff | 0xff000000;
  }
  
  public boolean check() {
    if (Math.abs(this.coords[0]-mouseX) <= 10 && Math.abs(this.coords[1]-mouseY) <= 10) {
      instances.remove(this);
      return true;
    }
    return false;
  }
  
  public void update() {
    this.direction += Math.atan((this.coords[1]-mouseY)/(this.coords[0]-mouseX));
    //this.direction += (this.direction > TWO_PI ? -1 : this.direction < 0 ? 1 : 0) * Math.floor(this.direction/TWO_PI)*TWO_PI;
    this.coords[0] += this.magnitude*Math.cos(this.direction);
    this.coords[1] += this.magnitude*Math.sin(this.direction);
  }
  
  public void draw() {
    pushMatrix();
    translate(this.coords[0], this.coords[1]);
    rotate(this.direction);
    fill(this.colour);
    ellipse(0, 0, 12, 8);
    popMatrix();
  }
}
