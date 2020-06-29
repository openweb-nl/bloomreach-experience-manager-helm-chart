# Helm chart for Bloomreach Experience Manager (Formerly known as Hippo)

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



## Pre-setup
### Environment folder
To make it easier for the user and to give more structure to the setup process. We are using the concept of the environment folder. 
An environment folder is a folder located under "./environment/" containing the following files.
* bem-values.yaml - This is given to bloomreach helm chart as values file to override values from /charts/bloomreach/values.yaml
* mysql-values.yaml - This is given to mysql helm chart as values file to override values from /charts/mysql/values.yaml
* volumes-values.yaml - This is given to volumes helm chart as values file to override values from /charts/volumes/values.yaml
* secrets.yml - This file contains all the sensitive data in your project like database password or certificate keys. you probably want to exclude this file from being check-in with your project in the .gitignore file. 
* variables.sh - Is a bash file that sets the following vairbles 
    * applicationName - Application name
    * namespace - The namespace you want to deploy this application to 
    * deployment - The deployment name (can be overridden via command line)
    * volumeMultiplicityPerNode - Number of copied of each volume folder per node

Every bash script in project get the name of an environment folder as its first argument.
 
Please notice that some of the variables e.g. "applicationName" are mentioned in multiple files in an environment folder. 
So please make sure that the values that you give to these variables are consistent across all the files in an environment folder.  

### Creating volumes

Before you run any of the helm charts, you first need to create the necessary folder on the worker servers to be used as volumes.
In order to make it easier for you, we have added two scripts in the project at "/scripts/create-volume-folder.sh" and 
"/scripts/delete-volume-folder.sh" that can create and delete the necessary folders for you.

Here is how you run them, First you need to load your private ssh key via
```bash
ssh-agent bash
ssh-add
```
then you run the script
```bash
./scripts/create-volume-folder.sh <envName> <user> <server1IpAddress> <server2IpAddress> <server2IpAddress>
```
 in the above command "envName" is the name of the environment folder (e.g. "test" or "prod"). 
 "user" is the name of the user that you use to ssh to a worker machine. The rest of arguments are just a list of ip addresses 
 of the worker machines (or their hostname).

