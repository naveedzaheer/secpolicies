#Leverage Azure Logic Apps, Functions and PowerShell to automaticlayy generate email to owners of unused disks

## Here are the steps to enable this demo scenario
1. Create an Azure Function using PowerShell to get the owner of disk using the managed disk's resource id as the input parameter
2. Create a Logic App which uses Resource Graph query to get the data about unattached managed disks 
   - Use an HTTP activity to query the Resource Graph
   - Use the data resultan  
