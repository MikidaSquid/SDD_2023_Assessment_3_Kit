//need to do:
//add a sorting algorithm - potentially sorting items in the shop by price, therefore having a 'reccomendation system' on what to buy
//add decorations, objects that are in the background and not interactable, but still move with the scrolling of the screen
//add a block that when touched takes you to the next level
//add a beam attack that just attacks all enemies in front of the player, don't make it too complicated, just use a similar structure to the basic attack
//add a town with shop decorations in the background, and add a shop where more lives, higher attack power, and beam upgrades are buyable

import java.util.ArrayList;

//Constants
final int MOVE_SPEED = 10;
final int JUMP_SPEED = 42;
final int SPRITE_SIZE = 80;
final int SLASH_SIZE = 120;
final float GRAVITY = 3;

//Backgrounds
PImage titleScreen;
PImage background;

//GUI icons
PImage lifeIcons;
PImage coin;

//Other Effects
PImage slashRight;
PImage slashLeft;
PImage damagedEffect;
PImage attackedEffect;

Player player;
//Attack attack;
ArrayList<Block> blocks;
ArrayList<SimpleEnemy> simpleEnemyList;
ArrayList<Chest> chestList;
float differenceX;
float differenceY;
float screenX;
float screenY;
boolean displayTitleScreen;
String blockType;

void setup() {
  fullScreen();
  player = new Player("playerRight1.png", 80*18, 80*5, 140, 80);
  //attack = new Attack("square.png", 33*80, 11*80, 80, 80);
  blocks = new ArrayList<Block>();
  simpleEnemyList = new ArrayList<SimpleEnemy>();
  chestList = new ArrayList<Chest>();
  readCSV("testMap.txt");
  titleScreen = loadImage("titleScreen.png");
  titleScreen.resize(width,height);
  background.resize(width, height);
  lifeIcons = loadImage("life.png");
  coin = loadImage("coin.png");
  slashRight = loadImage("slashRight.png");
  slashLeft = loadImage("slashLeft.png");
  damagedEffect = loadImage("damagedEffect.png");
  attackedEffect = loadImage("attackedEffect.png");
  differenceX = 0;
  differenceY = 0;
  screenX = 0;
  screenY = 0;
  displayTitleScreen = true;
}

void draw() {
  if (displayTitleScreen == true) {
    background(titleScreen);
  }
  else {
    if(player.lives > 0) {
      background(background);
      scroll();
      
      player.checkAndChangeHitbox();
      for(Block block : blocks) {
        block.display();
        //solution to clipping glitch with idle 1 - failed
        //if((block.getTop() < player.getBottom()) && (player.getTop() - 160 < block.getBottom()) && (block.getBottom() < player.getTop() + 160)) {
        //    if( ( (block.getLeft() < player.getRight() + 40) && (block.getLeft() > player.getRight()) ) || ( (block.getRight() > player.getLeft() - 40) && (block.getRight() < player.getLeft()) ) ) {
        //      player.idleSwitchPossible = false;
        //    }
        //}
        //solution to clipping glitch with idle 2 - failed
        //if((checkCollision(block, player) == true) && (block.getTop() >= player.getBottom())) {
        //  if(player.direction == true) {
        //    player.setRight(player.getRight() - 20);
        //  }
        //  else {
        //    player.setLeft(player.getLeft() + 20);
        //  }
        //}
      }
      
      for(Chest treasure : chestList) {
        if(treasure.chestLives > 0) {
          treasure.display();
        }
      }
      
      //if(player.idleSwitchPossible == true) {
      //  player.checkAndChangeHitbox();
      //}
      //player.idleSwitchPossible = true;
      player.displayCharacter();
      player.updateAnimation();
      //circle(player.centreX, player.centreY, 5);
      
      platformCollisions(player, blocks);
      
      for(SimpleEnemy mouse : simpleEnemyList) {
        if(mouse.mouseLives > 0) {
          mouse.display();
          mouse.updateSimpleEnemy();
          mouse.updateAnimation();
          
          if((checkCollision(player, mouse) == true) && player.iFrames == 0) {
            player.lives = player.lives - 1;
            player.iFrames = 100;
            image(damagedEffect, player.centreX - 200, player.centreY - 200, 400, 400);
          }
          
          //if(checkCollision(attack, mouse) == true) {
          //  println("bruh");
          //  mouse.mouseLives = mouse.mouseLives - 1;
          //}
        }
      }
      
      //checking if player has fell off the map
      if(player.centreY > (80*15)) {
            player.lives = player.lives - 1;
            player.iFrames = 100;
            image(damagedEffect, player.centreX - 200, player.centreY - 200, 400, 400);
            player.setRight(80*18);
            player.setTop(80*7);
          }
      
      if(player.iFrames > 0) {
        player.iFrames = player.iFrames - 1;
      }
      if(player.slashCooldown > 0) {
        player.slashCooldown = player.slashCooldown - 1;
      }
    }
    //if the player loses all of their lives
    else {
      background(255, 245, 245);
      fill(0, 50, 150);
      textSize(100);
      text("f", 400, 400);
      textSize(50);
      text("press f to restart", 400, 800);
      fill(0);
      if(keyPressed) {
        if((key == 'f') || (key == 'F')) {
          setup();
        }
      }
    }
  }
}

