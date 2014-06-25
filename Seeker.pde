class Seeker {
  PVector position;
  float accelRate, radius;
  PVector velocity = new PVector(0, 0);
  color fillColor;
  float rnd;
  float maxVelocity = 16, minAccel = 0.3, maxAccel = 2.8;
  int shapeType = 0;

  Seeker(PVector pos) {
    colorMode(HSB, 255);
    position = pos;
    rnd = random(1);
    fillColor = color((int) (rnd*255), 180, 255);;
  }

  void update(PVector target, float distanceScale) {
    maxVelocity = distanceScale;
  
    accelRate = map(rnd, 0, 1, minAccel, maxAccel);
    target.sub(position);
    target.normalize();
    target.mult(accelRate);
    velocity.add(target);
    velocity.limit(maxVelocity);

    position.add(velocity);
  }

  void display(float distanceOfHands) {
    fill(fillColor);
    radius = sq(map(velocity.mag(), 0, maxVelocity, 4, 1)) *distanceOfHands;
    if (shapeType == 0) {
      rect(position.x, position.y, radius, radius);
    }
    else {
      ellipse(position.x, position.y, radius, radius);
    }
  }
}

