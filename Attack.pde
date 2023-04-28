//public class Attack extends AnimatedSprite {
  
//  public Attack(String fileName, float x, float y, int spriteSizeX, int spriteSizeY) {
//    super(fileName, x, y, spriteSizeX, spriteSizeY);
    
//    neutralRightImages = new PImage[1];
//    neutralRightImages[0] = loadImage("square.png");
//    neutralLeftImages = new PImage[1];
//    neutralLeftImages[0] = loadImage("square.png");
//  }
  
//  @Override
//  public void selectDirection() {
//    if(player.speedX > 0) {
//      direction = true;
//    }
//    else if(player.speedX < 0) {
//      direction = false;
//    }
//  }
  
//  @Override
//  public void selectCurrentImage() {
//    if(direction == true) {
//      currentImages = neutralRightImages;
//    }
//    else {
//      currentImages = neutralLeftImages;
//    }
//  }
  
//  void displayAttackRight() {
//    image(image, player.getRight(), player.getTop(), sizeX, player.sizeY);
//    sizeY = player.sizeY;
//  }
  
//  void displayAttackLeft() {
//    image(image, player.getLeft() - sizeX, player.getTop(), sizeX, player.sizeY);
//    sizeY = player.sizeY;
//  }
//}
