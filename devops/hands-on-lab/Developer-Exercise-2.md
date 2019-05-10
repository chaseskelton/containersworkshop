![](https://github.com/Microsoft/MCW-Template-Cloud-Workshop/raw/master/Media/ms-cloud-workshop.png "Microsoft Cloud Workshops")

<div class="MCWHeader1">
Containers and DevOps - Developer edition
</div>

<div class="MCWHeader2">
Hands-on lab step-by-step - Exercise 2
</div>

<div class="MCWHeader3">
April 2019
</div>

Information in this document, including URL and other Internet Web site references, is subject to change without notice. Unless otherwise noted, the example companies, organizations, products, domain names, e-mail addresses, logos, people, places, and events depicted herein are fictitious, and no association with any real company, organization, product, domain name, e-mail address, logo, person, place or event is intended or should be inferred. Complying with all applicable copyright laws is the responsibility of the user. Without limiting the rights under copyright, no part of this document may be reproduced, stored in or introduced into a retrieval system, or transmitted in any form or by any means (electronic, mechanical, photocopying, recording, or otherwise), or for any purpose, without the express written permission of Microsoft Corporation.

Microsoft may have patents, patent applications, trademarks, copyrights, or other intellectual property rights covering subject matter in this document. Except as expressly provided in any written license agreement from Microsoft, the furnishing of this document does not give you any license to these patents, trademarks, copyrights, or other intellectual property.

The names of manufacturers, products, or URLs are provided for informational purposes only and Microsoft makes no representations and warranties, either expressed, implied, or statutory, regarding these manufacturers or the use of the products with any Microsoft technologies. The inclusion of a manufacturer or product does not imply endorsement of Microsoft of the manufacturer or product. Links may be provided to third party sites. Such sites are not under the control of Microsoft and Microsoft is not responsible for the contents of any linked site or any link contained in a linked site, or any changes or updates to such sites. Microsoft is not responsible for webcasting or any other form of transmission received from any linked site. Microsoft is providing these links to you only as a convenience, and the inclusion of any link does not imply endorsement of Microsoft of the site or the products contained therein.

© 2019 Microsoft Corporation. All rights reserved.

Microsoft and the trademarks listed at https://www.microsoft.com/en-us/legal/intellectualproperty/Trademarks/Usage/General.aspx are trademarks of the Microsoft group of companies. All other trademarks are property of their respective owners.

**Contents**

<!-- TOC -->

- [Containers and DevOps - Developer edition hands-on lab step-by-step]
  - [Exercise 2: Deploy the solution to Azure Kubernetes Service](#exercise-2-deploy-the-solution-to-azure-kubernetes-service)
    - [Task 1: Tunnel into the Azure Kubernetes Service cluster](#task-1-tunnel-into-the-azure-kubernetes-service-cluster)
    - [Task 2: Deploy a service using the Kubernetes management dashboard](#task-2-deploy-a-service-using-the-kubernetes-management-dashboard)
    - [Task 3: Deploy a service using kubectl](#task-3-deploy-a-service-using-kubectl)
    - [Task 4: Deploy a service using a Helm chart](#task-4-deploy-a-service-using-a-helm-chart)
    - [Task 5: Initialize database with a Kubernetes Job](#task-5-initialize-database-with-a-kubernetes-job)
    - [Task 6: Test the application in a browser](#task-6-test-the-application-in-a-browser)
    - [Task 7: Configure Continuous Delivery to the Kubernetes Cluster](#task-7-configure-continuous-delivery-to-the-kubernetes-cluster)
    - [Task 8: Review Azure Monitor for Containers](#task-8-review-azure-monitor-for-containers)
  

<!-- /TOC -->

# Containers and DevOps - Developer edition hands-on lab step-by-step


## Exercise 2: Deploy the solution to Azure Kubernetes Service

**Duration**: 30 minutes

In this exercise, you will connect to the Azure Kubernetes Service cluster you created before the hands-on lab and deploy the Docker application to the cluster using Kubernetes.

### Task 1: Tunnel into the Azure Kubernetes Service cluster

In this task, you will gather the information you need about your Azure Kubernetes Service cluster to connect to the cluster and execute commands to connect to the Kubernetes management dashboard from your local machine.

1. Open your WSL console (close the connection to the build agent if you are connected). From this WSL console, ensure that you installed the Azure CLI correctly by running the following command:

    ```bash
    az --version
    ```

    -  This should produce output similar to this:

    ![In this screenshot of the WSL console, example output from running az --version appears. At this time, we are unable to capture all of the information in the window. Future versions of this course should address this.](media/image73.png)

    - If the output is not correct, review your steps from the instructions in Task 11: Install Azure CLI from the instructions before the lab exercises.

2. Also, check the installation of the Kubernetes CLI (kubectl) by running the following command:

    ```bash
    kubectl version
    ```

    - This should produce output similar to this:

    ![In this screenshot of the WSL console, kubectl version has been typed and run at the command prompt, which displays Kubernetes CLI client information.](media/image74.png)

    - If the output is not correct, review the steps from the instructions in Task 12: Install Kubernetes CLI from the instructions before the lab exercises.

3. Once you have installed and verified Azure CLI and Kubernetes CLI, login with the following command, and follow the instructions to complete your login as presented:

    ```bash
    az login
    ```

4. Verify that you are connected to the correct subscription with the following command to show your default subscription:

    ```bash
    az account show
    ```

    a. If you are not connected to the correct subscription, list your subscriptions and then set the subscription by its id with the following commands (similar to what you did in cloud shell before the lab):

    ```bash
    az account list
    az account set --subscription {id}
    ```

5. Configure kubectl to connect to the Kubernetes cluster:

    ```bash
    az aks get-credentials --name fabmedical-SUFFIX --resource-group fabmedical-SUFFIX
    ```

6. Test that the configuration is correct by running a simple kubectl command to produce a list of nodes:

    ```bash
    kubectl get nodes
    ```

    ![In this screenshot of the WSL console, kubectl get nodes has been typed and run at the command prompt, which produces a list of nodes.](media/image75.png)

7. Since the AKS cluster uses RBAC, a ClusterRoleBinding must be created before you can correctly access the dashboard. To create the required binding, execute the command bellow:

    ```bash
    kubectl create clusterrolebinding kubernetes-dashboard --clusterrole=cluster-admin --serviceaccount=kube-system:kubernetes-dashboard
    ```

8. Create an SSH tunnel linking a local port (8001) on your machine to port 80 on the management node of the cluster. Execute the command below replacing the values as follows:

   > **Note**: After you run this command, it may work at first and later lose its connection, so you may have to run this again to reestablish the connection. If the Kubernetes dashboard becomes unresponsive in the browser this is an indication to return here and check your tunnel or rerun the command.

    ```bash
    az aks browse --name fabmedical-SUFFIX --resource-group fabmedical-SUFFIX
    ```

    ![In this screenshot of the WSL console, the output of the above command produces output similar to the following: Password for private key: Proxy running on 127.0.0.1:8001/ui Press CTRL+C to close the tunnel \... Starting to server on 127.0.0.1:8001](media/image76.png)

9. Open a browser window and access the Kubernetes management dashboard at the Services view. To reach the dashboard, you must access the following address:

    ```bash
    http://localhost:8001
    ```

10. If the tunnel is successful, you will see the Kubernetes management dashboard.

    ![This is a screenshot of the Kubernetes management dashboard. Overview is highlighted on the left, and at right, kubernetes has a green check mark next to it. Below that, default-token-s6kmc is listed under Secrets.](media/image77.png)

### Task 2: Deploy a service using the Kubernetes management dashboard

In this task, you will deploy the API application to the Azure Kubernetes Service cluster using the Kubernetes dashboard.

1. From the Kubernetes dashboard, select Create in the top right corner.

2. From the Resource creation view, select Create an App.

    ![This is a screenshot of the Deploy a Containerized App dialog box. Specify app details below is selected, and the fields have been filled in with the information that follows. At the bottom of the dialog box is a SHOW ADVANCED OPTIONS link.](media/image78.png)

    - Enter "api" for the App name.

    - Enter [LOGINSERVER]/content-api for the Container Image, replacing [LOGINSERVER] with your ACR login server, such as fabmedicalsol.azurecr.io.

    - Set Number of pods to 1.

    - Set Service to "Internal".

    - Use 3001 for Port and 3001 for Target port.

3. Select SHOW ADVANCED OPTIONS-----

    - Enter 0.125 for the CPU requirement.

    - Enter 128 for the Memory requirement.

    ![In the Advanced options dialog box, the above information has been entered. At the bottom of the dialog box is a Deploy button.](media/image79.png)

4. Select Deploy to initiate the service deployment based on the image. This can take a few minutes. In the meantime, you will be redirected to the Overview dashboard. Select the API deployment from the Overview dashboard to see the deployment in progress.

    ![This is a screenshot of the Kubernetes management dashboard. Overview is highlighted on the left, and at right, a red arrow points to the api deployment.](media/image80.png)

5. Kubernetes indicates a problem with the api Replica Set.  Select the log icon to investigate.

    ![This screenshot of the Kubernetes management dashboard shows an error with the replica set.](media/Ex2-Task1.5.png)

6. The log indicates that the content-api application is once again failing because it cannot find a mongodb instance to communicate with.  You will resolve this issue by migrating your data workload to CosmosDb.

    ![This screenshot of the Kubernetes management dashboard shows logs output for the api container.](media/Ex2-Task1.6.png)

7. Open the Azure portal in your browser and click "+ Create a resource".  Search for "Azure Cosmos DB", select the result and click "Create".

    ![A screenshot of the Azure Portal selection to create Azure Cosmos DB.](media/Ex2-Task1.7.1.png)

8. Configure Azure Cosmos DB as follows and click "Review + create" and then click "Create":

    - **Subscription**: Use the same subscription you have used for all your other work.

    - **Resource Group**: fabmedical-SUFFIX

    - **Account Name**: fabmedical-SUFFIX

    - **API**: Azure Cosmos DB for MongoDB API

    - **Location**: Choose the same region that you did before.

    - **Geo-redundancy**: Enabled (checked)

    ![A screenshot of the Azure Portal settings blade for Cosmos DB.](media/Ex2-Task1.8.1.png)

9. Navigate to your resource group and find your new CosmosDb resource.  Click on the CosmosDb resource to view details.

    ![A screenshot of the Azure Portal showing the Cosmos DB among existing resources.](media/Ex2-Task1.9.png)

10. Under "Quick Start" select the "Node.js" tab and copy the Node 3.0 connection string.

    ![A screenshot of the Azure Portal showing the quick start for setting up Cosmos DB with MongoDB API.](media/Ex2-Task1.10.png)

11. Update the provided connection string with a database "contentdb" and a replica set "globaldb".

    >**Note**: User name and password redacted for brevity.

    ```text
    mongodb://<USERNAME>:<PASSWORD>@fabmedical-sol2.documents.azure.com:10255/contentdb?ssl=true&replicaSet=globaldb
    ```

12. You will setup a Kubernetes secret to store the connection string, and configure the content-api application to access the secret.  First, you must base64 encode the secret value.  Open your WSL window and use the following command to encode the connection string and then, copy the output.

    ```bash
    echo -n "<connection string value>" | base64 -w 0
    ```

13. Return to the Kubernetes UI in your browser and click "+ Create".  Update the following YAML with the encoded connection string from your clipboard, paste the YAML data into the create dialog and click "Upload".

    ```yaml
    apiVersion: v1
    kind: Secret
    metadata:
        name: mongodb
    type: Opaque
    data:
        db: <base64 encoded value>
    ```

    ![A screenshot of the Kubernetes management dashboard showing the YAML file for creating a deployment.](media/Ex2-Task1.13.png)

14. Scroll down in the Kubernetes dashboard until you can see "Secrets" in the left-hand menu.  Click it.

    ![A screenshot of the Kubernetes management dashboard showing secrets.](media/Ex2-Task1.14.png)

15. View the details for the "mongodb" secret.  Click the eyeball icon to show the secret.

    ![A screenshot of the Kubernetes management dashboard showing the value of a secret.](media/Ex2-Task1.15.png)

16. Next, download the api deployment configuration using the following command in your WSL window:

    ```bash
    kubectl get -o=yaml --export=true deployment api > api.deployment.yml
    ```

17. Edit the downloaded file:

    ```bash
    vi api.deployment.yml
    ```

       - Add the following environment configuration to the container spec, below the "image" property:

    ```yaml
    - image: [LOGINSERVER].azurecr.io/fabmedical/content-api
      env:
        - name: MONGODB_CONNECTION
          valueFrom:
            secretKeyRef:
              name: mongodb
              key: db
    ```

    ![A screenshot of the Kubernetes management dashboard showing part of the deployment file.](media/Ex2-Task1.17.png)

18. Update the api deployment by using `kubectl` to apply the new configuration.

    ```bash
    kubectl apply -f api.deployment.yml
    ```

19. Select "Deployments" then "api" to view the api deployment. It now has a healthy instance and the logs indicate it has connected to mongodb.

    ![A screenshot of the Kubernetes management dashboard showing logs output.](media/Ex2-Task1.19.png)

### Task 3: Deploy a service using kubectl

In this task, deploy the web service using `kubectl`.

1. Open a **new** WSL console.

2. Create a text file called web.deployment.yml using Vim and press the "i" key to go into edit mode.

    ```bash
    vi web.deployment.yml
    <i>
    ```

3. Copy and paste the following text into the editor:

    >**Note**: Be sure to copy and paste only the contents of the code block carefully to avoid introducing any special characters. If the code does not paste correctly, you can issue a ":set paste" command before pasting.

    ```yaml
    apiVersion: extensions/v1beta1
    kind: Deployment
    metadata:
      labels:
          app: web
      name: web
    spec:
      replicas: 1
      selector:
          matchLabels:
            app: web
      strategy:
          rollingUpdate:
            maxSurge: 1
            maxUnavailable: 1
          type: RollingUpdate
      template:
          metadata:
            labels:
                app: web
            name: web
          spec:
            containers:
            - image: [LOGINSERVER].azurecr.io/content-web
              env:
                - name: CONTENT_API_URL
                  value: http://api:3001
              livenessProbe:
                httpGet:
                    path: /
                    port: 3000
                initialDelaySeconds: 30
                periodSeconds: 20
                timeoutSeconds: 10
                failureThreshold: 3
              imagePullPolicy: Always
              name: web
              ports:
                - containerPort: 3000
                  hostPort: 80
                  protocol: TCP
              resources:
                requests:
                    cpu: 1000m
                    memory: 128Mi
              securityContext:
                privileged: false
              terminationMessagePath: /dev/termination-log
              terminationMessagePolicy: File
            dnsPolicy: ClusterFirst
            restartPolicy: Always
            schedulerName: default-scheduler
            securityContext: {}
            terminationGracePeriodSeconds: 30
    ```

4. Edit this file and update the [LOGINSERVER] entry to match the name of your ACR login server.

5. Press the Escape key and type ":wq". Then press the Enter key to save and close the file.

    ```text
    <Esc>
    :wq
    <Enter>
    ```

6. Create a text file called web.service.yml using Vim, and press the "i" key to go into edit mode.

    ```bash
    vi web.service.yml
    ```

7. Copy and paste the following text into the editor:

    >**Note**: Be sure to copy and paste only the contents of the code block carefully to avoid introducing any special characters.

    ```yaml
    apiVersion: v1
    kind: Service
    metadata:
      labels:
          app: web
      name: web
    spec:
      ports:
        - name: web-traffic
          port: 80
          protocol: TCP
          targetPort: 3000
      selector:
          app: web
      sessionAffinity: None
      type: LoadBalancer
    ```

8. Press the Escape key and type ":wq"; then press the Enter key to save and close the file.

9. Type the following command to deploy the application described by the YAML files. You will receive a message indicating the items kubectl has created a web deployment and a web service.

    ```bash
    kubectl create --save-config=true -f web.deployment.yml -f web.service.yml
    ```

    ![In this screenshot of the WSL console, kubectl apply -f kubernetes-web.yaml has been typed and run at the command prompt. Messages about web deployment and web service creation appear below.](media/image93.png)

10. Return to the browser where you have the Kubernetes management dashboard open. From the navigation menu, select Services view under Discovery and Load Balancing. From the Services view, select the web service and from this view, you will see the web service deploying. This deployment can take a few minutes. When it completes you should be able to access the website via an external endpoint.

    ![In the Kubernetes management dashboard, Services is selected below Discovery and Load Balancing in the navigation menu. At right are three boxes that display various information about the web service deployment: Details, Pods, and Events. At this time, we are unable to capture all of the information in the window. Future versions of this course should address this.](media/image94.png)

11. Select the speakers and sessions links. Note that no data is displayed, although we have connected to our CosmosDb instance, there is no data loaded. You will resolve this by running the content-init application as a Kubernetes Job in Task 5.

    ![A screenshot of the web site showing no data displayed.](media/Ex2-Task3.11.png)

### Task 4: Deploy a service using a Helm chart

In this task, deploy the web service using a helm chart.

1. From the Kubernetes dashboard, under "Workloads", select "Deployments".

2. Click the triple vertical dots on the right of the "web" deployment and then select "Delete". When prompted, click "Delete" again.

    ![A screenshot of the Kubernetes management dashboard showing how to delete a deployment.](media/Ex2-Task4.2.png)

3. From the Kubernetes dashboard, under "Discovery and Load Balancing", select "Services".

4. Click the triple vertical dots on the right of the "web" service and then select "Delete". When prompted, click "Delete" again.

    ![A screenshot of the Kubernetes management dashboard showing how to delete a deployment.](media/Ex2-Task4.4.png)

5. Open a **new** WSL console.

6. Create a text file called rbac-config.yaml using Vim and press the "i" key to go into edit mode.

    ```bash
    vi rbac-config.yaml
    <i>
    ```

7. Copy and paste the following text into the editor:

    >**Note**: Be sure to copy and paste only the contents of the code block carefully to avoid introducing any special characters. If the code does not paste correctly, you can issue a ":set paste" command before pasting.

    ```yaml
    apiVersion: v1
    kind: ServiceAccount
    metadata:
      name: tiller
      namespace: kube-system
    ---
    apiVersion: rbac.authorization.k8s.io/v1
    kind: ClusterRoleBinding
    metadata:
      name: tiller
    roleRef:
      apiGroup: rbac.authorization.k8s.io
      kind: ClusterRole
      name: cluster-admin
    subjects:
      - kind: ServiceAccount
        name: tiller
        namespace: kube-system
    ```

8. Press the Escape key and type ":wq". Then press the Enter key to save and close the file.

    ```text
    <Esc>
    :wq
    <Enter>
    ```

9. Type the following command to create the service account needed by Tiller (the Helm server part).

    ```bash
    kubectl create -f rbac-config.yaml
    ```

10. Type the following command to initialize Helm using the previously service account setup.

    ```bash
    helm init --service-account tiller
    ```

11. We will use the `helm create` command to scaffold out a chart implementation that we can build on. Use the following commands to create a new chart named `web` in a new directory:

    ```bash
    cd FabMedical/content-web
    mkdir charts
    cd charts
    helm create web
    ```

12. We now need to update the generated scaffold to match our requirements. We will first update the file named `values.yaml`.

    ```bash
    cd web
    vi values.yaml
    <i>
    ```

13. Search for the `image` definition and update the values so that they match the following:

    ```yaml
    image:
      repository: [LOGINSERVER].azurecr.io/content-web
      tag: latest
      pullPolicy: Always
    ```

14. Search for `nameOverride` and `fullnameOverride` entries and update the values so that they match the following:

    ```yaml
    nameOverride: "web"
    fullnameOverride: "web"
    ```

15. Search for the `service` definition and update the values so that they match the following:

    ```yaml
    service:
      type: LoadBalancer
      port: 80
    ```

16. Search for the `resources` definition and update the values so that they match the following:

    ```yaml
    resources:
      # We usually recommend not to specify default resources and to leave this as a conscious
      # choice for the user. This also increases chances charts run on environments with little
      # resources, such as Minikube. If you do want to specify resources, uncomment the following
      # lines, adjust them as necessary, and remove the curly braces after 'resources:'.
      # limits:
      #  cpu: 100m
      #  memory: 128Mi
      requests:
        cpu: 1000m
        memory: 128Mi
    ```

17. Press the Escape key and type ":wq". Then press the Enter key to save and close the file.

    ```text
    <Esc>
    :wq
    <Enter>
    ```

18. We will now update the file named `deployment.yaml`.

    ```bash
    cd templates
    vi deployment.yaml
    <i>
    ```

19. Search for the `containers` definition and update the values so that they match the following:

    ```yaml
    containers:
      - name: {{ .Chart.Name }}
        image: "{{ .Values.image.repository }}:{{ .Values.image.tag }}"
        imagePullPolicy: {{ .Values.image.pullPolicy }}
        ports:
          - name: http
            containerPort: 3000
            protocol: TCP
        env:
        - name: CONTENT_API_URL
          value: http://api:3001
        livenessProbe:
          httpGet:
            path: /
            port: 3000
    ```

20. Press the Escape key and type ":wq". Then press the Enter key to save and close the file.

    ```text
    <Esc>
    :wq
    <Enter>
    ```

21. We will now update the file named `service.yaml`.

    ```bash
    vi service.yaml
    <i>
    ```

22. Search for the `ports` definition and update the values so that they match the following:

    ```yaml
    ports:
      - port: {{ .Values.service.port }}
        targetPort: 3000
        protocol: TCP
        name: http
    ```

23. Press the Escape key and type ":wq". Then press the Enter key to save and close the file.

    ```text
    <Esc>
    :wq
    <Enter>
    ```

24. The chart is now setup to run our web container. Type the following command to deploy the application described by the YAML files. You will receive a message indicating that helm has created a web deployment and a web service.

    ```bash
    cd ../..
    helm install --name web ./web
    ```

    ![In this screenshot of the WSL console, helm install --name web ./web has been typed and run at the command prompt. Messages about web deployment and web service creation appear below.](media/Ex2-Task4.24.png)

25. Return to the browser where you have the Kubernetes management dashboard open. From the navigation menu, select Services view under Discovery and Load Balancing. From the Services view, select the web service and from this view, you will see the web service deploying. This deployment can take a few minutes. When it completes you should be able to access the website via an external endpoint.

    ![In the Kubernetes management dashboard, Services is selected below Discovery and Load Balancing in the navigation menu. At right are three boxes that display various information about the web service deployment: Details, Pods, and Events. At this time, we are unable to capture all of the information in the window. Future versions of this course should address this.](media/image94.png)

26. Select the speakers and sessions links. Note that no data is displayed, although we have connected to our CosmosDb instance, there is no data loaded. You will resolve this by running the content-init application as a Kubernetes Job.

    ![A screenshot of the web site showing no data displayed.](media/Ex2-Task3.11.png)

27. We will now persist the changes into the repository. Execute the following commands:

    ```bash
    cd ..
    git pull
    git add charts/
    git commit -m "Helm chart added."
    git push
    ```

### Task 5: Initialize database with a Kubernetes Job

In this task, you will use a Kubernetes Job to run a container that is meant to execute a task and terminate, rather than run all the time.

1. In your WSL window create a text file called init.job.yml using Vim, and press the "i" key to go into edit mode.

    ```bash
    vi init.job.yml
    ```

2. Copy and paste the following text into the editor:

   > **Note**: Be sure to copy and paste only the contents of the code block carefully to avoid introducing any special characters.

    ```yaml
    apiVersion: batch/v1
    kind: Job
    metadata:
      name: init
    spec:
      template:
        spec:
          containers:
          - name: init
            image: [LOGINSERVER]/content-init
            env:
              - name: MONGODB_CONNECTION
                valueFrom:
                  secretKeyRef:
                    name: mongodb
                    key: db
          restartPolicy: Never
      backoffLimit: 4
    ```

3. Edit this file and update the [LOGINSERVER] entry to match the name of your ACR login server.

4. Press the Escape key and type ":wq". Then press the Enter key to save and close the file.

5. Type the following command to deploy the job described by the YAML. You will receive a message indicating the kubectl has created an init "job.batch".

    ```bash
    kubectl create --save-config=true -f init.job.yml
    ```

6. View the Job by selecting "Jobs" under "Workloads" in the Kubernetes UI.

    ![A screenshot of the Kubernetes management dashboard showing jobs.](media/Ex2-Task5.6.png)

7. Select the log icon to view the logs.

    ![A screenshot of the Kubernetes management dashboard showing log output.](media/Ex2-Task5.7.png)

8. Next view your CosmosDb instance in the Azure portal and see that it now contains two collections.

    ![A screenshot of the Azure Portal showing Cosmos DB collections.](media/Ex2-Task5.8.png)

### Task 6: Test the application in a browser

In this task, you will verify that you can browse to the web service you have deployed and view the speaker and content information exposed by the API service.

1. From the Kubernetes management dashboard, in the navigation menu, select the Services view under Discovery and Load Balancing.

2. In the list of services, locate the external endpoint for the web service and select this hyperlink to launch the application.

    ![In the Services box, a red arrow points at the hyperlinked external endpoint for the web service.](media/image112.png)

3. You will see the web application in your browser and be able to select the Speakers and Sessions links to view those pages without errors. The lack of errors means that the web application is correctly calling the API service to show the details on each of those pages.

    ![In this screenshot of the Contoso Neuro 2017 web application, Speakers has been selected, and sample speaker information appears at the bottom.](media/image114.png)

    ![In this screenshot of the Contoso Neuro 2017 web application, Sessions has been selected, and sample session information appears at the bottom.](media/image115.png)

### Task 7: Configure Continuous Delivery to the Kubernetes Cluster

In this task, you will update a Build Pipeline and configure a Release Pipeline in your Azure DevOps account so that when new images are pushed to the ACR, they get deployed to the AKS cluster.

1. We will use Azure DevOps to automate the process for deploying the web image to the AKS cluster. Login to your Azure DevOps account, access the project you created earlier, then select "Pipelines", and then select "Builds".

2. From the builds list, select the `content-web-Container-CI` build and then click `Edit.`

    ![A screenshot with the `content-web-Container-CI` build selected and the `Edit` button highlighted.](media/Ex2-Task7.2.png)

3. In the `Agent job 1` row, click `+`.

    ![A screenshot that shows how to add a task to a build pipeline.](media/Ex2-Task7.3.png)

4. Search for "Helm", select "Helm tool installer" and then click "Add".

    ![A screenhost that shows adding the "Helm tool installer" task.](media/Ex2-Task7.4.png)

5. Still using the same search, select "Package and deploy Helm charts" and then click "Add".

    ![A screenhost that shows adding the "Package and deploy Helm charts" task.](media/Ex2-Task7.5.png)

6. Search for "Publish Artifacts", select "Publish Build Artifacts" and then click "Add".

    ![A screenhost that shows adding the "Publish Build Artifacts" task.](media/Ex2-Task7.6.png)

7. Select "helm ls":

    - **Azure subscription**: Choose "azurecloud-sol".

    - **Resource group**: Choose your resource group by name.

    - **Kubernetes cluster**: Choose your AKS instance by name.

    - **Command**: Select "package".

    - **Chart Path**: Select "charts/web".

    ![A screenshot of the dialog where you can describe the helm package.](media/Ex2-Task7.7.png)

8. Select "Publish Artifact: drop":

    - **Path to publish**: Ensure that the value matches "$(Build.ArtifactStagingDirectory)".

    - **Artifact name**: Update the value to "chart".

    ![A screenshot of the dialog where you can describe the publish artifact.](media/Ex2-Task7.8.png)

9. Select "Save & queue"; then select "Save & queue" two more times to kick off the build.

10. Now create your first release. Select "Pipelines, then select "Releases", and then select "New pipeline".

    ![A screenshot of Azure DevOps release definitions.](media/Ex2-Task7.10.png)

11. Search for "Helm" templates and choose "Deploy an application to a Kubernetes cluster by using its Helm chart." then select "Apply".

    ![A screenshot of template selection showing Deploy an application to a Kubernetes cluster by using its Helm chart selected.](media/Ex2-Task7.11.png)

12. Change the release name to "content-web-AKS-CD".

    ![A screenshot of the dialog where you can enter the name for the release.](media/Ex2-Task7.12.png)

13. Select "+ Add an artifact".

    ![A screenshot of the release artifacts.](media/Ex2-Task7.13.png)

14. Setup the artifact:

    - **Project**: fabmedical

    - **Source (build pipeline)**: content-web-Container-CI

    - **Default version**: select "Latest"

    ![A screenshot of the add an artifact dialog.](media/Ex2-Task7.14.png)

15. Select the "Continuous deployment trigger".

    ![A screenshot of the continuous deployment trigger.](media/Ex2-Task7.15.png)

16. Enable the continuous deployment.

    ![A screenshot of the continuous deployment being enabled.](media/Ex2-Task7.16.png)

17. In "Stage 1", click "1 job, 3 tasks".

    ![A screenshot of the Stage 1 current status.](media/Ex2-Task7.17.png)

18. Setup the stage:

    - **Azure subscription**: Choose "azurecloud-sol".

    - **Resource group**: Choose your resource group by name.

    - **Kubernetes cluster**: Choose your AKS instance by name.

    ![A screenshot of ](media/Ex2-Task7.18.png)

19. Select "helm init":

    - **Command**: select "init"

    - **Arguments**: Update the value to "--service-account tiller"

    ![A screenshot of ](media/Ex2-Task7.19.png)

20. Select "helm upgrade":

    - **Command**: select "upgrade"
    - **Chart Type**: select "File Path"
    - **Chart Path**: select the location of the chart artifact
    - **Release Name**: web
    - **Set values**: image.tag=$(Build.BuildId)

    ![A screenshot of ](media/Ex2-Task7.20.png)

21. Select "Save" and then "OK".

22. Select "+ Release", then "+ Create a release" and then "Create" to kick off the release.

### Task 8: Review Azure Monitor for Containers

In this task, you will access and review the various logs and dashboards made available by Azure Monitor for Containers.

1. From the Azure Portal, select the resource group you created named fabmedical-SUFFIX, and then select your AKS cluster.

    ![In this screenshot, the resource group was previously selected and the AKS cluster is selected.](media/Ex2-Task8.1.png)

2. From the Monitoring blade, select **Insights**.

    ![In the Monitoring blade, Insights is highlighted.](media/Ex2-Task8.2.png)

3. Review the various available dashboards and a deeper look at the various metrics and logs available on the Cluster, Cluster Nodes, Cluster Controllers and deployed Containers.

    ![In this screenshot, the dashboards and blades are shows.](media/Ex2-Task8.3.png)

4. To review the Containers dashboards and see more detailed information about each container click on containers tab.

    ![In this screenshot, the various containers information is shown.](media/monitor_1.png)

5. Now filter by container name and search for the web containers, you will see all the containers created in the Kubernetes cluster with the pod names, you can compare the names with those in the kubernetes dashboard.  

    ![In this screenshot, the containers are filtered by container named web.](media/monitor_3.png)

6. By default, the CPU Usage metric will be selected displaying all cpu information for the selected container, to switch to another metric open the metric dropdown list and select a different metric.

    ![In this screenshot, the various metric options are shown.](media/monitor_2.png)

7. Upon selecting any pod, all the information related to the selected metric will be displayed on the right panel, and that would be the case when selecting any other metric, the details will be displayed on the right panel for the selected pod.

    ![In this screenshot, the pod cpu usage details are shown.](media/monitor_4.png)

8. To display the logs for any container simply select it and view the right panel and you will find "View Container Log" link which will list all logs for this specific container.

    ![Container Log view](media/monitor_5.png)

9. For each log entry you can display more information by expanding the log entry to view the below details.

    ![Log entry details](media/monitor_6.png)
    