void keyPressed() {
  if(keyCode == RIGHT) {
    player.speedX = MOVE_SPEED;
  }
  else if(keyCode == LEFT) {
    player.speedX = -MOVE_SPEED;
  }
  else if((keyCode == UP) && (player.onPlatform == true)) {
    player.speedY = -JUMP_SPEED;
  }
  //else if(keyCode == DOWN) {
  //  player.speedY = MOVE_SPEED;
  //}
  else if((key == 'c') || (key =='C')) { //attacking
    if(player.slashCooldown == 0) { //checking if the player's attacking cooldown is over
      if(player.direction == true) { //the attack for facing right
        for(SimpleEnemy mouse : simpleEnemyList) { //checking every mouse
          //checking if the mouse is hit
          if((mouse.getLeft() < (player.getRight() + SLASH_SIZE)) && (mouse.getRight() > player.getRight()) && (mouse.getBottom() >= player.getTop()) && (mouse.getTop() <= player.getBottom())) {
            mouse.mouseLives = mouse.mouseLives - 1; //decreasing the life of the mouse that got hit
            if(mouse.mouseLives > 0) { //if mouse still alive
              image(attackedEffect, mouse.centreX - 150, mouse.centreY - 150, 300, 300); //display the enemy hit effect
            }
            if(mouse.mouseLives == 0) { //if mouse has been defeated
              player.money = player.money + 10; //increasing money
              image(attackedEffect, mouse.centreX - 150, mouse.centreY - 150, 300, 300); //display the enemy hit effect
            }
          }
        }
        for(Chest treasure : chestList) {
          if((treasure.getLeft() < (player.getRight() + SLASH_SIZE)) && (treasure.getRight() > player.getRight()) && (treasure.getBottom() >= player.getTop()) && (treasure.getTop() <= player.getBottom())) {
            treasure.chestLives = treasure.chestLives - 1; //decreasing the life of the chest that got hit
            if(treasure.chestLives > 0) { //if chest still alive
              image(attackedEffect, treasure.centreX - 150, treasure.centreY - 150, 300, 300); //display the enemy hit effect
            }
            if(treasure.chestLives == 0) { //if chest has been defeated
              player.money = player.money + 50; //increasing money
              image(attackedEffect, treasure.centreX - 150, treasure.centreY - 150, 300, 300); //display the enemy hit effect
            }
          }
        }
        image(slashRight, player.getRight(), player.getTop(), SLASH_SIZE, player.sizeY); //displaying slash image
        player.slashCooldown = 15; //resetting the slash cooldown
      }
      else { //the attack for facing left
        for(SimpleEnemy mouse : simpleEnemyList) { //checking every mouse
          //checking if the mouse is hit
          if((mouse.getRight() > (player.getLeft() - SLASH_SIZE)) && (mouse.getLeft() < player.getLeft()) && (mouse.getBottom() >= player.getTop()) && (mouse.getTop() <= player.getBottom())) {
            mouse.mouseLives = mouse.mouseLives - 1; //decreasing the life of the mouse that got hit
            if(mouse.mouseLives > 0) { //if mouse still alive
              image(attackedEffect, mouse.centreX - 150, mouse.centreY - 150, 300, 300); //display the enemy hit effect
            }
            if(mouse.mouseLives == 0) { //if mouse has been defeated
              player.money = player.money + 10; //increasing money
              image(attackedEffect, mouse.centreX - 150, mouse.centreY - 150, 300, 300); //display the enemy hit effect
            }
          }
        }
        for(Chest treasure : chestList) {
          if((treasure.getRight() > (player.getLeft() - SLASH_SIZE)) && (treasure.getLeft() < player.getLeft()) && (treasure.getBottom() >= player.getTop()) && (treasure.getTop() <= player.getBottom())) {
            treasure.chestLives = treasure.chestLives - 1; //decreasing the life of the chest that got hit
            if(treasure.chestLives > 0) { //if chest still alive
              image(attackedEffect, treasure.centreX - 150, treasure.centreY - 150, 300, 300); //display the enemy hit effect
            }
            if(treasure.chestLives == 0) { //if chest has been defeated
              player.money = player.money + 50; //increasing money
              image(attackedEffect, treasure.centreX - 150, treasure.centreY - 150, 300, 300); //display the enemy hit effect
            }
          }
        }
        image(slashLeft, player.getLeft() - SLASH_SIZE, player.getTop(), SLASH_SIZE, player.sizeY); //displaying slash image
        player.slashCooldown = 15; //resetting the slash cooldown
      }
    }
    //if(player.direction == true) {
    //  for(int u = 0; u < 25; u++) {
    //    attack.setLeft(player.getRight());
    //    attack.setTop(player.getTop());
    //    attack.displayAttackRight();
    //  }
    //  attack.setLeft(0);
    //}
    //else {
    //  attack.setRight(player.getLeft());
    //  for(int u = 0; u < 50; u++) {
    //    attack.setRight(player.getLeft());
    //    attack.setTop(player.getTop());
    //    attack.displayAttackLeft();
    //  }
    //  attack.setLeft(0);
    //}
  }
  else if(key == ' ') {
    if(displayTitleScreen == true) {
      displayTitleScreen = false;
    }
  }
}

