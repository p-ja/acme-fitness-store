# Lab 4 : Securely Load Application Secrets

In this lab, you will use Azure Key Vault to securely store and load secrets to connect to Azure services.

### Task 1 : Activate applications to load secrets from Azure Key Vault

1. If you are not logged in already, click on Azure portal shortcut that is available on the desktop and log in with below Azure credentials.
    * Azure Username/Email: <inject key="AzureAdUserEmail"></inject> 
    * Azure Password: <inject key="AzureAdUserPassword"></inject>
    
1.  Click on the Cloud shell icon on the top right – > Next to the search bar.    

1. Select on bash shell to launch.

1. Select the subscription and storage account. If you do not have existing storage account , you need to create a one.

1. Once the cloud drive is created, cloud shell will be launched.

1. To delete Service Connectors and activate applications to load secrets from Azure Key Vault, run the following command in the bash shell pane.

```shell
az spring connection delete \
    --resource-group ${RESOURCE_GROUP} \
    --service ${SPRING_APPS_SERVICE} \
    --connection ${ORDER_SERVICE_DB_CONNECTION} \
    --app ${ORDER_SERVICE_APP} \
    --deployment default \
    --yes 

az spring connection delete \
    --resource-group ${RESOURCE_GROUP} \
    --service ${SPRING_APPS_SERVICE} \
    --connection ${CATALOG_SERVICE_DB_CONNECTION} \
    --app ${CATALOG_SERVICE_APP} \
    --deployment default \
    --yes 

az spring connection delete \
    --resource-group ${RESOURCE_GROUP} \
    --service ${SPRING_APPS_SERVICE} \
    --connection ${CART_SERVICE_CACHE_CONNECTION} \
    --app ${CART_SERVICE_APP} \
    --deployment default \
    --yes 
    
az spring app update --name ${ORDER_SERVICE_APP} \
    --env "ConnectionStrings__KeyVaultUri=${KEYVAULT_URI}" "AcmeServiceSettings__AuthUrl=https://${GATEWAY_URL}" "DatabaseProvider=Postgres"

az spring app update --name ${CATALOG_SERVICE_APP} \
    --config-file-pattern catalog/default,catalog/key-vault \
    --env "SPRING_CLOUD_AZURE_KEYVAULT_SECRET_PROPERTY_SOURCES_0_ENDPOINT=${KEYVAULT_URI}" "SPRING_CLOUD_AZURE_KEYVAULT_SECRET_PROPERTY_SOURCES_0_NAME='acme-fitness-store-vault'" "SPRING_PROFILES_ACTIVE=default,key-vault"
    
az spring app update --name ${IDENTITY_SERVICE_APP} \
    --config-file-pattern identity/default,identity/key-vault \
    --env "SPRING_CLOUD_AZURE_KEYVAULT_SECRET_PROPERTY_SOURCES_0_ENDPOINT=${KEYVAULT_URI}" "SPRING_CLOUD_AZURE_KEYVAULT_SECRET_PROPERTY_SOURCES_0_NAME='acme-fitness-store-vault'" "SPRING_PROFILES_ACTIVE=default,key-vault"
    
az spring app update --name ${CART_SERVICE_APP} \
    --env "CART_PORT=8080" "KEYVAULT_URI=${KEYVAULT_URI}" "AUTH_URL=https://${GATEWAY_URL}"
```
