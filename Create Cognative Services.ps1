## This creates cognitive services for analysing the tweets

## Log in to your Azure subscription using the Add-AzureRmAccount command and follow the on-screen directions.

Add-AzureRmAccount

## Select the subscription

Set-AzureRmContext -SubscriptionId YOUR SUBSCRIPTION ID HERE

#region variables
# The data center and resource name for your resources
$resourcegroupname = "twitterresource"
$location = "WestEurope"
$APIName = 'TweetAnalysis'
#endregion

#region Create Service

#Create the cognitive services

$newAzureRmCognitiveServicesAccountSplat = @{
    ResourceGroupName = $resourcegroupname
    Location = $location
    SkuName = 'F0'
    Name = $APIName
    Type = 'TextAnalytics'
}
New-AzureRmCognitiveServicesAccount @newAzureRmCognitiveServicesAccountSplat

# Get the Key

$getAzureRmCognitiveServicesAccountKeySplat = @{
    Name = $APIName
    ResourceGroupName = $resourcegroupname
}
Get-AzureRmCognitiveServicesAccountKey @getAzureRmCognitiveServicesAccountKeySplat 
#endregion

#region Forgot the details

# Copy the URL if you forget to save it

$getAzureRmCognitiveServicesAccountSplat = @{
    Name = $APIName
    ResourceGroupName = $resourcegroupname
}
(Get-AzureRmCognitiveServicesAccount @getAzureRmCognitiveServicesAccountSplat).Endpoint | Clip

# Copy the Key if you forgot

$getAzureRmCognitiveServicesAccountKeySplat = @{
    Name = $APIName
    ResourceGroupName = $resourcegroupname
}
(Get-AzureRmCognitiveServicesAccountKey @getAzureRmCognitiveServicesAccountKeySplat).Key1 | Clip

#endregion