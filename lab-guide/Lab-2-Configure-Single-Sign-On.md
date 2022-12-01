# Lab 2 : Configure Single Sign-On
 
In this lab, you will configure Single Sign-On for Spring Cloud Gateway using Azure Active Directory.
 
### Task 1 : Configure Spring Cloud Gateway with SSO  

1. Run the following command to configure Spring Cloud Gateway with SSO enabled:

   ```shell
   az spring gateway update \
       --client-id ${CLIENT_ID} \
       --client-secret ${CLIENT_SECRET} \
       --scope ${SCOPE} \
       --issuer-uri ${ISSUER_URI} \
       --no-wait
   ```   

   ![](Images/mjv2-13.png)

### Task 2 : Update the Existing Applications 

1. Run the following command to update the existing applications to use authorization information from Spring Cloud Gateway:

   ```shell
   # Update the Cart Service
   az spring app update --name ${CART_SERVICE_APP} \
       --env "AUTH_URL=https://${GATEWAY_URL}" "CART_PORT=8080" 
    
   # Update the Order Service
   az spring app  update --name ${ORDER_SERVICE_APP} \
       --env "AcmeServiceSettings__AuthUrl=https://${GATEWAY_URL}" 
   ```
   ![](Images/mjv2-14.png)


### Task 3 : Login to the Application through Spring Cloud Gateway 

1. Run the following command to retrieve the URL for Spring Cloud Gateway and then open the output in a browser:

   ```shell
   echo "https://${GATEWAY_URL}"
   ```
   ![](Images/mjv2-10.png)
 
1. You should see the ACME Fitness Store Application, and then click on **Login** button.
   
   ![](Images/gateway-login.png)
   
1. Click on **Accept** inorder to able to log in using your SSO Credentials. 

   ![](Images/mjv2-15.png)
   
1. Once logged in, the remaining functionality of the application will be available. Click on **Catalog** to see the list of products.

   ![](Images/mjv2-34.png)
   
1. Click on **Yoga Mat** to add this item in your cart.  
   
   ![](Images/mjv2-35.png)

1. Under Yoga Mat, click on Add to cart.
   
   ![](Images/mjv2-36.png) 

1. Now click on **1 items in cart** to proceed futher to place an order.   
   
   ![](Images/mjv2-37.png)
   
1. To place an order, click on **Proceed to checkout**.
   
   ![](Images/mjv2-38.png)
   
1. On the Address pane of the checkout page, fill the following details and then click on **Continue to Delivery Method**:

  - Firstname: odl

  - Lastname: user
  
  - City: Seattle
  
  - ZIP: 123456
  
  - State: Washington
  
  - Country: USA
  
  - Leave the other values as blank  
  
    ![](Images/mjv2-39.png)
   
1. On the Delivery Method pane, click on **Continue to Payment Method**.   
   
   ![](Images/mjv2-40.png)
   
1. On the Payment Method pane, fill the following details and then click on **Continue to Order Review**.

  - Card Type: American Express
  
  - Credit Card Number: 1234567890123456
  
  - CCV: 678
  
  - Expiration Month: 01
  
  - Expiration Year: 2024    
   
    ![](Images/mjv2-41.png)
   
1. On the Order Review pane, click on **Place an Order**.   
   
   ![](Images/mjv2-42.png)
   
1. After that you will recieve a pop-up page for Successfully placing an order.
  
   ![](Images/mjv2-43.png)

### Task 4 : Configure SSO for API Portal 

1. To configure API Portal with SSO enabled, run the following command:

   ```shell
   export PORTAL_URL=$(az spring api-portal show | jq -r '.properties.url')

   az spring api-portal update \
       --client-id ${CLIENT_ID} \
       --client-secret ${CLIENT_SECRET}\
       --scope "openid,profile,email" \
       --issuer-uri ${ISSUER_URI}
   ```

    ![](Images/mjv2-17.png)

### Task 5 : Explore the API using API Portal 

1. Run the following command to retrieve the URL for API Portal and then open the output in a browser: 

   ```shell
   echo "https://${PORTAL_URL}"
   ```

    ![](Images/mjv2-16.png)

1. To access the API Portal, click on **Sign in via SSO**. 

    ![](Images/api-login.png)
   
1. Once logged in via SSO credentials, you can now explore the API portal.
   
    ![](Images/mjv2-44.png)
