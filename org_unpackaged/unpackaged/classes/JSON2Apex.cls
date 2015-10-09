public class JSON2Apex {
	public static void consumeObject(JSONParser parser) {
		Integer depth = 0;
		do {
			JSONToken curr = parser.getCurrentToken();
			if (curr == JSONToken.START_OBJECT || 
				curr == JSONToken.START_ARRAY) {
				depth++;
			} else if (curr == JSONToken.END_OBJECT ||
				curr == JSONToken.END_ARRAY) {
				depth--;
			}
		} while (depth > 0 && parser.nextToken() != null);
	}

	public class Name {
		public String givenName {get;set;}
		public String familyName {get;set;}
		public String formatted {get;set;}
        public Name(){
        }

		public Name(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'givenName') {
							givenName = parser.getText();
						} else if (text == 'familyName') {
							familyName = parser.getText();
						} else if (text == 'formatted') {
							formatted = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Name consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Photos {
		public String value {get;set;}

		public Photos(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'value') {
							value = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Photos consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Emails {
		public String value {get;set;}
		public String type {get;set;}
		public String jive_label {get;set;}
		public Boolean primary {get;set;}

        public Emails(){
        }
		public Emails(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'value') {
							value = parser.getText();
						} else if (text == 'type') {
							type = parser.getText();
						} else if (text == 'jive_label') {
							jive_label = parser.getText();
						} else if (text == 'primary') {
							primary = parser.getBooleanValue();
						} else {
							System.debug(LoggingLevel.WARN, 'Emails consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
        
	}
	
	public class Jive {
		public Level level {get;set;}
		public String timeZone {get;set;}
		public String locale {get;set;}
		public String username {get;set;}
		public List<Profile> profile {get;set;}
		public Boolean external {get;set;}
		public Boolean visible {get;set;}
		public Boolean enabled {get;set;}
		public Boolean externalContributor {get;set;}
		public Boolean federated {get;set;}
		
        public Jive() {}
        
		public Jive(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'level') {
							level = new Level(parser);
						} else if (text == 'timeZone') {
							timeZone = parser.getText();
						} else if (text == 'locale') {
							locale = parser.getText();
						} else if (text == 'username') {
							username = parser.getText();
						} else if (text == 'profile') {
							profile = new List<Profile>();
							while (parser.nextToken() != JSONToken.END_ARRAY) {
								profile.add(new Profile(parser));
							}
						} else if (text == 'external') {
							external = parser.getBooleanValue();
						} else if (text == 'visible') {
							visible = parser.getBooleanValue();
						} else if (text == 'enabled') {
							enabled = parser.getBooleanValue();
						} else if (text == 'externalContributor') {
							externalContributor = parser.getBooleanValue();
						} else if (text == 'federated') {
							federated = parser.getBooleanValue();
						} else {
							System.debug(LoggingLevel.WARN, 'Jive consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
       
        
        
        
        public void putJiveLabel( String name, String val) {
           
            String value = '';
            if( val != null ){
                value = val;
            }
           
            boolean islabel = false;
            if(profile == Null) {
                profile = new List<Profile>();
            }
            
            for(Profile profile : profile )
            {
                if(profile.jive_label == name )
                {
                    islabel = true;
                    if( value == '' ){
                       if( profile.jive_label == 'Title' || profile.jive_label == 'What do you do?') {
                           profile.setvalue(value);
                        }
                    }
                    else{
                        profile.setvalue(value);
                    }
                }
                
            }
            if( islabel == false){
                if(  value != '' ){
                    Profile profRec = new Profile();
                    profRec.jive_label = name;
                    profRec.value = value;
                    this.profile.add(profRec);
                }

                
            }
        }
        
  
        public String getProfileByName( String name )
        {	
            if(profile != Null) {
                for(Profile profile : profile )
                {
                    if(profile.jive_label == name )
                    {
                        
                        return profile.getvalue();
                        
                    }
                }            
            }
            return '';
        }
        
        public void putProfileByName(String name, String val) {
            String value = '';
            if( val != null ){
                value = val;
            }
            if(profile == Null) {
                profile = new List<Profile>();
            }
            for(Profile profile : profile) {
                if(profile.jive_label == name) {
                    profile.setvalue(value);  
                    
                }
            }
    }
        
	}
	
	public Name name {get;set;}
	public String location {get;set;}
	public String type {get;set;}
	public String displayName {get;set;}
	public String status {get;set;}
	public List<String> tags {get;set;}
	public String published {get;set;}
	public Integer followingCount {get;set;}
	public String thumbnailUrl {get;set;}
	public Jive jive {get;set;}
	public String updated {get;set;}
	public List<Emails> emails {get;set;}
	public List<Photos> photos {get;set;}
	public String thumbnailId {get;set;}
	public Integer followerCount {get;set;}
	public Resources resources {get;set;}
	public String id {get;set;}

	public JSON2Apex(JSONParser parser) {
		while (parser.nextToken() != JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != JSONToken.VALUE_NULL) {
					if (text == 'name') {
						name = new Name(parser);
					} else if (text == 'location') {
						location = parser.getText();
					} else if (text == 'type') {
						type = parser.getText();
					} else if (text == 'displayName') {
						displayName = parser.getText();
					} else if (text == 'status') {
						status = parser.getText();
					} else if (text == 'tags') {
						tags = new List<String>();
						while (parser.nextToken() != JSONToken.END_ARRAY) {
                            tags.add( parser.getText());
							//tags.add(new String(parser));
						}
					} else if (text == 'published') {
						published = parser.getText();
					} else if (text == 'followingCount') {
						followingCount = parser.getIntegerValue();
					} else if (text == 'thumbnailUrl') {
						thumbnailUrl = parser.getText();
					} else if (text == 'jive') {
						jive = new Jive(parser);
					} else if (text == 'updated') {
						updated = parser.getText();
					} else if (text == 'emails') {
						emails = new List<Emails>();
						while (parser.nextToken() != JSONToken.END_ARRAY) {
							emails.add(new Emails(parser));
						}
					} else if (text == 'photos') {
						photos = new List<Photos>();
						while (parser.nextToken() != JSONToken.END_ARRAY) {
							photos.add(new Photos(parser));
						}
					} else if (text == 'thumbnailId') {
						thumbnailId = parser.getText();
					} else if (text == 'followerCount') {
						followerCount = parser.getIntegerValue();
					} else if (text == 'resources') {
						resources = new Resources(parser);
					} else if (text == 'id') {
						id = parser.getText();
					} else {
						System.debug(LoggingLevel.WARN, 'Root consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
	}
	
	public class Following {
		public String ref {get;set;}
		public List<String> allowed {get;set;}

		public Following(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'ref') {
							ref = parser.getText();
						} else if (text == 'allowed') {
							allowed = new List<String>();
							while (parser.nextToken() != JSONToken.END_ARRAY) {
                                allowed.add(parser.getText());
								//allowed.add(new String(parser));
							}
						} else {
							System.debug(LoggingLevel.WARN, 'Following consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Profile {
		public String value;
        //public String jive_label;
		public String jive_label {get;set;}
        
        /*public String getjive_label(){
            return jive_label;
        }
        
        public void setjive_label(String str){
            try {
                this.jive_label = str;    
            }
            catch(Exception ex){}
        }*/
        
        
        public String getvalue() {
    	return Value;    
        }
        
        public void setvalue(String s) {
            try {
                this.Value = s;    
            }
            catch(Exception ex){}
        }
        
        public Profile(){
            
        }
		public Profile(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'value') {
							//value = parser.getText();
                            if( parser.getText() == '['){  
                                system.debug('here');
                                list<string> value1 = new List<String>();
                                while (parser.nextToken() != JSONToken.END_ARRAY) {
                                    system.debug('string:' + parser.getText());
                                    value1.add(parser.getText());
                                    value = string.valueOf(value1);
                                    system.debug('string1:' + value1);
                                    //value.add(new String(parser));
                                }
                                
                            }
                            else{
                                value = parser.getText();
                                system.debug('value:' + value);
                            }
						} else if (text == 'jive_label') {
                            
                            jive_label = parser.getText();
                      
						} else {
							System.debug(LoggingLevel.WARN, 'Profile consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
        
        
	}
	
	public class Level {
		public String name {get;set;}
		public String description {get;set;}
		public Integer points {get;set;}

		public Level(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'name') {
							name = parser.getText();
						} else if (text == 'description') {
							description = parser.getText();
						} else if (text == 'points') {
							points = parser.getIntegerValue();
						} else {
							System.debug(LoggingLevel.WARN, 'Level consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Resources {
		public Following following {get;set;}
		public Following followers {get;set;}
		public Following images {get;set;}
		public Following streams {get;set;}
		public Following self {get;set;}
		public Following html {get;set;}
		public Following followingIn {get;set;}
		public Following avatar {get;set;}
		public Following members {get;set;}
		public Following activity {get;set;}

		public Resources(JSONParser parser) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'following') {
							following = new Following(parser);
						} else if (text == 'followers') {
							followers = new Following(parser);
						} else if (text == 'images') {
							images = new Following(parser);
						} else if (text == 'streams') {
							streams = new Following(parser);
						} else if (text == 'self') {
							self = new Following(parser);
						} else if (text == 'html') {
							html = new Following(parser);
						} else if (text == 'followingIn') {
							followingIn = new Following(parser);
						} else if (text == 'avatar') {
							avatar = new Following(parser);
						} else if (text == 'members') {
							members = new Following(parser);
						} else if (text == 'activity') {
							activity = new Following(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'Resources consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
    public JSON2Apex() {}
	public static JSON2Apex parse(String json) {
		return new JSON2Apex(System.JSON.createParser(json));
	}
}