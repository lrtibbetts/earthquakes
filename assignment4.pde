// Assignment 4
// Lucy Tibbetts

// Resource consulted:
// help determining conversions: https://stackoverflow.com/questions/14329691/convert-latitude-longitude-point-to-a-pixels-x-y-on-mercator-projection
// used to generate color gradient: http://www.perbang.dk/rgbgradient/

PImage map;
Table earthquakes;
float minlat;
float maxlat;
float minlon;
float maxlon;
float xscale;
float yscale;
int currentyr;
int mapwidth;

void setup() {
  size(1755, 767);
  background(255);
  
  currentyr = 1900; // begin by displaying earthquakes in the year 1900
  
  map = loadImage("equirectangular.png"); // original dimensions: 1916 x 958
  map.resize(1533, 767); // scale t0 80% of original size
  mapwidth = 1527; // ensure that marks are contained entirely on map (do not extend off right edge)
  
  earthquakes = loadTable("centennial.csv", "header");
  
  minlat = -90;
  maxlat = 90;
  minlon = -180;
  maxlon = 180;
  
  xscale = mapwidth / (maxlon - minlon); // # of pixels per degree longitude  
  yscale = height / (maxlat - minlat); // # of pixels per degree latitude
}

void keyPressed() {
  if(key == CODED) {
    if(keyCode == LEFT) {
      if(currentyr == 1900)
        currentyr = 2007;
      else
        currentyr--;
    } else if(keyCode == RIGHT) {
      if(currentyr == 2007)
        currentyr = 1900;
      else
        currentyr++;
    }
  }
}

void draw() {
  background(255);
  image(map, 0, 0);
  
  // legend
  fill(0);
  textSize(15);
  text("Magnitude:", 1550, 50);
  stroke(0);
  fill(255);
  
  // draw boxes to contain circles drawn below
  rect(1550, 60, 30, 30);
  rect(1550, 95, 30, 30);
  rect(1550, 130, 30, 30);
  rect(1550, 165, 30, 30);
  rect(1550, 200, 30, 30);
  rect(1550, 235, 30, 30);
  
  // draw grey circles to show user how magnitude is represented
  stroke(#A5A5A5);
  fill(#A5A5A5);
  ellipse(1565, 75, 3, 3);
  ellipse(1565, 110, 7, 7);
  ellipse(1565, 145, 11, 11);
  ellipse(1565, 180, 15, 15);
  ellipse(1565, 215, 19, 19);
  ellipse(1565, 250, 23, 23);
  
  // labels for magnitude representations
  fill(0);
  text("Under 5", 1600, 80);
  text("5 - 5.9 ", 1600, 115);
  text("6 - 6.9", 1600, 150);
  text("7 - 7.9", 1600, 185);
  text("8 - 8.9", 1600, 220);
  text("9 or greater", 1600, 255);
  
  text("Depth: (m below sea level)", 1550, 300);
  
  // draw squares in different colors to show how depth is represented
  stroke(#FF0000);
  fill(#FF0000);
  rect(1550, 310, 30, 30);
  stroke(#E10000);
  fill(#E10000);
  rect(1550, 345, 30, 30);
  stroke(#C40000);
  fill(#C40000);
  rect(1550, 380, 30, 30);
  stroke(#A70000);
  fill(#A70000);
  rect(1550, 415, 30, 30);
  stroke(#8A0000);
  fill(#8A0000);
  rect(1550, 450, 30, 30);
  stroke(#6D0000);
  fill(#6D0000);
  rect(1550, 485, 30, 30);
  stroke(#500000);
  fill(#500000);
  rect(1550, 520, 30, 30);
  
  // labels for depth representations
  text(0, 1600, 330);
  text("1 - 100", 1600, 365);
  text("101 - 200", 1600, 400);
  text("201 - 300", 1600, 435);
  text("301 - 400", 1600, 470);
  text("401 - 500", 1600, 505);
  text("501 - 600", 1600, 540);
  
  // display the earthquakes for the current year
  for(TableRow row : earthquakes.rows()) {
    int yr = row.getInt("yr");
    if(yr == currentyr) { // only display earthquakes for current year
      float lat = row.getFloat("glat");
      float lon = row.getFloat("glon");
      float x = (lon - minlon) * xscale;
      float y = height - ((lat - minlat) * yscale);
      float depth = row.getFloat("dep");
      float mag = row.getFloat("mag");
      if(depth == 0) {
        stroke(#FF0000);
        fill(#FF0000);
      } else if(depth <= 100) {
        stroke(#E10000);
        fill(#E10000);
      } else if(depth <= 200) {
        stroke(#C40000);
        fill(#C40000);
      } else if(depth <= 300) {
        stroke(#A70000);
        fill(#A70000);
      } else if(depth <= 400) {
        stroke(#8A0000);
        fill(#8A0000);
      } else if(depth <= 500) {
        stroke(#6D0000);
        fill(#6D0000);
      } else if(mag <= 600) {
        stroke(#500000);
        fill(#500000);
      } 
      int size; // to be used for height and width of ellipse
      if(mag < 5) {
        size = 3;
      } else if(mag < 6) {
        size = 7; 
      } else if(mag < 7) {
        size = 11;
      } else if(mag < 8) {
        size = 15;
      } else if(mag < 9) {
        size = 19;
      } else {
        size = 23;
      }
      ellipse(x, y, size, size);
    }
  }
  
  // display current year
  fill(0);
  textSize(30);
  text(currentyr, 1605, 720);
}