void keyReleased() {
  if(keyCode == RIGHT) {
    
    player.speedX = 0;
  }
  else if(keyCode == LEFT) {
    player.speedX = 0;
  }
  //else if(keyCode == UP) {
  //  player.speedY = 0;
  //}
  //else if(keyCode == DOWN) {
  //  player.speedY = 0;
  //}
}


//Reading the CSV file to create stages
void readCSV(String fileName) {
  String[] fileLines = loadStrings(fileName);
  int counter = 0;
  int counter2 = 1;
  boolean finishWhileLoop = false;
  
  for(int i = 0; i < fileLines.length; i++) {
    counter2 = 1;
    finishWhileLoop = false;
    for(int u = 0; u < fileLines[i].length(); u++) {
      
      switch(fileLines[i].charAt(u)) {
        case '0': //nothing
          break;
          
        case '1': //solid block
          if(u != fileLines[i].length() - 1) {
            if(fileLines[i].charAt(u+counter2) == '1') {
              counter2 = counter2 + 1;
              while(finishWhileLoop == false) {
                if(u != fileLines[i].length() - 1) {
                  if(fileLines[i].charAt(u+counter2) == '1') {
                    counter2 = counter2 + 1;
                  } 
                  else {
                    finishWhileLoop = true;
                  }
                }
                else {
                  finishWhileLoop = true;
                }
              }
            }
          }
          
          if(finishWhileLoop == true) { 
            blocks.add(new Block(blockType, (SPRITE_SIZE*counter2)/2 + SPRITE_SIZE*u, SPRITE_SIZE/2 + SPRITE_SIZE*i, SPRITE_SIZE*counter2, SPRITE_SIZE));
            u = u + counter2;
          }
          else {
            blocks.add(new Block(blockType, SPRITE_SIZE/2 + SPRITE_SIZE*u, SPRITE_SIZE/2 + SPRITE_SIZE*i, SPRITE_SIZE, SPRITE_SIZE));
          }
          blocks.get(counter).display();
          counter = counter + 1;
          break;
          
        case '2': //half block
          if(u != fileLines[i].length() - 1) {
            if(fileLines[i].charAt(u+counter2) == '2') {
              counter2 = counter2 + 1;
              while(finishWhileLoop == false) {
                if(u != fileLines[i].length() - 1) {
                  if(fileLines[i].charAt(u+counter2) == '2') {
                    counter2 = counter2 + 1;
                  } 
                  else {
                    finishWhileLoop = true;
                  }
                }
                else {
                  finishWhileLoop = true;
                }
              }
            }
          }
          
          if(finishWhileLoop == true) { 
            blocks.add(new Block(blockType, (SPRITE_SIZE*counter2)/2 + SPRITE_SIZE*u, SPRITE_SIZE/4 + SPRITE_SIZE*i, SPRITE_SIZE*counter2, SPRITE_SIZE/2));
            u = u + counter2;
          }
          else {
            blocks.add(new Block(blockType, SPRITE_SIZE/2 + SPRITE_SIZE*u, SPRITE_SIZE/4 + SPRITE_SIZE*i, SPRITE_SIZE, SPRITE_SIZE/2));
          }
          blocks.get(counter).display();
          counter = counter + 1;
          break;
          
        case '!': //invisible block
          blocks.add(new Block("air.png", SPRITE_SIZE/2 + SPRITE_SIZE*u, SPRITE_SIZE/2 + SPRITE_SIZE*i, SPRITE_SIZE, SPRITE_SIZE));
          blocks.get(counter).display();
          counter = counter + 1;
          break;
          
        case 'E': //simpleEnemy
          simpleEnemyList.add(new SimpleEnemy("mouseEnemyRight.png", SPRITE_SIZE/2 + SPRITE_SIZE*u, SPRITE_SIZE*(i+1) - SPRITE_SIZE/4, SPRITE_SIZE, SPRITE_SIZE/2, SPRITE_SIZE*u, SPRITE_SIZE*u + SPRITE_SIZE*6));
          break;
          
        case 'C': //chest
          chestList.add(new Chest("chest.png", SPRITE_SIZE/2 + SPRITE_SIZE*u, SPRITE_SIZE/2 + SPRITE_SIZE*i, SPRITE_SIZE, SPRITE_SIZE));
          break;
          
        case '[': //background 1
          background = loadImage("plainsBackground.png");
          blockType = "grassBlock.png";
        break;
        case ']': //background 2
          background = loadImage("caveBackground.png");
          blockType = "rockBlock.png";
        break;
      }
    }
  }
}

