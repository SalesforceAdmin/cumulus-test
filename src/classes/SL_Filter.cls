public class SL_Filter {
    
    public boolean sl1;
    public boolean sl2;
    public boolean sl3;
    public boolean sl4;
    public boolean sl5;
    private List<string> serviceLevel = new List<string>();
    private string filtValue;
    
    public SL_Filter(boolean default1, boolean default2, boolean default3, boolean default4, boolean default5) {
        this.sl1 = default1;
        this.sl2 = default2;
        this.sl3 = default3;
        this.sl4 = default4;
        this.sl5 = default5;
    }
    
    public boolean getsl1(){
        return this.sl1;
    }
    
    public void setsl1(boolean newSL1){
        this.sl1 = newSL1;
    }
    
    public boolean getsl2(){
        return this.sl2;
    }
    
    public void setsl2(boolean newsl2){
        this.sl2 = newsl2;
    }
    public boolean getsl3(){
        return this.sl3;
    }
    
    public void setsl3(boolean newsl3){
        this.sl3 = newsl3;
    }
    public boolean getsl4(){
        return this.sl4;
    }
    
    public void setsl4(boolean newSL4){
        this.sl4 = newSL4;
    }
    public boolean getsl5(){
        return this.sl5;
    }
    
    public void setsl5(boolean newSL5){
        this.sl5 = newSL5;
    }
    
    public string getFiltValue(){
        this.serviceLevel.clear();
        this.filtValue = null;
                
        If (this.sl1 == true) {
            this.serviceLevel.add('1');
        }
        If (this.sl2 == true) {
            this.serviceLevel.add('2');
        }
        If (this.sl3 == true) {
            this.serviceLevel.add('3');
        }
        If (this.sl4 == true) {
            this.serviceLevel.add('4');
        }
        If (this.sl5 == true) {
            this.serviceLevel.add('5');
        }
        
        If (this.serviceLevel.size()==0 || this.serviceLevel.isEmpty()){
            this.filtValue = '\'\'';
        } else {
            for (Integer i = 0; i < this.serviceLevel.size(); i++){
                System.debug(logginglevel.error,'filtValue: '+this.filtValue);
                if (i+1==this.serviceLevel.size()){
                    if (this.filtValue == null){
                        this.filtValue = '\''+this.serviceLevel[i]+'\'';
                    } else {
                        this.filtValue += '\''+this.serviceLevel[i]+'\'';
                    }
                } else {
                    if(this.filtValue == null){
                        this.filtValue = '\''+this.serviceLevel[i]+'\', ';
                    } else {
                        this.filtValue += '\''+this.serviceLevel[i]+'\', ';
                    }
                }
            }
        }
        
        return this.filtValue;
    }
    
}