# Module 2 Exercise 1

In this exercise, you will add real-time functionality to the app by using an [**Azure SignalR**](https://learn.microsoft.com/en-us/azure/azure-signalr/signalr-overview) resource. You will also add an [**Azure Communication Service**](https://learn.microsoft.com/en-us/azure/communication-services/overview) resource for using a SMTP(Simple Mail Transfer Protocol) to invite your friends via email and getting notified about session results.

SignalR is a library for ASP.NET that enables web apps to have real-time functionalities. If you want to learn more about SignalR [click here](https://learn.microsoft.com/en-us/aspnet/signalr/overview/getting-started/introduction-to-signalr).

## Estimated time: 45 minutes

## Learning objectives

- Deploy and configure SignalR Service
- Create an Azure Communication Service and use it in your app

## Prerequisites

To begin this module you will need the Azure resources that you deployed in the first region during
 **Module 1: Azure Architecture Introduction**:

- Container APIs for Game API and Bot API;
- Static Web App for the "Rock, Paper, Scissors" game;

During this module you will also need the following PowerShell variables used previously:

- $gitPAT - your GitHub token (PAT) value
- $gitRepositoryOwner - your GitHub owner name (lowercase)
- $EmailResourceGroup - name of the Resource Group deployed at Module 0
- $location - location of the first region deployed
- $ApiResourceGroup - name of the Resource Group in which you have your Container APIs and Static Web App, from the first region
- $staticWebName - name of your Static Web App resource
- $gameApi - name of the Game Container API deployed in the first region
- $botApi - name of the Bot Container API deployed in the first region
- $gameContainerUrl -  URL for your Game Container API
- $botContainerUrl - URL for your Bot Container API

If you don't have the PowerShell variables in your chosen terminal anymore, please make sure that you create them before starting this exercise.

## Step 1: Create the Azure SignalR Service Resource

To use SignalR in your applications, you need to first deploy an Azure SignalR Service so that the hub will be hosted on the cloud.

### 1.1 Give a name to your SignalR Resource

### 1.2. Create the SignalR resource

## Step 2: Copy the Connection String of the SignalR Service

To get the connection string of your SignalR Service, you need to access the newly created resource in the [Azure Portal](https://portal.azure.com/).

### 2.1 Navigate to your SignalR Service Resource. You should find it in the resource group where you created it

### 2.2 In the side menu, under **Settings**, you should find the **Connection Strings** tab

### 2.3 Copy the Primary Connection String from the **For access key** section

### 2.4 Set the Connection String inside your console

## Step 3: Create an Azure Communication Service resource

### 3.1 To send e-mails to the users of the application, you will need an Azure Communication Service with SMTP capabilities.

    If you want to choose a different region for your Azure Communication Service **"--data-location"**, you can review the available regions [here](https://learn.microsoft.com/en-us/azure/communication-services/concepts/privacy#data-residency)

    > [!NOTE]
    > On the first use of this az command, the terminal might request to install the communication extension, if so, please agree with the install and the command will continue to run after the extension is installed.

### 3.2. Azure Communication Service has multiple ways of client communication. To use the email functionality, you will need an **Azure Email Communication Service**

### 3.3. The Email Communication Service also needs a **Email Communication Services Domain** to use it for sending emails

## Step 4: Set the Connection String and the Sender Address and redeploy the apps

To see the changes of the application, you will have to redeploy the API's container and the Web Application.

1. You can find the Connection String in the Azure Portal, if you navigate to your **Azure Communication Service** resource, on the side menu, under **Settings** you will find the **Keys** tab
2. Save the DoNotReply email address from which the emails will be sent. You should find it in the **Email Communication Services Domain** resource, under the **MailFrom addresses** tab.
3. Redeploy the API's with the new Environment Variables
4. To deploy the version of the app with the SignalR functionality, you need to change the deployment workflow generated for your static web app under `./github/workflows/`. There should be a file azure-static-web-apps-*.yml.

   | Variable | New value |
   | -- |  -- |
   | app_location  | "/module-2-external-communication/src/Exercise_1/RockPaperScissors" |
   | api_location  | "/module-2-external-communication/src/Exercise_1/RockPaperScissorsAPI" |

   Then, you can change the environment variables of the Static Web App with the new SignalR connection string and the sender email address.

5. Update the Environment Variables of the Static Web App to use SignalR

## Step 5: Add your domain to Communication Service

Open Azure Communication Service and navigate to the Email section. Under this section, open the Domains tab, where you can connect your previously created email domain. Select the appropriate Resource Group and Subscription where the domain was created, as shown in the image.

![Azure Communication Service and navigate to the Email section](../module-2-external-communication/images/image8.png)

## Step 6: Test the apps

Now that you redeployed the apps, you can test the game flow, and you should see that now the status and the game result will update in real time as you play.

You will notice that now you have to enter your e-mail address to be able to play. You can also invite players by sending them an e-mail with the join link. At the end of a game, both players should receive an e-mail with the result of the session.
