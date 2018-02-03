## This creates an Azure SQL Database for holding the tweets

## Log in to your Azure subscription using the Add-AzureRmAccount command and follow the on-screen directions.

 Add-AzureRmAccount

## Select the subscription

Set-AzureRmContext -SubscriptionId YOURSUBSCRIPTIONIDHERE

#region variables
# The data center and resource name for your resources
$resourcegroupname = "twitterresource"
$location = "WestEurope"
# The logical server name: Use a random value or replace with your own value (do not capitalize)
$servername = "server-$(Get-Random)"
# Set an admin login and password for your database
# The login information for the server You need to set these and uncomment them - Dont use these values

# $adminlogin = "ServerAdmin"                
# $password = "ChangeYourAdminPassword1"

# The ip address range that you want to allow to access your server - change as appropriate
# $startip = "0.0.0.0"
# $endip = "0.0.0.0"

# To just add your own IP Address
$startip = $endip = (Invoke-WebRequest 'http://myexternalip.com/raw').Content -replace "`n"

# The database name
$databasename = "tweets"

$AzureSQLServer = "$servername.database.windows.net,1433"
$Table = "table.sql"
$Proc = "InsertTweets.sql"
#endregion

#region artifacts
## Create a resource group

New-AzureRmResourceGroup -Name $resourcegroupname -Location $location

## Create a Server

$newAzureRmSqlServerSplat = @{
    SqlAdministratorCredentials = $SqlAdministratorCredentials
    ResourceGroupName = $resourcegroupname
    ServerName = $servername
    Location = $location
}
New-AzureRmSqlServer @newAzureRmSqlServerSplat

# Verify it is created or get it at a later date

$getAzureRmSqlServerSplat = @{
    ResourceGroupName = $resourcegroupname
    ServerName = $servername
}
Get-AzureRmSqlServer @getAzureRmSqlServerSplat

## Create a firewall rule

$newAzureRmSqlServerFirewallRuleSplat = @{
    EndIpAddress = $endip
    AllowAllAzureIPs = $true
    ServerName = $servername
    FirewallRuleName = "AllowSome"
    StartIpAddress = $startip
    ResourceGroupName = $resourcegroupname
}
New-AzureRmSqlServerFirewallRule @newAzureRmSqlServerFirewallRuleSplat

# Allow Azure IPS

$newAzureRmSqlServerFirewallRuleSplat = @{
    AllowAllAzureIPs = $true
    ServerName = $servername
    ResourceGroupName = $resourcegroupname
}
New-AzureRmSqlServerFirewallRule @newAzureRmSqlServerFirewallRuleSplat

# Create a database

$newAzureRmSqlDatabaseSplat = @{
    ServerName = $servername
    ResourceGroupName = $resourcegroupname
    Edition = 'Basic'
    DatabaseName = $databasename
}
New-AzureRmSqlDatabase  @newAzureRmSqlDatabaseSplat
#endregion

#region database create
# Create a credential

$newObjectSplat = @{
    ArgumentList = $adminlogin, $(ConvertTo-SecureString -String $password -AsPlainText -Force)
    TypeName = 'System.Management.Automation.PSCredential'
}
$SqlAdministratorCredentials = New-Object @newObjectSplat

## Using dbatools module

$invokeDbaSqlCmdSplat = @{
    SqlCredential = $SqlAdministratorCredentials
    Database = $databasename
    File = $Table,$Proc
    SqlInstance = $AzureSQLServer
}
Invoke-DbaSqlCmd @invokeDbaSqlCmdSplat
#endregion