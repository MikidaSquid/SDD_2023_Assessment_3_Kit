public abstract class AnimatedSprite extends Sprite {
  PImage currentImages[];
  PImage neutralRightImages[];
  PImage neutralLeftImages[];
  PImage jumpingRightImages[];
  PImage jumpingLeftImages[];
  PImage movingRightImages[];
  PImage movingLeftImages[];
  boolean direction; //true is facing right, and false is facing left
  boolean idle;
  int imageNumber;
  int frame;
  
  public AnimatedSprite(String fileName, float x, float y, int spriteSizeX, int spriteSizeY) {
    super(fileName, x, y, spriteSizeX, spriteSizeY);
    direction = true;
    imageNumber = 0;
    frame = 0;
  }
  
  public void updateAnimation() {
    frame = frame + 1;
    if(frame % 5 == 0) {
      selectDirection();
      selectCurrentImage();
      nextImage();
    }
  }
  
  public void selectDirection() {
    if(speedX > 0) {
      direction = true;
    }
    else if(speedX < 0) {
      direction = false;
    }
  }
  
  public void selectCurrentImage() {
    if(speedX > 0) {
      currentImages = movingRightImages;
      idle = false;
    }
    else if(speedX < 0) {
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
  
  public void nextImage() {
    imageNumber = imageNumber + 1;
    if(imageNumber >= currentImages.length) {
      imageNumber = 0;
    }
    image = currentImages[imageNumber];
  }
}