//checks whether or not two sprites are colliding
public boolean checkCollision(Sprite spriteOne, Sprite spriteTwo) {
  return !((spriteOne.getRight() <= spriteTwo.getLeft() || spriteOne.getLeft() >= spriteTwo.getRight()) || (spriteOne.getBottom() <= spriteTwo.getTop() || spriteOne.getTop() >= spriteTwo.getBottom()));
}

//creates a list of all of the sprites that collide with a sprite
public ArrayList<Sprite> createCollisionList(Sprite checkingSprite, ArrayList<Block> otherSprites) {
  ArrayList<Sprite> collisionList = new ArrayList<Sprite>();
  
  for(Sprite s : otherSprites) {
    if(checkCollision(checkingSprite, s) == true) {
      collisionList.add(s);
    }
  }
  return collisionList;
}

//this handles both movement and collisions
public void platformCollisions(Sprite collidingSprite, ArrayList<Block> walls) {
  //move vertically first
  collidingSprite.speedY = collidingSprite.speedY + GRAVITY;
  collidingSprite.centreY = collidingSprite.centreY + collidingSprite.speedY;
  
  if(createCollisionList(collidingSprite, walls).size() > 0) {
    if(collidingSprite.speedY < 0) {
      collidingSprite.setTop((createCollisionList(collidingSprite, walls).get(0)).getBottom());
    }
    else if(collidingSprite.speedY > 0) {
      collidingSprite.setBottom((createCollisionList(collidingSprite, walls).get(0)).getTop());
      player.onPlatform = true;
    }
    collidingSprite.speedY = 0;
  }
  else {
    player.onPlatform = false;
  }
  
  //move horizontally next
  collidingSprite.centreX = collidingSprite.centreX + collidingSprite.speedX;
  
  if(createCollisionList(collidingSprite, walls).size() > 0) {
    if(collidingSprite.speedX < 0) {
      collidingSprite.setLeft((createCollisionList(collidingSprite, walls).get(0)).getRight());
    }
    else if(collidingSprite.speedX > 0) {
      collidingSprite.setRight((createCollisionList(collidingSprite, walls).get(0)).getLeft());
    }
  }
}

//void touchingEdges() {
//  if(player.getLeft() < (blocks.get(0)).getLeft()) {
//    player.setLeft(0);
//  }
//}

//public boolean checkIfOnPlatform(sprite s, ArrayList<sprite> l) {
//  s.centreY = s.centreY - 2;
//  if(createCollisionList(s, l).size() > 0) {
//    s.centreY = s.centreY + 2;
//    return true;
//  }
//  else {
//    s.centreY = s.centreY + 2;
//    return false;
//  }
//}

void scroll() {
  differenceX = screenX + width/2 - player.centreX;
  //differenceY = screenY + width/2 - player.centreY - 400;
  screenX = screenX - differenceX;
  //screenY = screenY - differenceY;
  translate(-screenX, -screenY);
  
  //Moving the GUI
  for(int i = 0; i < player.lives; i++) {
    image(lifeIcons, screenX + 40 + 20*i + 50*i, screenY + 40, 50, 50);
  }
  image(coin, screenX + 42, screenY + 120, 40, 40);
  fill(0);
  textSize(40);
  text(player.money, screenX + 92, screenY + 152);
}
