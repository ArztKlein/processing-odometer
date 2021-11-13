# processing-odometer
Odometer / Sliding Numbers Animation for Processing

Make sure that you are using Processing Graphics
add a P2D when creating the canvas:
```java
void setup(){
   size(width, height, P2D);
}

Create an odometer
```java
Odometer o = new Odometer(x, y, fontSize);
```

Draw Odometer
```java
void draw(){
   background(18);
   o.draw();
}
```

Change value on odometer
```java
o.update(newValue);
```

Change position of odometer
```java
o.setPos(newX, newY);
```
