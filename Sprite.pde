public abstract class Sprite{
  PImage image;
  float centreX;
  float centreY;
  float sizeX;
  float sizeY;
  float speedX;
  float speedY;
  
  //constructor
  Sprite(String fileName, float x, float y, float spriteSizeX, float spriteSizeY) {
    image = loadImage(fileName);
    centreX = x;
    centreY = y;
    sizeX = spriteSizeX;
    sizeY = spriteSizeY;
    speedX = 0;
    speedY = 0;
  }
  
  void display() {
    image(image, centreX - sizeX/2, centreY - sizeY/2, sizeX, sizeY);
  }
  
  float getRight() {
    return centreX + sizeX/2;
  }
  float getLeft() {
    return centreX - sizeX/2;
  }
  float getTop() {
    return centreY - sizeY/2;
  }
  float getBottom() {
    return centreY + sizeY/2;
  }
  
  void setRight(float newRight) {
    centreX = newRight - sizeX/2;
  }
  void setLeft(float newLeft) {
    centreX = newLeft + sizeX/2;
  }
  void setTop(float newTop) {
    centreY = newTop + sizeY/2;
  }
  void setBottom(float newBottom) {
    centreY = newBottom - sizeY/2;
  }
}
