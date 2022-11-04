# Lab 5 :  Monitor End-to-End

In this unit you will explore live application metrics and query logs to know the health of your applications.

### Task 1 : Add Instrumentation Key to Key Vault

1. If you are not logged in already, click on Azure portal shortcut that is available on the desktop and log in with below Azure credentials.
    * Azure Username/Email: <inject key="AzureAdUserEmail"></inject> 
    * Azure Password: <inject key="AzureAdUserPassword"></inject>
    
1.  Click on the Cloud shell icon on the top right – > Next to the search bar.    

1. Select on bash shell to launch.

1. Select the subscription and storage account. If you do not have existing storage account , you need to create a one.

1. Once the cloud drive is created, cloud shell will be launched.

1. The Application Insights Instrumentation Key must be provided for the non-java applications.

   > Note: In future iterations, the buildpacks for non-java applications will support
   > Application Insights binding and this step will be unnecessary.

1. To retrieve the Instrumentation Key for Application Insights and add to Key Vault, run the following command in the bash shell pane.

   ```shell
   export INSTRUMENTATION_KEY=$(az monitor app-insights component show --app ${SPRING_APPS_SERVICE} | jq -r '.connectionString')

   az keyvault secret set --vault-name ${KEY_VAULT} \
      --name "ApplicationInsights--ConnectionString" --value ${INSTRUMENTATION_KEY}
   ```
   ![](Images/mjv2-45.png)

### Task 2 : Update Sampling Rate

1. To Increase the sampling rate for the Application Insights binding, run the following command in the bash shell pane.

   ```shell
   az spring build-service builder buildpack-binding set \
      --builder-name default \
      --name default \
      --type ApplicationInsights \
      --properties sampling-rate=100 connection_string=${INSTRUMENTATION_KEY}
   ```

### Task 3 : Reload Applications

1. Run the following command to restart applications to reload configuration. For the Java applications, this will allow the new sampling rate to take effect. For the non-java applications, this will allow them to access the Instrumentation Key from Key Vault.

   ```shell
   az spring app restart -n ${CART_SERVICE_APP}
   az spring app restart -n ${ORDER_SERVICE_APP}
   az spring app restart -n ${IDENTITY_SERVICE_APP}
   az spring app restart -n ${CATALOG_SERVICE_APP}
   az spring app restart -n ${PAYMENT_SERVICE_APP}
   ```

   ![](Images/mjv2-28.png)

### Task 4 : Get the log stream for an Application

1. Run the following command to get the latest 100 lines of app console logs from the Catalog Service.

   ```shell
   az spring app logs \
      -n ${CATALOG_SERVICE_APP} \
      --lines 100
   ```

   ![](Images/mjv2-46.png)

1. Run the following command by adding the `-f` parameter, so that you can get real-time log streaming from an app. Try log streaming for the Catalog Service.

   ```shell
   az spring app logs \
      -n ${CATALOG_SERVICE_APP} \
      -f
   ```

   ![](Images/mjv2-47.png)

You can use `az spring app logs -h` to explore more parameters and log stream functionalities.

### Task 5 : Generate Traffic

Use the ACME Fitness Shop Application to generate some traffic. Move throughout the application, view the catalog, or place an order.

1. To continuously generate traffic, use the traffic generator by running the following command.

   ```shell
   cd traffic-generator
   GATEWAY_URL=https://${GATEWAY_URL} ./gradlew gatlingRun-com.vmware.acme.simulation.GuestSimulation
   cd -
   ```

   ![](Images/mjv2-29.png)

Continue on to the next sections while the traffic generator runs.

### Task 6 : Start monitoring apps and dependencies - in Application Insights

Open the Application Insights created by Azure Spring Apps and start monitoring Spring Boot applications. 
You can find the Application Insights in the same Resource Group where you created an Azure Spring Apps service instance.

   ![](Images/mjv2-48.png)  

   ![](Images/mjv2-49.png)

1. Navigate to the `Application Map` blade:

   ![](Images/mjv2-50.png)
   
