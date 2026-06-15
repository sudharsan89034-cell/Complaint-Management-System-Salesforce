trigger ComplaintTrigger on Complaint__c 
(before insert, after insert, before update) {
    
    // BEFORE INSERT
    if(Trigger.isBefore && Trigger.isInsert){
        
        for(Complaint__c comp : Trigger.new){
            
            // Set default Status
            if(comp.Status__c == null){
                comp.Status__c = 'New';
            }
            
            // Auto assign to logged-in user
            if(comp.Assigned_To__c == null){
                comp.Assigned_To__c = UserInfo.getUserId();
            }
        }
    }
    
    
    // AFTER INSERT - Send Email if High Priority
    if(Trigger.isAfter && Trigger.isInsert){
        
        List<Messaging.SingleEmailMessage> emailList = 
            new List<Messaging.SingleEmailMessage>();
        
        for(Complaint__c comp : Trigger.new){
            
            if(comp.Priority__c == 'High'){
                
                Messaging.SingleEmailMessage mail = 
                    new Messaging.SingleEmailMessage();
                
                mail.setToAddresses(new String[] {comp.Customer_Email__c});
                
                mail.setSubject('High Priority Complaint Received');
                
                mail.setPlainTextBody(
                    'Dear Customer,' + '\n\n' +
                    'Your complaint number ' + comp.Name +
                    ' has been marked as HIGH priority.' +
                    '\nOur team will contact you soon.' +
                    '\n\nThank You.'
                );
                
                emailList.add(mail);
            }
        }
        
        if(!emailList.isEmpty()){
            Messaging.sendEmail(emailList);
        }
    }
    
    
    // BEFORE UPDATE - Auto Close Logic
    if(Trigger.isBefore && Trigger.isUpdate){
        
        for(Complaint__c comp : Trigger.new){
            
            Complaint__c oldComp = Trigger.oldMap.get(comp.Id);
            
            if(comp.Resolution_Notes__c != null &&
               oldComp.Resolution_Notes__c == null){
                
                comp.Status__c = 'Closed';
            }
        }
    }
}
