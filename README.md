# Deploy a Banking Flask Application using Terraform and Jenkins to an EC2 Instance

## Purpose

In this deployment, I will deploy my application on an EC2 instance using Terraform 

## Issues
When configuring the the Terraform file, I tried to make changes to the cidr block ip ranges. Due to the vpc's dependencies, I could not apply the changes. I had to delete the dependencies first, then rerun terraform plan and terraform apply.

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
  * change path to Jenkinsfile2 script

## System Diagram
![Deployment5 drawio](https://github.com/DarrielleEvans/deployBankingApp/assets/89504317/5d9747dd-32fd-435e-ae67-d2a0d3fa6d65)


## Optimization
This application can be optimized by loading the data files in a private subnet to enhance security.

### Notes
* I reran Jenkinsfile2 by changing the path in the Jenkins build.
* This application is used in house and will be most secure in two private subnets. The application does not need to be used by the banks customers so it does not need to communicate with the internet. 

