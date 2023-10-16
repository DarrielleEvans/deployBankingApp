# Deploy a Banking Flask Application using Terraform and Jenkins to an EC2 Instance

## Purpose

In this deployment, I will deploy my application on an EC2 instance using Terraform 

## Issues

## Steps

### Step 1
Upload code files to Github
### Step 2
Create a Terraform configuration file with the following aws resources
  * 2 availablility zones
  * 2 public subnets
  * 2 EC2's
  * 1 route table
  * Security Group Ports: 8080, 8000, 22
  * add deploy.sh script that will install jenkins on one of the instances
    

### Step 3
Create Jenkins password and log in as a jenkins user
  * copy public key on application server and test ssh connection
### Step 4
Run Jenkins multibranch build
  * change path to Jenkinsfile1 script
  * run Jenkinsfile2 script

## System Diagram
![Deployment5 drawio](https://github.com/DarrielleEvans/deployBankingApp/assets/89504317/5d9747dd-32fd-435e-ae67-d2a0d3fa6d65)


## Optimization
This application can be optimized by loading the data files in a private subnet to enhance security.
