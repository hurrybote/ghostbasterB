/* 
        ゴーストバスター  7/12
                                                          */

import processing.video.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

Capture video;
Minim minim;
AudioSnippet damage;

int Menu = 0;
PImage img;

int score=0;
int hit=0;
int indiv_num=0;

int motorPin=9;
int botton = 10;

int bottonAction;

//レーザーポインターの座標オブジェクト
MyInfo me;

//Ghost型のオブジェクト配列を宣言
Ghost[] obake = new Ghost[10];
  

void setup(){
  //画面サイズ
  size(800, 600);
  //１秒間に何回drawを実行するか
  frameRate(30);
  img = loadImage("hotel_lift_hall.jpg");
  img.loadPixels();
  minim = new Minim(this);
  damage = minim.loadSnippet("damage2.mp3");
  background(0);
  me = new MyInfo();
  
  //setup ghost
  for(int i = 0;i < 10;++i){
    obake[i] = new Ghost();
    obake[i].inputxy();
    for(int j=0;j<4;++j){
    obake[i].gimage[j]=new PImage();
    }
    if(i < 9) obake[i].hp =100;
    else obake[i].hp = 300;
  }
  
  make_a_ghost();

  //video
  video = new Capture(this, 800, 600,"USB カメラ");
  video.start();
  loadPixels();
}

//--------------------------------ここまで初期化---------------------------------------------------
//--------------------------------ここから実行-----------------------------------------------------

void draw(){  
  getlocate();
  
  switch(Menu){
    case 0:
      textSize(32);
      text("START", 320, 300);
      break;
      
    case 1:
      image(img, 0, 0);
      
      println(me.hp);
      
      obake[indiv_num].move();
      
      obake[indiv_num].display();  
      
      search_light();
      
      check_hit();
      //お化けのhpの値で倒したかどうかを判定
      check_attack();
      
      check_score();
      
      break;
      
    case 2:
      background(0);
      textSize(64);
      text("your score is " + score + " !", 150, 320);
      
      
  }  
}

//-----------------------------------自作関数群----------------------------------------------

void mousePressed(){
  if(Menu ==0){
    Menu = 1;
  }
  
  bottonAction = 1;
}


void getlocate() {

  //カメラ画像のピクセルをひとつずつ調べる
  for(int i=0;i<800*600;i++){
    //ピクセルが254以上の明るさの場合
    if(brightness(video.pixels[i])>=250){
      me.x = (i%width);
      me.y = (i/height);
      //pixelは左上から順番の配列なので画面のピクセル数で割るとy座標が、剰余でx座標が求めれる
    }   
  }

}

void check_attack(){
  int i = int(random(1000));
  if(i % 50 == 0){
    me.hp -= obake[indiv_num].attack;
  }
}

void check_hit(){
  //お化けの画像の上にポインタがあるときにボタンが押されると1にする
  if(mousePressed == true){
    if(obake[indiv_num].x < me.x && me.x < obake[indiv_num].x+50 && obake[indiv_num].y< me.y && me.y < obake[indiv_num].y+50){
      damage.play();
      obake[indiv_num].hp -= 3;
      hit = 1;
      damage.rewind();
    }
  }
  else{
      hit = 0;
    } 
}

void check_score(){
  if(me.hp <= 0){
    Menu = 2;
  }
  //hitかつお化けのhpがないときスコアに加算
  if(obake[indiv_num].hp <= 0){
      score += 1;
      indiv_num += 1;
    }
  if(obake[9].hp <= 0){
    Menu = 2;
  }
}

void make_a_ghost(){
  for(int j=0;j<10;++j){
    if(j != 9){
      switch(random_num()){
        case 0:
          for(int i=0; i<4; ++i){
            obake[j].gimage[i] = loadImage("ghost1-"+(i+1)+".png");
            obake[j].attack = 2;
          }
          break;
        
        case 1:
          for(int i=0; i<4; ++i){
            obake[j].attack = 1;
            obake[j].gimage[i] = loadImage("ghost2-1-"+(i+1)+".png");
          }
          break;
        
        case 2:
          for(int i=0;i<4;++i){
            obake[j].attack = 1;
            obake[j].gimage[i] = loadImage("ghost2-2-"+(i+1)+".png");
          }
          break;
        
        case 3:
          for(int i=0;i<4;++i){
            obake[j].attack = 1;
            obake[j].gimage[i] = loadImage("ghost2-3-"+(i+1)+".png");
          }
          break;
      }  
    }
    else{
      for(int i = 0; i<4; ++i){
        obake[9].attack = 10;
        obake[9].gimage[i] = loadImage("ghost3-"+(i+1)+".png");
      }
    }
  }
}

int random_num(){
  return int(random(0, 4));
}

void search_light(){
  loadPixels();

      //all pixels
      for (int x = 0; x < width; x++) {
        for (int y = 0; y < height; y++ ) {
        // Calculate the 1D location from a 2D grid
            int loc = x + y * width;
        // Get the R,G,B values from image  
            float r,g,b;
            r = red (pixels[loc]);
            g = green (pixels[loc]);
            b = blue (pixels[loc]);
        // Calculate an amount to change brightness based on proximity to the mouse
            float maxdist = 80;//dist(0,0,width,height);
            float d = dist(x, y, me.x, me.y);
            float adjustbrightness = 80*(maxdist-d)/maxdist;
            r += adjustbrightness;
            g += adjustbrightness;
            b += adjustbrightness;
        // Constrain RGB to make sure they are within 0-255 color range
            r = constrain(r, 0, 255);
            g = constrain(g, 0, 255);
            b = constrain(b, 0, 255);
        // Make a new color and set pixel in the window
            color c = color(r, g, b);
        //color c = color(r);
            pixels[y*width + x] = c;
      }
  }
  updatePixels();
}

void captureEvent(Capture video){
  video.read();
}