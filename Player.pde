public class Player extends AnimatedSprite {
  int lives;
  int money;
  int iFrames; //invicibility frames, avoids the problem of the player losing all their lives at once when touching an enemy
  int slashCooldown;
  boolean alreadyIdle;
  boolean onPlatform;
  boolean previouslyOnPlatform;
  boolean jumpingImagesUsed;
  //boolean idleSwitchPossible = false;
  
  public Player(String fileName, float x, float y, int spriteSizeX, int spriteSizeY) {
    super(fileName, x, y, spriteSizeX, spriteSizeY);
    
    neutralRightImages = new PImage[1];
    neutralRightImages[0] = loadImage("playerNeutralRight.png");
    neutralLeftImages = new PImage[1];
    neutralLeftImages[0] = loadImage("playerNeutralLeft.png");
    jumpingRightImages = new PImage[1];
    jumpingRightImages[0] = loadImage("playerJumpingRight.png");
    jumpingLeftImages = new PImage[1];
    jumpingLeftImages[0] = loadImage("playerJumpingLeft.png");
    movingRightImages = new PImage[6];
    movingRightImages[0] = loadImage("playerRight1.png");
    movingRightImages[1] = loadImage("playerRight2.png");
    movingRightImages[2] = loadImage("playerRight3.png");
    movingRightImages[3] = loadImage("playerRight4.png");
    movingRightImages[4] = loadImage("playerRight5.png");
    movingRightImages[5] = loadImage("playerRight6.png");
    movingLeftImages = new PImage[6];
    movingLeftImages[0] = loadImage("playerLeft1.png");
    movingLeftImages[1] = loadImage("playerLeft2.png");
    movingLeftImages[2] = loadImage("playerLeft3.png");
    movingLeftImages[3] = loadImage("playerLeft4.png");
    movingLeftImages[4] = loadImage("playerLeft5.png");
    movingLeftImages[5] = loadImage("playerLeft6.png");
    currentImages = movingLeftImages;
    
    direction = true;
    lives = 5;
    money = 0;
    iFrames = 0;
    slashCooldown = 0;
    onPlatform = false;
    previouslyOnPlatform = false;
    jumpingImagesUsed = true;
  }
  
  @Override
  public void selectCurrentImage() {
    if((onPlatform == false) && (previouslyOnPlatform == true)) {
      previouslyOnPlatform = false;
      if((direction == true) && (speedX > 0)) {
          currentImages = jumpingRightImages;
          idle = false;
          jumpingImagesUsed = true;
        }
        else if((direction == false) && (speedX < 0)) {
          currentImages = jumpingLeftImages;
          idle = false;
          jumpingImagesUsed = true;
        }
        else if(direction == true) {
          currentImages = neutralRightImages;
          idle = true;
          jumpingImagesUsed = false;
        }
        else {
          currentImages = neutralLeftImages;
          idle = true;
          jumpingImagesUsed = false;
        }
    }
    else if(onPlatform == false) {
      if(jumpingImagesUsed == true) {
        if((direction == true)) {
          currentImages = jumpingRightImages;
        }
        else if((direction == false)) {
          currentImages = jumpingLeftImages;
        }
      }
      else {
        if((direction == true)) {
          currentImages = neutralRightImages;
        }
        else if((direction == false)) {
          currentImages = neutralLeftImages;
        }
      }
    }
    else if(onPlatform == true) {
      previouslyOnPlatform = true;
      if((direction == true) && (speedX > 0)) {
        currentImages = movingRightImages;
        idle = false;
      }
      else if((direction == false) && (speedX < 0)) {
        currentImages = movingLeftImages;
        idle = false;
      }
      else {
        if(direction == true) {
          currentImages = neutralRightImages;
        }
        else {
          currentImages = neutralLeftImages;
        }
        idle = true;
      }
    }
  }
  
  void displayCharacter() {
    //different function due to the hitbox of the character not aligning with the image
    if(direction == true) {
      //rect(centreX - sizeX/2, centreY - sizeY/2, sizeX, sizeY);
      image(image, centreX - sizeX/2 - 40, centreY - sizeY/2, sizeX + 40, sizeY);
    }
    else {
      //rect(centreX - sizeX/2, centreY - sizeY/2, sizeX, sizeY);
      image(image, centreX - sizeX/2, centreY - sizeY/2, sizeX + 40, sizeY);
    }
  }
  
  //changing the hitbox of the player if they are idle
  void checkAndChangeHitbox() {
    if((idle == true) && (alreadyIdle == false)) {
      sizeY = sizeY + 40;
      sizeX = sizeX - 80;
      //if(direction == true) {
      //  setRight(centreX + 80);
      //}
      //else {
      //  setLeft(centreX - 80);
      //}
      alreadyIdle = true;
    }
    else if((idle == false) && (alreadyIdle == true)) {
      sizeY = sizeY - 40;
      sizeX = sizeX + 80;
      setBottom(centreY + 50);
      //if(direction == true) {
      //  setRight(centreX - 80);
      //}
      //else {
      //  setLeft(centreX + 80);
      //}
      alreadyIdle = false;
    }
  }
}
