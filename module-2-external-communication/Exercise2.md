# Module 2 Exercise 2

In this exercise you will establish secure links between the client side and APIM and between the APIM and the APIs using SSL Termination. You will find out how rate throttling works if you wish to track or limit the number of requests to your APIs.

## Estimated time: 45 minutes

## Learning objectives

- Implement API Management.
- Implement rate throttling.
- Configure SSL termination.

## Prerequisites

For this exercise, you will need the following PowerShell variable used previously:

- $staticWebName - name of your Static Web App resource.
- $APIM - name of your API Management deployed at Module 0.

## Step 1: Redeploy the apps

You will need to deploy the new version of the APIs. This version contains a schema with the OpenAPI specifications of the API's so that when you'll import them into the APIM, the endpoints will be automatically generated for you without the need of importing or manually adding them.

The Web Application will also change as it will now call the common endpoint of the APIM resource, instead of using the respective endpoints of each API.

Use commands in [Exercise2.ps1](./Exercise2.ps1)!

## Step 2: Provision the APIs to the APIM resource

For this step you will need to open [Azure Portal](https://portal.azure.com/), on the APIM resource that you created at Module 0.

1. Open the **APIs** tab, where you can add an API to your APIM. Select Container App as your option.

   ![APIM APIs](../module-2-external-communication/images/image1.png)

2. Browse and select the bot container API you created in Module 1. The fields should auto-populate, except for **API URL suffix**, where you should enter the value `bot`

   ![Create from Container App](../module-2-external-communication/images/image2.png)

3. After adding your bot API container app, select it and go to the **Settings** tab where you need to disable **Subscription Required**

   ![Bot API](../module-2-external-communication/images/image3.png)

4. Repeat the steps to add your game API container as well. For the **"API URL suffix"** field, enter `game` for the game container API.

## Step 3: Add CORS to the APIM resource

To ensure that only your Web Application will be able to access the APIs, you should add CORS to the APIM resource.

1. Add CORS to APIM by selecting **All APIs** and adding a policy on the **Inbound Processing section**

   ![APIM API CORS settings](../module-2-external-communication/images/image4.png)

2. Select **CORS** policy, go to the **Full** tab, and add your url to the static web app in the **"Allowed Origins"** field. Make sure to enable **GET** and **POST** methods, set the allowed headers and exposed headers to *, then press the save button.

   ![APIM API CORS origins](../module-2-external-communication/images/image5.png)

## Step 4: Redeploy static web app with APIM url

To be able to deploy the version of the app with the APIM functionality, you need to change the deployment workflow under `./github/workflows`, more exactly, you have to change

| Variable | New value |
| -- | -- |
| app_location | "/module-2-external-communication/src/Exercise_2/RockPaperScissors" |
| api_location | "/module-2-external-communication/src/Exercise_2/RockPaperScissorsAPI" |

Then, you can change the environment variables of the Static Web App with the new APIM_URL value.

Use commands from [Exercise2.ps1](./Exercise2.ps1)

## Step 5: Implement rate throttling

To implement rate throttling for the APIs inside your APIM resource, you need to add a policy.

- On the **APIs** tab, select either the bot or game API, or select both by choosing **All APIs**. Here, you will click **Add policy** under **Inbound processing**. Then, add a **rate-limit-by-key** policy, completing the fields with values for rate throttling as shown in this example:

![APIM API setting "rate-limit-by-key"](../module-2-external-communication/images/image7.png)

After implementing rate throttling, the endpoint(s) of the API(s) you selected will have a limit of how many requests can be made by someone in the period of time that you set.

## Step 6: Implement SSL Termination

Now you can secure the traffic of your API by enabling SSL Termination for the APIM.

### 6.1. Navigate to your APIM resource

### 6.2 Configure SSL Termination

Go to **Protocols + ciphers** under **Security** tab and **enable SSL** for both **Client protocol** and **Backend protocol**. Make sure to click **Enable** before saving. After that, press the **Save** button.

![APIM Security settings for Protocols + ciphers: enable SSL](../module-2-external-communication/images/image6.png)

Now the traffic will be secure, making the data unreadable if it's intercepted.

> [!NOTE]
> In case the update takes time you can check the progress from the az cli using the command in [Exercise2.ps1](./Exercise2.ps1).


