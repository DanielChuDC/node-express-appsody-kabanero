# node-express-appsody-kabanero



[Use Kabanero, Appsody, and Codewind to build a Spring Boot application on Kubernetes](https://developer.ibm.com/tutorials/kabanero-introduction-to-modern-microservices-development-for-kubernetes/)

To create a modern, cloud-native application, you have to consider all aspects of the application — from the best way to incorporate business logic in the appropriate places to technical considerations like how to handle resiliency, reliability, and monitoring. Additionally, when running an application on the cloud or in a Kubernetes cluster, you also have to handle creating Dockerfiles and the necessary Kubernetes resource files.

In the era of DevOps where the team is responsible for building and running applications for their entire life cycle, choosing the best tools is crucial to help reduce the work needed for building and deploying cloud-native applications. 

New open source tools from IBM — Kabanero, Appsody, and Codewind — were created to make it easier for developers to build and deploy cloud-native applications to Kubernetes.


# For webhook in kabanero and tekton pipeline

By using webhook to trigger the real time build is convinient, currently facing 404 Issue of github webhook
```
We couldn’t deliver this payload: Service Timeout
```

### Manually deploy using tekton pipeline

##### Prerequisite
- You need have Kabanero and tekton install in your OKD / Openshift cluster. (Currently using 3.11 version)


### Before you begin

- Run `oc login <your OKD cluster master ip> -u <username> -p <your_password>`

1. Run 
##### Method 1: Using Yaml file to modify and add in your target deploy-namespace
`oc get Kabanero -n kabanero -o yaml > ./script/kabanero.yaml`
`oc apply -f ./script/kabanero.yaml -n kabanero`


##### Method 2: Using oc patch command (Incomplete)
`oc patch kabanero  -p '{"items":{"spec":{"targetNamespaces":{ dc-demo}}}}}'`



2. Add in the target namespace you intend to deploy to
- Bear in mind, tekton pipeline by default only can deploy the instance in `kabanero`
- You need to modify the `targetnamespaces` under `spec` to deploy to that server

3. After you run `oc apply -f ./script/kabanero.yaml -n kabanero`
- The expected successful output is `kabanero.kabanero.io/kabanero configured`
- If you did not see the similar output, means it may failed.

4. Take a look `script` folder, you can see two `sh` file
- You can run `APP_REPO=https://github.com/dacleyra/appsody-hello-world/ ./appsody-tekton-example-manual-run.sh` for example

###### For node-express stack
- You can run `APP_REPO=<your own github repo application> ./node-express-appsody-tekton-example-manual-run.sh`

##### For other stack in kabanero
- You have to make sure the stack are availible and activated in your kabanero instance
- You should change the .appsody-config.yaml if the target stack is other like java, node-loopback, etc.
```yaml
# example
project-name: myapp
stack: kabanero/nodejs-express:0.2 # The stack is important, must point to `kabanero/<stack>` and not `appsody/<stack>`

```

5. Then you can change the target namespace in app-deploy.yaml

- For example, add in the target namespace in `metadata`
```yaml
# Example
metadata:
  name: myapp
  namespace: default
```
6. You should change the sh file for the docker image namespace to match the target deploy namespace
- In the below, example, the target namespace is `default`
```sh
# Resultant Appsody container image #
DOCKER_IMAGE="${DOCKER_IMAGE:-docker-registry.default.svc:5000/default/myapp}"
```


7. You may run the command 
`APP_REPO=https://github.com/DanielChuDC/node-express-appsody-kabanero ./script/node-express-appsody-tekton-example-manual-run.sh` to deploy your application

`APP_REPO=https://github.com/dacleyra/appsody-hello-world/ ./script/appsody-tekton-example-manual-run.sh`







