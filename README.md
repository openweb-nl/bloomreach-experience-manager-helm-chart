# Helm chart for Bloomreach Experience Manager (Formerly known as Hippo)

## Notice
This helm chart can work with any version of Bloomreach Experience Manager (Formerly known as Hippo) higher than an equal 7.x
## Goal of this project
The goal of this project is to provide a helm chart that can be used both for setting up a production environment 
as well as test environments for Bloomreach Experience Manager (Formerly known as Hippo) with ease on a Kubernetes cluster.



## Assumptions
This project is set up with the assumption that you intend to use the disk of the work nodes for volume provisioning. 
So if you want to run this chart in a public cloud (Like Google Cloud Platform, AWS, etc) you need to make small 
adjustments to the setup. (If you need any help you can contact us at [https://www.openweb.nl/contact](https://www.openweb.nl/contact))

## Beware
The MySQL chart in the project isn't meant to be used in a production scenario and only meant for demonstration purposes 
or a test environment scenario. In the case of a production environment, we recommend a far more sophisticated setup. 

## Prerequisite
Before you run this helm chart make sure that the control machine (The machine that runs the script) meet the following prerequisites 
* Make sure that kubectl is installed on the machine
* Make sure that kubectl is configured to connect to the cluster where you want to install your application
* Make sure that Helm chart version 3 or later has been installed

## Pre-setup
### Environment folder
To make it easier for the user and to give more structure to the setup process. We are using the concept of the environment folder. 
An environment folder is a folder located under "./environment/" containing the following files.
* bem-values.yaml - This is given to bloomreach helm chart as values file to override values from /charts/bloomreach/values.yaml
* mysql-values.yaml - This is given to mysql helm chart as values file to override values from /charts/mysql/values.yaml
* volumes-values.yaml - This is given to volumes helm chart as values file to override values from /charts/volumes/values.yaml
* secrets.yml - This file contains all the sensitive data in your project like database password or certificate keys. you probably want to exclude this file from being checked-in with your project in the .gitignore file. 
* variables.sh - Is a bash file that sets the following vairbles 
    * applicationName - Application name
    * namespace - The namespace you want to deploy this application to 
    * deployment - The deployment name (can be overridden via command line)
    * volumeMultiplicityPerNode - Number of copies of each volume folder per node

Every bash script in project gets the name of an environment folder as its first argument.
 
Please notice that some of the variables e.g. "applicationName" are mentioned in multiple files in an environment folder. 
So please make sure that the values that you give to these variables are consistent across all the files in an environment folder.  

### Creating volumes

Before you run any of the helm charts, you first need to create the necessary folder on the worker servers to be used as volumes.
In order to make it easier for you, we have added two scripts in the project at "/scripts/create-volume-folder.sh" and 
"/scripts/delete-volume-folder.sh" that can create and delete the necessary folders for you.

Here is how you run them. First you need to load your private ssh key via
```bash
ssh-agent bash
ssh-add
```
then you run the script
```bash
./scripts/create-volume-folder.sh <envName> <user> <server1IpAddress> <server2IpAddress> <server2IpAddress>
```
 in the above command "envName" is the name of the environment folder (e.g. "test" or "prod"). 
 "user" is the name of the user that you use to ssh to a worker machine. The rest of the arguments are just a list of ip addresses 
 of the worker machines (or their hostname).

## Setup
There are two ways you can set up a Bloomreach cluster using scripts in this project. Either you can set up the whole thing 
using only a single command, or you can do it step by step via running 3 separate commands. 
Step by step approach would give you more control over certain aspects of your deployment.

### One-step setup
One step setup is rather easy you just need to run the following command
```bash
./setup-all.sh <envName>
```
Where envName is the name of one of the folders under "environments" folder. Please see "Environment folder" section for more details.
For example, you could run the following command:
```bash
./setup-all.sh test
```
### Step-by-step setup
In this approach you set up each piece independently. 
#### Setup the basics
In this step, we set up the following:
* Creating a namespace
* Apply Secrets
* Creating PersistentVolume's
Run this step with the command:
```bash
./setup-basics.sh <envName>
```  
#### Setup MySQL
Run this step with the command:
```bash
./setup-mysql.sh <envName>
```
#### Setup the application
In this step, you have a choice you could either use the following command:
```bash
./setup-mysql.sh <envName>
```
which sets up the bloomreach application using the deployment name specified in the environments files, 
or you could override the deployment name using the following command:
```bash
./setup-mysql.sh <envName> <deploymentName>
```
This is useful when you want to have multiple envs connected to the same db running side by side. 
Let's say a cms cluster and a site cluster.

## Update
To update your application in case you have changed anything in your "bem-values.yaml" file. e.g. 
changing the version of the application, the number of replicas, ingress urls etc. 
you can run the following command to apply your changes:
```bash
./update.sh <envName>
```
or if you have overridden the deploymentName during setup, then run:
```bash
./update.sh <envName> <deploymentName>
```
## Teardown
To teardown everything run the following command:
```bash
./teardown.sh <envName>
```
or if you have overridden the deploymentName during setup, then run:
```bash
./teardown.sh <envName> <deploymentName>
```
To delete the volumes on the server after running the teardown command run 
```bash
./scripts/delete-volume-folder.sh <envName> <user> <server1IpAddress> <server2IpAddress> <server2IpAddress>
```
This would delete all volume folders of this particular environment on the remote server.

## Running locally
You can run this on you local environment in my case I am running it on Docker for Windows, 
but I assume it would also work more or less the same way on Docker for Mac. Before you run this on your local machine 
you need to check a few things:
* Make sure "Enable Kubernetes" is checked in the settings of your Docker for Windows/Mac
* Review the file "/environments/local/volumes-values.yaml" there are two things to pay attention to
    * Node name, in my case my kubernetes node is called "docker-desktop". Change it if it is different for you. 
    You can find out what your node's name is by running "kubectl get nodes" 
    * BasePath, I used "/c/k8s/volumes" as base path but I guess you would like to change it in case you are running on mac.
    **Please make sure that this folder exist but unlike running on an actual kubernetes environment you don't need to create 
    all the volume folders manually they will be automatically created. So you do not need to run create-volume-folder.sh locally**  
* Enabling ingress (optional) if you want the ingress to work locally, you need to: 
    * Follow the instruction on [https://kubernetes.github.io/ingress-nginx/deploy/](https://kubernetes.github.io/ingress-nginx/deploy/) 
    for Docker for Mac (The same step would work on Docker for Windows as well)
    * Add the following lines to your host file
        * 127.0.0.1	     cms-bloomreach.localhost
        * 127.0.0.1	     site-bloomreach.localhost
        
### Running a multiple nodes cluster (Bloomreach not K8S NODE) locally
You can even run a cluster of multiple bloomreach nodes locally. The only thing you need to do is to run
```bash
./setup-all.sh local-multinode
```
        
## Running your own docker image
In this example, we are using a docker image that is based on Openweb docker image at docker hub 
[https://hub.docker.com/repository/docker/openweb/hippo](https://hub.docker.com/repository/docker/openweb/hippo)
although you can use this Helm chart with any docker image that you want but we highly recommend you to use Openweb docker image 
as your from image. Because it has some unique features that make it suited for running on Kubernetes. Some of these features are:

* Finely tuned memory configuration to avoid OOM kills
* Pod name is used as node name
* Tuned for maximum request throughput 
* UTF-8 Encoding configured everywhere so that you never run into any encoding issues

To configure your own image you need to change bem-values.yaml as show below
```yaml
image:
  repository: <yourRepository>
  pullPolicy: Always
  version: "<tag>"

  imagePullSecrets:
    - name: "regcred"
```
You also need to create an image pull secrets with the name "regcred" in the namespace of the application. 
To do so follow instructions on (https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/)[https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/] 

## License 
Copyright 2020 Open Web IT B.V. subject to the terms and conditions of the Apache Software License 2.0. A copy of the 
license is contained in the file [LICENSE](LICENSE) and is also available at [http://www.apache.org/licenses/LICENSE-2.0.html](http://www.apache.org/licenses/LICENSE-2.0.html).
 
