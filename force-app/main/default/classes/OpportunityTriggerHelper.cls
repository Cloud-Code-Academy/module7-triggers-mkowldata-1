public with sharing class OpportunityTriggerHelper {
    /*
    * Question 5
    * Opportunity Trigger
    * When an opportunity is updated validate that the amount is greater than 5000.
    * Error Message: 'Opportunity amount must be greater than 5000'
    * Trigger should only fire on update.
    */

    public static void amountValidation(List<Opportunity> opportunities) {
        if (opportunities == null) {
            return;
        }
        for (Opportunity opp : opportunities) {
            if (opp.amount < 5000) {
            opp.addError('Opportunity amount must be greater than 5000');
            }
        }
    }
    
    /*
     * Question 6
	* Opportunity Trigger
	* When an opportunity is deleted prevent the deletion of a closed won opportunity if the account industry is 'Banking'.
	* Error Message: 'Cannot delete closed opportunity for a banking account that is won'
	* Trigger should only fire on delete.
    */

    public static void deleteCloseWonOpportunityWhenIndustryBanking(List<Opportunity> opportunities) {
        // create a set to store the opportunity id's
        Set<Id> oppIds = new Set<Id>();
        // loop through opportunities to add id to set
        if (opportunities == null) {
            return;
        }
        for (Opportunity opp : opportunities) {
            oppIds.add(opp.Id);
            }
        
        // create a Map to store the Opportunity information for each opportunity ID
        Map<Id, Opportunity> oppIdToOpportunity= new Map<Id, Opportunity>();
        // query a list of opportunities with accounts that fit the criteria
        List<Opportunity> oppsWithIndustryBankingClosedWon = [SELECT Id, StageName, AccountId, Account.Industry
                                                              FROM Opportunity
                                                              WHERE Id In :oppIds
                                                              AND StageName = 'Closed Won'
                                                              AND Account.Industry = 'Banking'
                                                              WITH SECURITY_ENFORCED];
        for (Opportunity opp : oppsWithIndustryBankingClosedWon) {
            if (!oppIdToOpportunity.containsKey(opp.id)) {
                oppIdToOpportunity.put(opp.Id, opp);
            }
        }
        // loop through opportunities list to see if the Id is in the Map (fits criteria for error message)
        for (Opportunity opp : opportunities) {
            if(oppIdToOpportunity.containsKey(opp.Id)) {
                opp.addError('Cannot delete closed opportunity for a banking account that is won');
            }
        }
    }

    /*
    * Question 7
    * Opportunity Trigger
    * When an opportunity is updated set the primary contact on the opportunity to the contact on the same account with the title of 'CEO'.
    * Trigger should only fire on update.
    */
     public static void setPrimaryContactOnOpportunityToAccountCEO(List<Opportunity> opportunities) {
        // create a set to store the opportunity id's
        Set<Id> oppIds = new Set<Id>();
        // loop through opportunities to add id to set
        if (opportunities == null) {
            return;
        }
        for (Opportunity opp : opportunities) {
            oppIds.add(opp.Id);
            }
        // create a set to store the Account Ids related to the Opportunities
        Set<Id> acctIds = new Set<Id>();
        List<Account> acctsRelatedToOpportunities = [SELECT Id, (SELECT Id FROM Opportunities WHERE Id IN :oppIds)
                                                     FROM Account
                                                     WHERE Id IN (SELECT AccountId FROM Opportunity WHERE Id IN :oppIds)
                                                     WITH SECURITY_ENFORCED];
        for (Account acct : acctsRelatedToOpportunities) {
            if (acctsRelatedToOpportunities == null) {
                return;
            }
            acctIds.add(acct.Id);
        }
        // create a Map to store the Account Id and associated Contacts with Title CEO
        Map<Id, Contact> accountIdToCEOContactName = new Map<Id, Contact>();
        List<Contact> ceoContacts = [SELECT Id, AccountId, Title, Name, FirstName, LastName
                                     FROM Contact
                                     WHERE AccountId IN :acctIds
                                     AND Title LIKE '%CEO%'
                                     WITH SECURITY_ENFORCED];
        for (Contact cont : ceoContacts) {
            if (ceoContacts == null) {
                return;
            }
            if (!accountIdToCEOContactName.containsKey(cont.AccountId)) {
                accountIdToCEOContactName.put(cont.AccountId, cont);
            }
        }
        // loop through the list to update the Primary Contacton the opportunity
        for (Opportunity opp : opportunities) {
            if (accountIdToCEOContactName.containsKey(opp.AccountId)) {
                opp.Primary_Contact__c = accountIdToCEOContactName.get(opp.AccountId).Id;
            }
        }
    }
}