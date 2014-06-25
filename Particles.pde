class Particles {
  ArrayList<Seeker> balls;
  int userid;
  int ballLimit = 500;
  float radiousControl = 1;
  float maxVelocity = 16, minAccel = 0.8, maxAccel = 1.8;

  Particles(int user) {
    userid = user;

    balls = new ArrayList();

    for (int i=0; i < 400; i++) {
      balls.add( new Seeker(new PVector(random(width), random(height)) ) );
    }
  }

  void display(PVector target, float distanceOfHands, float distanceScale) {
    for (int i=0; i<balls.size(); i++) {
      Seeker is = (Seeker)balls.get(i);
      
      is.update( new PVector(target.x, target.y) , distanceScale );
      is.display( distanceOfHands );
    }
  }
  
}

