public with sharing class CTPersonTriggerHandler {
    public static void beforeInsert(List<Person__c> newRecords){
        for(Person__c person : newRecords){
            // update person status to green
            person.Health_Status__c = 'Green';
            // generate unique token
            person.Token__c = CTPersonController.getToken(person.Mobile__c);
        }

    }
}