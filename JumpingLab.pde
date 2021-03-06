
final static float MOVE_SPEED = 4;
final static float SPRITE_SCALE = 50.0/128;
final static float SPRITE_SIZE = 50;
final static float GRAVITY = .6;
final static float JUMP_SPEED = 14; 

final static float RIGHT_MARGIN = 400;
final static float LEFT_MARGIN = 60;
final static float VERTICAL_MARGIN = 40;


//declare global variables
Sprite player;
PImage snow, crate, red_brick, brown_brick;
ArrayList<Sprite> platforms;

//initialize them in setup().
void setup(){
  size(800, 600);
  imageMode(CENTER);
  player = new Sprite("player.png", 0.8);
  player.center_x = 500;
  player.center_y = 100;
  platforms = new ArrayList<Sprite>();
 
 
  red_brick = loadImage("red_brick.png");
  brown_brick = loadImage("brown_brick.png");
  crate = loadImage("crate.png");
  snow = loadImage("snow.png");
  createPlatforms("map.csv");
}

// modify and update them in draw().
void draw(){
  background(255);
  
  player.display();
  resolvePlatformCollisions(player, platforms);
  for(Sprite s: platforms)
    s.display();

} 

// returns true if sprite is one a platform.
public boolean isOnPlatforms(Sprite s, ArrayList<Sprite> walls){
  // move down say 5 pixels
  s.center_y += 5;
  ArrayList<Sprite> collList = checkCollisionList(s, walls);
  s.center_y -= 5;
  
  if(collList.size() > 0){
  return true;
  }
  else{ 
    return false;
  }
  }
 
 
public void resolvePlatformCollisions(Sprite s, ArrayList<Sprite> walls){
  // add gravity to change_y of sprite
  s.change_y +=GRAVITY;
  s.center_y += s.change_y;
  s.center_x+= s.change_x;
  
  ArrayList<Sprite> col_list = checkCollisionList(s, walls);
  
  if(col_list.size() > 0){
   Sprite collided = col_list.get(0);
   if(s.change_y > 0){
  s.setBottom(collided.getTop());   
   }
   else if(s.change_y < 0){
   s.setTop(collided.getBottom());
   }
   s.change_y = 0;
  }
  
  
  s.center_x+= s.change_x;
  
  col_list = checkCollisionList(s, walls);
  
  if(col_list.size() > 0){
   Sprite collided = col_list.get(0);
   if(s.change_x > 0){
  s.setRight(collided.getLeft());   
   }
   else if(s.change_x < 0){
   s.setLeft(collided.getRight());
   }
   
  }

}
  

boolean checkCollision(Sprite s1, Sprite s2){
  boolean noXOverlap = s1.getRight() <= s2.getLeft() || s1.getLeft() >= s2.getRight();
  boolean noYOverlap = s1.getBottom() <= s2.getTop() || s1.getTop() >= s2.getBottom();
  if(noXOverlap || noYOverlap){
    return false;
  }
  else{
    return true;
  }
}

public ArrayList<Sprite> checkCollisionList(Sprite s, ArrayList<Sprite> list){
  ArrayList<Sprite> collision_list = new ArrayList<Sprite>();
  for(Sprite p: list){
    if(checkCollision(s, p))
      collision_list.add(p);
  }
  return collision_list;
}


void createPlatforms(String filename){
  String[] lines = loadStrings(filename);
  for(int row = 0; row < lines.length; row++){
    String[] values = split(lines[row], ",");
    for(int col = 0; col < values.length; col++){
      if(values[col].equals("1")){
        Sprite s = new Sprite(red_brick, SPRITE_SCALE);
        s.center_x = SPRITE_SIZE/2 + col * SPRITE_SIZE;
        s.center_y = SPRITE_SIZE/2 + row * SPRITE_SIZE;
        platforms.add(s);
      }
      else if(values[col].equals("2")){
        Sprite s = new Sprite(snow, SPRITE_SCALE);
        s.center_x = SPRITE_SIZE/2 + col * SPRITE_SIZE;
        s.center_y = SPRITE_SIZE/2 + row * SPRITE_SIZE;
        platforms.add(s);
      }
      else if(values[col].equals("3")){
        Sprite s = new Sprite(brown_brick, SPRITE_SCALE);
        s.center_x = SPRITE_SIZE/2 + col * SPRITE_SIZE;
        s.center_y = SPRITE_SIZE/2 + row * SPRITE_SIZE;
        platforms.add(s);
      }
      else if(values[col].equals("4")){
        Sprite s = new Sprite(crate, SPRITE_SCALE);
        s.center_x = SPRITE_SIZE/2 + col * SPRITE_SIZE;
        s.center_y = SPRITE_SIZE/2 + row * SPRITE_SIZE;
        platforms.add(s);
      }
    }
  }
}
 

// called whenever a key is pressed.
void keyPressed(){
  if(keyCode == RIGHT){
    player.change_x = MOVE_SPEED;
  }
  else if(keyCode == LEFT){
    player.change_x = -MOVE_SPEED;
  }
  else if(key == 'a' && isOnPlatforms(player, platforms)){
      player.change_y = -JUMP_SPEED;
  }
}

// called whenever a key is released.
void keyReleased(){
  if(keyCode == RIGHT){
    player.change_x = 0;
  }
  else if(keyCode == LEFT){
    player.change_x = 0;
  }
}
