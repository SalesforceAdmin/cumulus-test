public class JivePersonInfo{

    public JivePersonInfo() {}
    
    public String username {get; set;}
    
    public List<JiveProfiles> profile {get; set;}
    
    public String getProfileByName( String name )
    {	
        if(profile != Null) {
            for(JiveProfiles profile : profile )
            {
                if(profile.jive_label == name )
                {
                    return profile.getvalue();
                }
            }            
        }
        return '';
    }
    
    public void putProfileByName(String name, String value) {
        if(profile == Null) {
        	profile = new List<JiveProfiles>();
        }
        for(JiveProfiles profile : profile) {
            if(profile.jive_label == name) {
            	profile.setvalue(value);  
                
            }
        }
    }
    
    public void insertProfileByName(String name, String value) {
    	JiveProfiles profRec = new JiveProfiles();
        profRec.jive_label = name;
        profRec.value = value;
        
        if(profile == Null) {
        	profile = new List<JiveProfiles>();
        }
        
        this.profile.add(profRec);
    }
    

    
}