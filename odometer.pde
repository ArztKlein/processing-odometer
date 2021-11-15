class Odometer{
  int x, y, fontSize;
  int value, previousValue;
  int timer;
  PGraphics pg, mask;
  float leftX, totalWidth;
 
  Odometer(int x, int y, int fontSize){
    this.x = x;
    this.y = y;
    this.fontSize = fontSize;
    
    this.pg = createGraphics(width, height, P2D);
    this.mask = createGraphics(width, height, P2D);
    
    this.drawMask();
  }
  
  void update(int value){
    if(this.timer >= odometerSlideTime){
      this.timer = 0;
      this.previousValue = this.value;
      this.value = value;
    }
  }
  
  void setPos(int x, int y){
    this.x = x;
    this.y = y;
    this.drawMask();
  }
  
  void draw(){
    this.timer++;
    
    pg.beginDraw();
    pg.background(18);
    
    
    if(this.timer >= odometerSlideTime){
      this.previousValue = this.value;
    }
    
    String stringValue = str(this.value);
    String stringPreviousValue = str(this.previousValue);
    
    ArrayList<HashMap<String,Integer>> changes = getChanges(stringPreviousValue, stringValue);
    
    
    
    this.pg.textSize(this.fontSize);
    this.pg.textAlign(LEFT, BOTTOM);
    this.pg.fill(255);
    
    //float nextLeftX = this.x - (pg.textWidth(stringValue) / 2);
    float nextLeftX = this.x;
    
    float currentX = this.leftX;
    for(int i = 0; i < stringValue.length(); i++){
      HashMap<String,Integer> change = this.findChange(changes, i);
      if(change != null){
        int difference = change.get("change");
        int from = change.get("from");
        int next = change.get("next");
        float percentage = float(this.timer) / float(odometerSlideTime);
        
        if(difference > 0){
          for(int j = 0; j < abs(difference) + 1; j++){
          int number = from + j;
          
          if(number >= 10){
              number = int(str(str(number).charAt(str(number).length() - 1)));
           }
          
          float startY = this.y - this.fontSize * j;
          float endY = this.y + this.fontSize * (difference - j);
          
          float currentY = lerp(startY, endY, percentage);
          this.pg.text(number, currentX, currentY);
         }
        }else{
          for(int j = 0; j < abs(difference) + 1; j++){
            int number = from - j;
            
            if(number >= 10){
              number = int(str(str(number).charAt(str(number).length() - 1)));
           }
            
            float startY = this.y + this.fontSize * j;
            float endY = this.y + this.fontSize * (difference + j);
            
            float currentY = lerp(startY, endY, percentage);
            this.pg.text(number, currentX, currentY);
         }
         
       }
        
        
      }else{
        this.pg.text(stringValue.charAt(i), currentX, this.y);
      }
      
      currentX += pg.textWidth(stringValue.charAt(i));
    }
    
    float totalWidth = currentX - this.leftX;
    
    if(nextLeftX != this.leftX || totalWidth != this.totalWidth){
      this.leftX = nextLeftX;
      this.totalWidth = totalWidth;
      this.drawMask();
    }
    
    this.pg.mask(mask);
    this.pg.endDraw();
    image(pg, 0, 0);  
  }
  
  ArrayList<HashMap<String,Integer>> getChanges(String prev, String next){
    ArrayList<HashMap<String,Integer>> changes = new ArrayList<HashMap<String,Integer>>();
    
    for(int i = 0; i < min(prev.length(), next.length()); i++){
      if(prev.charAt(i) != next.charAt(i)){
        HashMap<String,Integer> hm = new HashMap<String,Integer>();
        int prevInt = int(str(prev.charAt(i)));
        int nextInt = int(str(next.charAt(i)));
        int difference = nextInt - prevInt;
        hm.put("from", prevInt);
        hm.put("next", nextInt);
        hm.put("digit", i);
        if(i > 0 && difference < 0){
          int prevCharPrev = int(str(prev.charAt(i - 1)));
          int prevCharNext = int(str(next.charAt(i - 1)));
          if(prevCharNext < prevCharPrev){
            int proposedDifference = 10 - (prevInt - nextInt);
            if(abs(proposedDifference) < abs(difference)){
              
              difference = proposedDifference;
              
            }
          }
        }
        
        hm.put("change", difference);
        
        changes.add(hm);
      }    
    }
    return changes; 
  }
  
  HashMap<String,Integer> findChange(ArrayList<HashMap<String,Integer>> changes, int digit){
    for(int i = 0; i < changes.size(); i++){
      HashMap<String,Integer> change = changes.get(i);
      if(change.get("digit") == digit){
        return change;
      }
    }
    return null;  
  }
  
  void drawMask(){
    this.mask.beginDraw();
    
    this.mask.background(0);
    this.mask.fill(255);
    this.mask.rect(leftX, this.y, this.totalWidth, -this.fontSize - (this.fontSize / 5));
    this.mask.endDraw();
  }
}
