public with sharing class AccountTriggerHelper {
    /*
    * Question 1
    * Account Trigger
    * When an account is inserted change the account type to 'Prospect' if there is no value in the type field.
    * Trigger should only fire on insert.
    */
    public static void setTypeProspect(List<Account> accounts) {
        if (accounts == null) {
            return;
        }
        for (Account act : accounts) {
            if (act.Type == null) {
                act.Type = 'Prospect';
            }
        }
    }

    /*
    * Question 2
    * Account Trigger
    * When an account is inserted copy the shipping address to the billing address.
    * BONUS: Check if the shipping fields are empty before copying.
    * Trigger should only fire on insert.
    */
    public static void copyShippingToBillingOnInsert(List<Account> accounts) {
        if (accounts == null) {
            return;
        }
        for (Account act : accounts) {
            if (String.isBlank(act.ShippingStreet)) {
                continue;
            }
            act.BillingStreet = act.ShippingStreet;
            act.BillingCity = act.ShippingCity;
            act.BillingState = act.ShippingState;
            act.BillingPostalCode = act.ShippingPostalCode;
            act.BillingCountry = act.ShippingCountry;
        }
    }

    /*
    * Question 3
    * Account Trigger
	* When an account is inserted set the rating to 'Hot' if the Phone, Website, and Fax ALL have a value.
    * Trigger should only fire on insert.
    */
    public static void setHotRatingWhenAllProvided(List<Account> accounts) {
        if (accounts == null) {
            return;
        }
        for (Account act : accounts) {
            if (String.isNotBlank(act.Phone) && String.isNotBlank(act.Website) && String.isNotBlank(act.Fax)) {
                act.Rating = 'Hot';
            }
        }
    }

    /*
    * Question 4
    * Account Trigger
    * When an account is inserted create a contact related to the account with the following default values:
    * LastName = 'DefaultContact'
    * Email = 'default@email.com'
    * Trigger should only fire on insert.
    */
    public static void createDefaultContactOnInsert(List<Account> accounts) {
        // create a list to store the new contacts to insert
        List<Contact> newAccountContacts = new List<Contact>();
        if (accounts != null) {
            for (Account act : accounts) {
                Contact actContact = new Contact();
                actContact.LastName = 'DefaultContact';
                actContact.Email = 'default@email.com';
                actContact.AccountId = act.Id;
                newAccountContacts.add(actContact);
            }
        }
        if (!newAccountContacts.isEmpty()) {
            Database.insert(newAccountContacts, AccessLevel.USER_MODE);
        }
    }
}
