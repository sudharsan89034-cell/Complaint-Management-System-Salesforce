@isTest
public class ComplaintTriggerTest {
    
    @isTest
    static void testComplaint(){
        
        Complaint__c comp = new Complaint__c(
            Customer_Name__c = 'Sudharsan',
            Customer_Email__c = '23ita56@karpagamtech.ac.in',
            Complaint_Description__c = 'Damaged product',
            Priority__c = 'High'
        );
        
        insert comp;
        
        // Add resolution
        comp.Resolution_Notes__c = 'Refund given';
        update comp;
        
        Complaint__c updatedComp = 
            [SELECT Status__c FROM Complaint__c WHERE Id = :comp.Id];
        
        System.assertEquals('Closed', updatedComp.Status__c);
    }
}
