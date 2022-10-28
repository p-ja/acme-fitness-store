# Lab 1 :  Deploy and Build Applications

In this lab, you will learn how to build and deploy Spring applications to Azure Spring Apps.

### Task 1 : Prepare your environment for deployments

1. If you are not logged in already, click on Azure portal shortcut that is available on the desktop and log in with below Azure credentials.
    * Azure Username/Email: <inject key="AzureAdUserEmail"></inject> 
    * Azure Password: <inject key="AzureAdUserPassword"></inject>
    
1.  Click on the Cloud shell icon on the top right – > Next to the search bar.    

1. Select on bash shell to launch.

1. Select the subscription and storage account. If you do not have existing storage account , you need to create a one.

1. Once the cloud drive is created, cloud shell will be launched.

1. To make a copy of the supplied template, run the following command in the bash shell pane : 

    ```shell
    cp ./scripts/setup-env-variables-template.sh ./scripts/setup-env-variables.sh
    ```

1. Open `./scripts/setup-env-variables.sh` and running the following command :

   ```shell
   cd azure
   vim setup-env-variables.sh
   ```

1. Update the following variables in the setup-env-variables.sh file by running the following commands :

   ```shell
   export SUBSCRIPTION=subscription-id                 # replace it with your subscription-id
   export RESOURCE_GROUP=resource-group-name           # existing resource group 
   export SPRING_APPS_SERVICE=azure-spring-apps-name   # name of the existing azure spring apps service 
   export LOG_ANALYTICS_WORKSPACE=log-analytics-name   # name of the existing log analytics workspace 
   export REGION=region-name                           # region should be same as the region of your azure spring apps service
   ```
   > **Note:** You can use the arrow keys to move around in the file. Press the "CTRL + X" keys to close the file. You will be prompted to save your changes. Press the    "y" key to save your changes and then press enter to exit.

1. Run the following command to move back to the acme-fitness-store directory and then set up the environment :
  
   ```shell
   cd ..
   source ./azure/setup-env-variables.sh
   ```   
  
### Task 2 : Deploy a Hello World service to ASA-E 

In this task, you will try to deploy a very simple hello-world spring boot app to get a high level understanding of how to deploy an asa-e app and access it.

1. To invoke the Spring Initializer for creating the Spring Boot application, run the following command :

   ```shell
   curl https://start.spring.io/starter.tgz -d dependencies=web -d baseDir=hello-world \ -d bootVersion=2.7.5 -d javaVersion=17 -d type=maven-project | tar -xzvf -
   ```

1. Run the following command to create a new file called HelloController.java in the hello-world directory and adding the a new Spring MVC Controller inside that file.

   ```shell
   cd hello-world
   cat > HelloController.java << EOF
   package com.example.demo;

   import org.springframework.web.bind.annotation.GetMapping;
   import org.springframework.web.bind.annotation.RestController;

   @RestController
   public class HelloController {

      @GetMapping("/hello")
      public String hello() {
        return "Hello from Azure Spring Apps Enterprise";
    }
   }
   EOF
   mv HelloController.java src/main/java/com/example/demo/HelloController.java
   ```
1. Run the following command create the 'hello-world' app instance and deploy it to Azure Spring Apps Enterprise:

   ```shell
   az spring app create -n hello-world
   ./mvnw clean package
   az spring app deploy -n hello-world --artifact-path target/demo-0.0.1-SNAPSHOT.jar
   cd ..
   ```

1. Now navigate back to Azure portal and Look for your Azure Spring Apps instance in your resource group.

1. Click on "Apps" in the "Settings" section of the navigation pane and select "hello-world"

1. On the overview page, Find the "Test endpoint" in the "Essentials" section



### Task 3 : Introduction to Acme Fitness app 

This section discusses the demo application that you will be using in this lab to demonstrate the different features of ASA-E.

Below image shows the services involved in the ACME Fitness Store. It depicts the applications and their dependencies on different ASA-E services. We will be implementing this architecture by the end of this workshop.
![acme-fitness](images/end-end-arch.png)

This application is composed of several services:

* 3 Java Spring Boot applications:
  * A catalog service for fetching available products
  * A payment service for processing and approving payments for users' orders
  * An identity service for referencing the authenticated user

* 1 Python application:
  * A cart service for managing a users' items that have been selected for purchase

* 1 ASP.NET Core applications:
  * An order service for placing orders to buy products that are in the users' carts

* 1 NodeJS and static HTML Application
  * A frontend shopping application


  
