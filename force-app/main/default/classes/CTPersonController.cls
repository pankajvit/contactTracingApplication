public with sharing class CTPersonController {
    /**
     * generate unique token using mobile number
     * use MD5 algorithm to generate one-way hash
     * @param mobile
     * @return string token
     * Solution of first assignment
     */

    public static String getToken(String mobileNo){
        Blob value = Blob.valueOf(mobileNo);
        Blob hash = Crypto.generateDigest('MD5', value);
        // return encoded string
        return EncodingUtil.base64Encode(hash);
    }

    /**
     * Get 100 contacts with recent health status change
     * @return List<Person__c>
     */
    public static List<Person__c> getRecentHealthChanges(){
        return [SELECT Id, Name, Health_Status__c, Mobile__c, Status_Update_Date__c, Token__c 
                    FROM Person__c 
                    ORDER BY Status_Update_Date__c DESC NULLS LAST 
                    LIMIT 100];
    }

    /**
     * Search a person by name, token or mobile
     * @return List<Person__c>
     */
    public static List<Person__c> searchPeople(String searchTerm){
        // appending the wild card
        searchTerm = searchTerm + '%';
        return [SELECT Id, Name, Health_Status__c, Mobile__c, Status_Update_Date__c, Token__c
                    FROM Person__c
                    WHERE Name LIKE :searchTerm
                    OR Mobile__c LIKE :searchTerm
                    OR Token__c LIKE :searchTerm
                    ORDER BY Status_Update_Date__c DESC NULLS LAST];
    }

    /**
     * Search a person by id
     * @return Person__c
     */
    public static Person__c getPersonById(String personId){
        List<Person__c> people = [SELECT Id, Name, Health_Status__c, Mobile__c, Status_Update_Date__c, Token__c
                                    FROM Person__c
                                    WHERE Id =:personId];
        if(people != null && people.size() > 0){
            return people[0];
        }
        return null;
    }

    /**
     * Get count of people in each health status
     * @return Map<String, Integer>
     */
    public static Map<String, Integer> getHealthStatusCount() {
        Map<String, Integer> healthCountMap = new Map<String, Integer>();
        for(AggregateResult ar : [SELECT Health_Status__c, COUNT(Id) total 
                                    FROM Person__c 
                                    GROUP BY Health_Status__c]){
            String healthStatus = String.valueOf(ar.get('Health_Status__c'));
            Integer count = Integer.valueOf(ar.get('total'));
            healthCountMap.put(healthStatus, count);
        }
        return healthCountMap;
    }
}