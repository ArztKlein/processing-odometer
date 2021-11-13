# processing-odometer
Odometer / Sliding Numbers Animation for Processing

Create an odometer
```java
Odometer o = new Odometer(x, y, fontSize);
```

Draw Odometer
```java
void draw(){
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
