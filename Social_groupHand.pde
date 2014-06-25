ArrayList<Particles> userSet;

import SimpleOpenNI.*;
PVector com = new PVector();                                   
PVector com2d = new PVector(); 
float posX;
float posY;
float posZ;
boolean clearBG;

SimpleOpenNI  context;

void setup() {
  size(1280, 960, P3D);

  context = new SimpleOpenNI(this);
  if (context.isInit() == false)
  {
    println("Can't init SimpleOpenNI, maybe the camera is not connected!"); 
    exit();
    return;
  }
  context.enableDepth();
  context.enableUser();

  userSet = new ArrayList();
}

void draw() {

    background(#000000);
  context.update();

  /*
  pushMatrix();
   colorMode(RGB);
   scale(2);
   image(context.depthImage(), 0, 0);
   colorMode(HSB, 255);
   popMatrix();
   */

  int[] userList = context.getUsers();
  for (int i=0;i<userList.length;i++)
  {

    // get 3D position of a joint
    PVector jointPos = new PVector();
    context.getJointPositionSkeleton(userList[i], SimpleOpenNI.SKEL_TORSO, jointPos);

    // convert real world point to projective space
    PVector jointPos_Proj = new PVector(); 
    context.convertRealWorldToProjective(jointPos, jointPos_Proj);

    PVector jointPosLeftHand = new PVector();
    PVector jointPosRightHand = new PVector();
    PVector jointPos_ProjLeftHand = new PVector(); 
    PVector jointPos_ProjRightHand = new PVector(); 
    context.getJointPositionSkeleton(userList[i], SimpleOpenNI.SKEL_LEFT_HAND, jointPosLeftHand);
    context.getJointPositionSkeleton(userList[i], SimpleOpenNI.SKEL_RIGHT_HAND, jointPosRightHand);
    context.convertRealWorldToProjective(jointPosLeftHand, jointPos_ProjLeftHand);
    context.convertRealWorldToProjective(jointPosRightHand, jointPos_ProjRightHand);

    //get width factor of hands 
    float distanceOfHands = jointPos_ProjRightHand.x - jointPos_ProjLeftHand.x;
    distanceOfHands = map(distanceOfHands, 0, 500, 1, 5 );
    if (distanceOfHands<=0) distanceOfHands =1;

    //get body position
    if ( context.getCoM(userList[i], com) )
    {
      context.convertRealWorldToProjective(com, com2d);
    } 

    posX = width- jointPos_ProjLeftHand.x;
    posY = jointPos_ProjLeftHand.y *2;
    posZ = com.z;

    float distanceScale = map(posZ, 0, 8000, 16, 25);

    if (Float.isNaN(posY) || posY<=0 || posY >= height -10) posY=height/2;
    if (Float.isNaN(posX) || posX<=0 || posX >= width -10) posX=width/2;

    for (int j=0; j<userSet.size(); j++) {
      Particles ip = (Particles)userSet.get(j);
      if (ip.userid == userList[i]) {
        ip.display( new PVector(posX, posY), distanceOfHands, distanceScale);
        //ellipse(posX, posY *2, 50, 50);
      }
    }
  }
}

void onNewUser(SimpleOpenNI curContext, int userId)
{
  println("onNewUser - userId: " + userId);
  curContext.startTrackingSkeleton(userId);

  userSet.add( new Particles( userId) );
}

void onLostUser(SimpleOpenNI curContext, int userId)
{
  println("onLostUser - userId: " + userId);

  //remove lost user's paddle
  for (int i=0; i<userSet.size(); i++) {
    Particles ip = (Particles)userSet.get(i);
    if (ip.userid == userId)
      userSet.remove(i);
  }
}

void onVisibleUser(SimpleOpenNI curContext, int userId)
{
  //println("onVisibleUser - userId: " + userId);
}



boolean sketchFullScreen() {
  return true;
}
