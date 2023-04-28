public class SimpleEnemy extends AnimatedSprite {
  int leftMovementBoundary;
  int rightMovementBoundary;
  int mouseLives;
  
  public SimpleEnemy(String fileName, float x, float y, int spriteSizeX, int spriteSizeY, int bLeft, int bRight) {
    super(fileName, x, y, spriteSizeX, spriteSizeY);
    
    movingRightImages = new PImage[1];
    movingRightImages[0] = loadImage("mouseEnemyRight.png");
    movingLeftImages = new PImage[1];
    movingLeftImages[0] = loadImage("mouseEnemyLeft.png");
    currentImages = movingLeftImages;
    direction = false;
    
    leftMovementBoundary = bLeft;
    rightMovementBoundary = bRight;
    speedX = -3;
    mouseLives = 5;
  }
  
  void updateSimpleEnemy() {
    centreX = centreX + speedX;
    if(getLeft() <= leftMovementBoundary) {
      setLeft(leftMovementBoundary);
      speedX = speedX * -1;
    }
    else if(getRight() >= rightMovementBoundary) {
      setRight(rightMovementBoundary);
      speedX = speedX * -1;
    }
  }
}
