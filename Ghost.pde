class Ghost{
  int x, y;
  PImage[] gimage = new PImage[4];
  int pic_birght;
  int flagx, flagy;
  int hp;
  int attack;
  
  void inputxy(){
     x = int(random(620));y = int(random(420));
  }
  
  void move(){
    switch(int(random(255)%4)){
      case 0:
      if(x < 620) {
        x += 7;
        flagx = 1;
      }
      break;
      
      case 1:
      if(y < 420) {
        y += 7;
        flagy = 1;
      }
      break;
      
      case 2:
      if(x > 3) {
        x -= 7;
        flagx = -1;
      }      
      break;
      
      case 3:
      if(y > 3){
        y -= 7;
        flagy = -1;
      }
      break;
    }
  }
  
  void display(){
    if(indiv_num < 9){
      if(flagx == 1 || flagy == 1){
        for(int i = 0;i<2;++i){
          image(this.gimage[i], this.x, this.y, 60, 60);
        }
      }
      else{
        for(int i = 2;i<4;++i){
          image(this.gimage[i], this.x, this.y, 60, 60);
        }
      }
    }
    else{
      if(flagx == 1 || flagy == 1){
        for(int i = 0;i<2;++i){
         image(this.gimage[i], this.x, this.y, 90, 90);
        }
      }
      else{
        for(int i =2;i<4;++i){
          image(this.gimage[i], this.x, this.y, 90, 90);
        }
      }
    }
  }
}