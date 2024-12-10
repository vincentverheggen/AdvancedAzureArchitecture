# Module 6: Microservices Architecture
#----------------------------------------------------------------------------------------------------------------------
# Exercise 1

# ---------------------------------------------------------------------------------------------------------------------
# Step 1: Create an Azure Key Vault

$kvResourceGroup = "rg-$($prefix)-<resource-group-name>"
az group create --name $kvResourceGroup --location $location

$keyVault = "kv-$($prefix)-keys"
az keyvault create --name $keyVault --resource-group $kvResourceGroup

# ---------------------------------------------------------------------------------------------------------------------
# Step 2: Assign Roles for Key Vault Access

# 2.1 Define your subscription information:

#Your Subscription User Principal Name (UPN).
#You can find this by opening Microsoft Entra ID in the Azure portal or by clicking on your profile picture in the top-right corner, under your name.
#This UPN is required to assign your account the Key Vault Secrets Officer role.
$subscriptionUPN = "<subscription-upn>"

#Your subscription Id
$subscriptionId = "<subscription-id>"

# 2.2 Create a role assignment for Key Vault Secrets Officer:

az role assignment create `
  --assignee $subscriptionUPN `
  --role "Key Vault Secrets Officer" `
  --scope "/subscriptions/$subscriptionId/resourceGroups/$kvResourceGroup/providers/Microsoft.KeyVault/vaults/$keyVault"

# ----------------------------------------------------------------------------------------------------------------------
# Step 3: Add Your Endpoints as Secrets to the Key Vault

# 3.1 Add the SignalR endpoint as a secret:

az keyvault secret set --name SignalR --vault-name $keyVault --value $signalrEndpoint

# 3.2 Add the ACS (SMTP) endpoint as a secret:

az keyvault secret set --name ACS --vault-name $keyVault --value $smtp

# ----------------------------------------------------------------------------------------------------------------------
# Step 4: Create a Managed Identity and Assign Roles

# 4.1 Create a Managed Identity

$identityName = "mi-$($prefix)-<managed-identity-name>"
az identity create --name $identityName --resource-group $apiResourceGroup

# ----------------------------------------------------------------------------------------------------------------------
# Step 5: Use Key Vault Secrets in the Game API Container

# 5.2 Apply the secrets as environment variables for your game API container:

az containerapp up `
  --name $gameApi `
  --resource-group $apiResourceGroup `
  --image ghcr.io/$gitRepositoryOwner/gameapi-rockpaperscissors:module2-signalr `
  --registry-server ghcr.io `
  --registry-username $gitRepositoryOwner --registry-password $gitPAT `
  --env-vars GAME_API_SIGNALR="secretref:signalrconnectionstring" GAME_API_BOTAPI=$botContainerUrl GAME_API_HOST=$gameContainerUrl GAME_API_SMTPSERVER="secretref:acsconnectionstring" GAME_API_SMTP_SENDER=$senderDnR
