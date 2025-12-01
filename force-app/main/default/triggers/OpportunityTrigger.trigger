trigger OpportunityTrigger on Opportunity (before update, before delete) {
    if (Trigger.isBefore && Trigger.isUpdate) {
        OpportunityTriggerHelper.amountValidation(Trigger.new);
        OpportunityTriggerHelper.setPrimaryContactOnOpportunityToAccountCEO(Trigger.new);
    }

    if (Trigger.isBefore && Trigger.isDelete) {
        OpportunityTriggerHelper.deleteCloseWonOpportunityWhenIndustryBanking(Trigger.old);
    }
    
}

/*
* Opportunity trigger should do the following:
* 1. Validate that the amount is greater than 5000.
* 2. Prevent the deletion of a closed won opportunity for a banking account.
* 3. Set the primary contact on the opportunity to the contact with the title of CEO.

    * Question 5
    * Opportunity Trigger
    * When an opportunity is updated validate that the amount is greater than 5000.
    * Error Message: 'Opportunity amount must be greater than 5000'
    * Trigger should only fire on update.

    * Question 6
	* Opportunity Trigger
	* When an opportunity is deleted prevent the deletion of a closed won opportunity if the account industry is 'Banking'.
	* Error Message: 'Cannot delete closed opportunity for a banking account that is won'
	* Trigger should only fire on delete.
    * 
    * Question 7
    * Opportunity Trigger
    * When an opportunity is updated set the primary contact on the opportunity to the contact on the same account with the title of 'CEO'.
    * Trigger should only fire on update.
*/