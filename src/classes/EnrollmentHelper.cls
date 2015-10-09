public with Sharing class EnrollmentHelper {

    public Static Void leadChange(List<Enrollment__c> newEnroll){
        
        if(!newEnroll.isEmpty() && newEnroll!=null){
            List<Enrollment__c> enrlListPT = new List<Enrollment__c>();
            List<Enrollment__c> enrlListFT = new List<Enrollment__c>();
            Map<Id,List<Enrollment__c>> leadEvaluate = new Map<Id, List<Enrollment__c>>();
            
            FOR(Enrollment__c e :newEnroll){
                IF(e.Lead__c!=null){
                    IF(leadEvaluate.containsKey(e.Lead__c)){
                        leadEvaluate.get(e.Lead__c).add(e);
                    } ELSE IF (!leadEvaluate.containsKey(e.Lead__c)){
                        List<Enrollment__c> newEnrollList = new List<Enrollment__c>{e};
                        leadEvaluate.put(e.Lead__c, newEnrollList);
                    }
                }/* ELSE IF(e.Lead__c==null&&e.MDFTWorker__c!=null){
                    enrlListFT.add(e);
                }*/
            }
            
            IF(leadEvaluate!=null && !leadEvaluate.isEmpty()){
                FOR(Lead ld :[SELECT Id, Enrollment_Code__r.Name
                              FROM Lead
                              WHERE Id IN :leadEvaluate.keySet()]){
                                  IF(ld.Enrollment_Code__r.Name!=NULL){
                                      IF(ld.Enrollment_Code__r.Name.endsWith('PT')){
                                          enrlListPT.addAll(leadEvaluate.get(ld.Id));
                                      }/* ELSE if (!ld.Enrollment_Code__r.Name.endsWith('PT')){
                                          enrlListFT.addAll(leadEvaluate.get(ld.ID));
                                      }*/
                                  }/* ELSE IF (ld.Enrollment_Code__r.Name==NULL){
                                      enrlListFT.addAll(leadEvaluate.get(ld.ID));
                                  }*/
                              }
            }
            
            IF(!enrlListPT.isEmpty()&&enrlListPT!=null){
                FOR(Integer i=0; i<enrlListPT.size();i++){
                    IF(enrlListPT[i].MDFTWorker__c=='No'){
                        enrlListPT.remove(i);
                    }
                }
            }
            
/*            IF(!enrlListFT.isEmpty()&&enrlListFT!=null){
                FOR(Integer i=0; i<enrlListFT.size();i++){
                    IF(enrlListFT[i].MDFTWorker__c==null||enrlListFT[i].MDFTWorker__c=='Yes'){
                        enrlListFT.remove(i);
                    }
                }
            }*/
            
            updateMed(enrlListPT, enrlListFT);
        }
    }
    
    public static void updateMed (List<Enrollment__c> enrollPT, List<Enrollment__c> enrollFT) {
        IF(enrollPT != NULL && !enrollPT.isEmpty()){
            FOR(Enrollment__c e :enrollPT){
                e.MDFTWorker__c='No';
            }
            IF(Trigger.isAfter){
                update enrollPT;
            }
        }
        IF(enrollFT != NULL && !enrollFT.isEmpty()){
            For(Enrollment__c e :enrollFT){
                e.MDFTWorker__c=null;
            }
            IF(Trigger.isAfter){
                update enrollFT;
            }
        }
        
    }
    
    public static void leadEnrollmentRollupSummary (List<Enrollment__c> enrList, Map<Id, Enrollment__c> oldEnrMap) {
        Set<Id> ldSet = new Set<Id>();
        Map<Id, List<Enrollment__c>> rollupSummary = new Map<Id, List<Enrollment__c>>();        
        
        IF( ( enrList!= null && !enrList.isEmpty() ) || Trigger.isDelete ){
            System.debug(LoggingLevel.INFO,'enrlList !=null & !isEmpty');
            
            IF(!Trigger.isDelete){
                For(Enrollment__c e :enrList){
                    System.debug(LoggingLevel.INFO,'enrList e = '+e);
                    
                    IF(Trigger.isUpdate && 
                       (e.Lead__c != oldEnrMap.get(e.Id).Lead__c || e.AssignmentLength__c != oldEnrMap.get(e.Id).AssignmentLength__c || e.ExpectedBillings__c != oldEnrMap.get(e.Id).ExpectedBillings__c || e.Invoice_Date__c != oldEnrMap.get(e.Id).Invoice_Date__c )
                      ) {
                          System.debug(LoggingLevel.INFO,'enrList e isUpdate');
                          
                          IF(e.Lead__c!=null){
                              IF(!ldSet.contains(e.Lead__c))ldSet.add(e.Lead__c);
                          }
                          
                          IF (oldEnrMap.get(e.Id).Lead__c != null){
                              IF(!ldSet.contains(oldEnrMap.get(e.Id).Lead__c))ldSet.add(oldEnrMap.get(e.Id).Lead__c);
                          }
                          
                      } ELSE IF(Trigger.isUndelete || Trigger.isInsert){
                          System.debug(LoggingLevel.INFO,'enrList e isUndelete or isInsert');
                          IF(e.Lead__c!=null){
                              IF(!ldSet.contains(e.Lead__c))ldSet.add(e.Lead__c);
                          }
                      }
                }
            } ELSE IF (Trigger.isDelete){
                System.debug(LoggingLevel.INFO,'enrList e isDelete');
                FOR(Enrollment__c e :oldEnrMap.values()){
                    IF (e.Lead__c != null){
                        IF(!ldSet.contains(e.Lead__c))ldSet.add(e.Lead__c);
                    }
                }
            }
        }
        
        IF(!ldSet.isEmpty()){
            For(Lead ld :[SELECT Id, IsConverted FROM Lead WHERE Id IN :ldSet AND IsConverted = TRUE]) ldset.remove(ld.Id);
            
            For(Enrollment__c e :[SELECT Id, Lead__c, AssignmentLength__c, ExpectedBillings__c, Invoice_Date__c, IsDeleted
                                  FROM Enrollment__c 
                                  WHERE Lead__c IN :ldSet 
                                  AND AssignmentLength__c!=null 
                                  AND ExpectedBillings__c != null 
                                  AND Invoice_Date__c != null]){
                                      IF(rollupSummary.containsKey(e.Lead__c))rollupSummary.get(e.Lead__c).add(e);
                                      ELSE {
                                          List<Enrollment__c> enrList2 = new List<Enrollment__c>();
                                          enrList2.add(e);
                                          rollupSummary.put(e.Lead__c,enrList2);
                                      }
                                  }
            
            FOR(Id ld :ldSet){
                IF(!rollupSummary.keySet().contains(ld)){
                    List<Enrollment__c> enrList2 = new List<Enrollment__c>();
                    rollupSummary.put(ld,enrList2);
                }
            }
            
        }
        
        IF(!rollupSummary.isEmpty() && rollupSummary!=null){
            List<Lead> ldList = new List<Lead>();
            FOR(Lead ld :[SELECT Id, Enrollment_Checklists_with_Forecasting__c FROM Lead WHERE Id IN :rollupSummary.keySet()]){
                ld.Enrollment_Checklists_with_Forecasting__c=rollupSummary.get(ld.Id).size();
                System.debug(LoggingLevel.INFO,'## EnrollmentHelper.leadEnrollmentRollupSummary rollupSummary Lead: '+ld.Id+'; Size: '+rollupSummary.get(ld.Id).size());
                ldList.add(ld);
            }
            System.debug(LoggingLevel.ERROR,'SOQL Statements: '+Limits.getQueries());
            Update ldList;
            System.debug(LoggingLevel.ERROR,'SOQL Statements: '+Limits.getQueries());
        }
    }
    
/*    public static Void closedActivitiesUpdate (List<Task> newTask, Map<Id, Task> mapOldTask){
        
        if(!newTask.isEmpty() && newTask!=null){
            set<string> statusValue = new set<string>{'Completed','Attempted','Not Required'};
            set<Id> whoListComp = new set<Id>();
            set<Id> whoListIncomp = new set<Id>();
            List<Enrollment__c> enrlUpdate = new List<Enrollment__c>();
            
            for(Task tsk : newTask){
                string z=tsk.whoId;
                
                If(z.substring(0,3)=='00Q' && statusValue.contains(tsk.Status) && 
                   (Trigger.isInsert ||
                    (!statusValue.contains(mapOldTask.get(tsk.Id).Status) && Trigger.isUpdate)
                   )
                  ){
                      whoListComp.add(tsk.whoId);
                }
                If(z.substring(0,3)=='00Q' && !statusValue.contains(tsk.Status) &&
                   (Trigger.isInsert ||
                    (statusValue.contains(mapOldTask.get(tsk.Id).Status) && Trigger.isUpdate)
                   )
                  ){
                      whoListIncomp.add(tsk.WhoId);
                  }
            }
            
            If(whoListComp != NULL && !whoListComp.isEmpty()){
                for(Task tsk : [SELECT Id, Status, WhoId FROM Task WHERE whoId IN :whoListComp AND Status NOT IN :statusValue]) whoListComp.remove(tsk.whoId);
                If(whoListComp != NULL && !whoListComp.isEmpty()){
                    for(Enrollment__c enrl: [SELECT Id, SFActivitiesClosed__c, Lead__c FROM Enrollment__c WHERE Lead__c IN :whoListComp]){
                        enrl.SFActivitiesClosed__c=TRUE;
                        enrlUpdate.add(enrl);
                    }
                }
            }
            
            If(whoListIncomp != NULL && !whoListIncomp.isEmpty()){
                for(Enrollment__c enrl: [SELECT Id, SFActivitiesClosed__c, Lead__c FROM Enrollment__c WHERE Lead__c IN :whoListIncomp]){
                    enrl.SFActivitiesClosed__c=FALSE;
                    enrlUpdate.add(enrl);
                }
            }
            update enrlUpdate;
        }
        
    }*/
}