1. Navigate to the `Peforamnce` blade:

   ![](Images/mjv2-51.png)

1. Navigate to the `Performance/Dependenices` blade - you can see the performance number for dependencies, particularly SQL calls:

   ![](Images/mjv2-52.png)

1. Navigate to the `Performance/Roles` blade - you can see the performance metrics for individual instances or roles:

   ![](Images/mjv2-53.png)
   
1. Click on a SQL call to see the end-to-end transaction in context:

   
   
1. Navigate to the `Failures` blade and the `Exceptions` panel - you can see a collection of exceptions:

   ![](Images/mjv2-54.png)
   
1. Navigate to the `Metrics` blade - you can see metrics contributed by Spring Boot apps, Spring Cloud modules, and dependencies. The chart below shows `http_server_requests` and `Heap Memory Used`.

   ![](Images/mjv2-55.png)

   ![](Images/mjv2-56.png)

   Spring Boot registers a lot number of core metrics: JVM, CPU, Tomcat, Logback...The Spring Boot auto-configuration enables the instrumentation of requests handled by Spring MVC. The REST controllers `ProductController`, and `PaymentController` have been instrumented by the `@Timed` Micrometer annotation at class level.

   * `acme-catalog` application has the following custom metrics enabled:
   * @Timed: `store.products`
   * `acem-payment` application has the following custom metrics enabled:
   * @Timed: `store.payment`

1. You can see these custom metrics in the `Metrics` blade:

   ![](Images/mjv2-57.png)
   
1. Navigate to the `Live Metrics` blade - you can see live metrics on screen with low latencies < 1 second:

   ![](Images/mjv2-60.png)

### Task 7 : Start monitoring ACME Fitness Store's logs and metrics in Azure Log Analytics

Open the Log Analytics that you created - you can find the Log Analytics in the same
Resource Group where you created an Azure Spring Apps service instance.

   ![](Images/mjv2-58.png)

   ![](Images/mjv2-59.png)

1. In the Log Analytics page, selects `Logs` blade and run any of the sample queries supplied below for Azure Spring Apps. Run the following Kusto query to see application logs:

   ```sql
      AppPlatformLogsforSpring 
      | where TimeGenerated > ago(24h) 
      | limit 500
      | sort by TimeGenerated
      | project TimeGenerated, AppName, Log
   ```

   ![](Images/mjv2-61.png)

1. Run the following Kusto query to see `catalog-service` application logs:

   ```sql
      AppPlatformLogsforSpring 
      | where AppName has "catalog-service"
      | limit 500
      | sort by TimeGenerated
      | project TimeGenerated, AppName, Log
   ```
   
   ![](Images/mjv2-62.png)

1. Run the following Kusto query to see errors and exceptions thrown by each app:
  
   ```sql
      AppPlatformLogsforSpring 
      | where Log contains "error" or Log contains "exception"
      | extend FullAppName = strcat(ServiceName, "/", AppName)
      | summarize count_per_app = count() by FullAppName, ServiceName, AppName, _ResourceId
      | sort by count_per_app desc 
      | render piechart
   ```

   ![](Images/mjv2-63.png)

1. Run the following Kusto query to see all in the inbound calls into Azure Spring Apps:

   ```sql
      AppPlatformIngressLogs
      | project TimeGenerated, RemoteAddr, Host, Request, Status, BodyBytesSent, RequestTime, ReqId, RequestHeaders
      | sort by TimeGenerated
   ```
   
   ![](Images/mjv2-64.png)

1. Run the following Kusto query to see all the logs from Spring Cloud Gateway managed by Azure Spring Apps:

   ```sql
      AppPlatformSystemLogs
      | where LogType contains "SpringCloudGateway"
      | project TimeGenerated,Log
   ```

   ![](Images/mjv2-65.png)

1. Run the following Kusto query to see all the logs from Spring Cloud Service Registry managed by Azure Spring Apps:

   ```sql
      AppPlatformSystemLogs
      | where LogType contains "ServiceRegistry"
      | project TimeGenerated, Log
   ```

   ![](Images/mjv2-66.png)

