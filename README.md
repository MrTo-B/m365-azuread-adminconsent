# Microsoft 365 User Consent

A simple PowerShell script to automate Administrator Consent in a Microsoft Tenant 365. This activates the following options in Azure Active Directory: 

## Azure Active Directory ##

* Dashboard > Enterprise applications > Consent and permissions | User consent settings
  * User consent for applications
    * Do not allow user consent
  * Group owner consent for apps accessing data
    * Do not allow group owner consent

## Application creation ##
Once User Consent is deactivated, URL's will be generated to pre-register Apple Internet Accounts and Gmail so users won't lose access to their e-mail.
Use the URL's the provide administrator consent within the tenant, by logging in with an account that has application administrator access.

## Manual configuration ##
As it is not possible to automate the Admin Consent Request Workflow in Microsoft 365, this has to be done manually.
Under Dashboard > Enterprise applications > User settings you must activate the following options:

Enterprise applications | Toggle
------------ | -------------
Users can consent to apps accessing company data on their behalf | No
Users can consent to apps accessing company data for the groups they own | No
Users can add gallery apps to My Apps | No

Admin consent requests | Toggle
------------ | -------------
Users can request admin consent to apps they are unable to consent to | Yes
Who can review admin consent requests | *Select Users/Groups/Roles* 
Selected users will receive email notifications for requests | Yes
Selected users will receive request expiration reminders | Yes
