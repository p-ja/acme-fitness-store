# Lab 8 :  Automate from idea to production

To get started with deploying this sample app from GitHub Actions, please:

1. Complete an Azure AD App registration outlined [here](#register-application-with-azure-ad) or have SSO Credentials prepared as described [here](#using-an-existing-sso-identity-provider)
2. Fork this repository and turn on GitHub Actions in your fork

### Task 1 : Add Secrets to GitHub Actions

1. If you are not logged in already, click on Azure portal shortcut that is available on the desktop and log in with below Azure credentials.
    * Azure Username/Email: <inject key="AzureAdUserEmail"></inject> 
    * Azure Password: <inject key="AzureAdUserPassword"></inject>
    
1.  Click on the Cloud shell icon on the top right – > Next to the search bar.    

1. Select on bash shell to launch.

1. Select the subscription and storage account. If you do not have existing storage account , you need to create a one.

1. Once the cloud drive is created, cloud shell will be launched.

1. Add the following secrets to GitHub Actions:

   * `AZURE_CREDENTIALS` - using the json result from creating the Service Principal in the previous step.
   * `TF_PROJECT_NAME` - with the value of your choosing. This will be the name of your Terraform Project
   * `AZURE_LOCATION` - this is the Azure Region your resources will be created in.
   * `OIDC_JWK_SET_URI` - use the `JWK_SET_URI` defined in [Unit 2](#unit-2---configure-single-sign-on)
   * `OIDC_CLIENT_ID` - use the `CLIENT_ID` defined in [Unit 2](#unit-2---configure-single-sign-on)
   * `OIDC_CLIENT_SECRET` - use the `CLIENT_SECRET` defined in [Unit 2](#unit-2---configure-single-sign-on)
   * `OIDC_ISSUER_URI` - use the `ISSUER_URI` defined in [Unit 2](#unit-2---configure-single-sign-on)

1. Add the secret `TF_BACKEND_CONFIG` to GitHub Actions with the value (replacing `${STORAGE_ACCOUNT_NAME}` and `${STORAGE_RESOURCE_GROUP}`):

```text
resource_group_name  = "${STORAGE_RESOURCE_GROUP}"
storage_account_name = "${STORAGE_ACCOUNT_NAME}"
container_name       = "terraform-state-container"
key                  = "dev.terraform.tfstate"
```

> Detailed instructions for adding secrets to GitHub Actions can be found [here](https://docs.microsoft.com/azure/spring-cloud/how-to-github-actions?pivots=programming-language-java#set-up-github-repository-and-authenticate-1).

### Task 2 : Run GitHub Actions

1. Now you can run GitHub Actions in your repository. The `provision` workflow will provision all resources created in the first four units. An example run is seen below:

![Output from the provision workflow](media/provision.png)

> Note: The entire provision workflow will run in approximately 60 minutes.

2. Each application has a `Deploy` workflow that will redeploy the application when changes are made to that application. An example output from the catalog service is seen below:

![Output from the Deploy Catalog workflow](media/deploy-catalog.png)

3. The `cleanup` workflow can be manually run to delete all resources created by the `provision` workflow. The output can be seen below:

![Output from the cleanup workflow](media/cleanup.png)

