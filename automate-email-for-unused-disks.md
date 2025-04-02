# Leverage Azure Logic Apps, Functions and PowerShell to automaticlayy generate email to owners of unused disks

## Here are the steps to enable this demo scenario
1. Create an Azure Function using PowerShell to get the owner of disk using the managed disk's resource id as the input parameter
   - Make sure to assign it a Managed Idenity (System or User)
   - Make sure to give that Managed Idenity Reader access to all the subscriptions. If theer are too many subscriptions then give it Reader access to the Management Group [See this resource](https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/how-to-assign-access-azure-resource?pivots=identity-mi-access-portal) 
   - Please give the managed identity access to **Directory.Read.All** to AD Graph using [this script](https://github.com/naveedzaheer/secpolicies/blob/main/MSIGraphPermit.psd1)
   - Make sure to use this [requirements.psd1](https://github.com/naveedzaheer/secpolicies/blob/main/GetOwnerEmailFunction/requirements.ps1) file  to minimize load time as it only lists the required PowerShell Modules
   - Make sure to use this [host.json](https://github.com/naveedzaheer/secpolicies/blob/main/GetOwnerEmailFunction/host.json) as it has the flag to enable managed dependencies
   - Code for the Function is available in [run.ps1](https://github.com/naveedzaheer/secpolicies/blob/main/GetOwnerEmailFunction/run.ps1)
2. Create a Logic App which uses Resource Graph query to get the data about unattached managed disks 
   - Make sure to assign it a Managed Idenity (System or User)
   - Make sure to give that Managed Idenity Reader access to all the subscriptions. If there are too many subscriptions then give it Reader access to the Management Group [See this resource](https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/how-to-assign-access-azure-resource?pivots=identity-mi-access-portal) 
   - Please use the [logic app code here](https://github.com/naveedzaheer/secpolicies/blob/main/automate-email-for-unused-disks-logicapp.json) to create your logic app
   - Please make sure to update the 
     - [your-azure-subscription-id] with your subscrition id. 
     - [your-resource-group-name] with your resource group name. 
     - [your-function-app-name] with the name of the PowerSehll function app name that you created earlier. 
     - [your-function-name] with the name of your function. 
   - Here are the main Logic App Activities
     - Trigger is HTTP for the demo. It should be a Recurrence trigger in real production scenario so it can run automatically on periodic basis
     - HTTP Activity to query Azure Resource Graph to get the unattached disk
     - For Each Loop to go through each disk resource
     - Parse JSON and Compose activities to extract the disk's resource id
     - Call Function activity to call the function to get owner's email
     - Send Email actity to send email to the Owner about unattached disk
     - Here is the workflow diagram for reference 
     - ![Here is the workflow diagram for reference](https://github.com/naveedzaheer/secpolicies/blob/main/Workflow.png)
