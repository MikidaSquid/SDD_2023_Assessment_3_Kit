public class Chest extends Sprite {
  int chestLives;
  
  public Chest(String fileName, float x, float y, int spriteSizeX, int spriteSizeY) {
    super(fileName, x, y, spriteSizeX, spriteSizeY);
    
    chestLives = 7;
  }
}
