#!/bin/bash

# Place wanted command that produces JSON output between the parentheses
json_vpc=$(aws ec2 create-vpc --cidr-block 10.11.0.0/16)

# Extract the vpc ID using jq
extracted_data_vpc=$(echo "$json_vpc" | jq -r '.Vpc.VpcId')

# Create two subnets
aws ec2 create-subnet --vpc-id $extracted_data_vpc --cidr-block 10.11.1.0/24

aws ec2 create-subnet --vpc-id $extracted_data_vpc --cidr-block 10.11.2.0/24

# # Extract the subnet ID using jq
# extracted_data_subnet1=$(echo "$json_subnet1" | jq -r '.Subnet.SubnetId')
# extracted_data_subnet2=$(echo "$json_subnet2" | jq -r '.Subnet.SubnetId')

# Create an Internet Gateway
json_igw=$(aws ec2 create-internet-gateway)

# Extract the Internet Gateway ID using jq
extracted_data_igw=$(echo "$json_igw" | jq -r '.InternetGateway.InternetGatewayId')

# Attach the Internet Gateway to the VPC
aws ec2 attach-internet-gateway --vpc-id $extracted_data_vpc --internet-gateway-id $extracted_data_igw

# Create a custom route table
json_rt=$(aws ec2 create-route-table --vpc-id $extracted_data_vpc)

# Extract the Route Table ID using jq
extracted_data_rt=$(echo "$json_rt" | jq -r '.RouteTable.RouteTableId')

# Create a route to the Internet Gateway
aws ec2 create-route --route-table-id $extracted_data_rt --destination-cidr-block 0.0.0.0/0 --gateway-id $extracted_data_igw

# Evaluate the state of the route table to ensure it has been created
aws ec2 describe-route-tables --route-table-id $extracted_data_rt

# Retrieve subnet IDs
json_subnets=$(aws ec2 describe-subnets --filters "Name=vpc-id,Values=$extracted_data_vpc" --query 'Subnets[*].{ID:SubnetId,CIDR:CidrBlock}')

# Extract the subnet IDs using jq
extracted_data_subnet1=$(echo "$json_subnets" | jq -r '.[0].ID')

# Associate the desired subnet with a custom route table to make it public
aws ec2 associate-route-table  --subnet-id $extracted_data_subnet1 --route-table-id $extracted_data_rt

# Configure the subnet to issue a public IP address to EC2 instances
aws ec2 modify-subnet-attribute --subnet-id $extracted_data_subnet1 --map-public-ip-on-launch


##### COMMANDS BELOW LAUNCH AN EC2 INSTANCE INTO THE SUBNET FOR TESTING #####

# Create a key pair and output to PciKeys.pem
aws ec2 create-key-pair --key-name PciKeys --query 'KeyMaterial' --output text > ./PciKeys.pem

chmod 400 PciKeys.pem

# Create a security group with a rule to allow ssh access
json_sg=$(aws ec2 create-security-group --group-name MySecurityGroup --description "My security group" --vpc-id $extracted_data_vpc)

# Extract the Security Group ID using jq
extracted_data_sg=$(echo "$json_sg" | jq -r '.GroupId')

# Add a rule to the security group to allow ssh access
aws ec2 authorize-security-group-ingress --group-id $extracted_data_sg --protocol tcp --port 22 --cidr 0.0.0.0/0

# Launch an EC2 instance into the subnet
json_insid=$(aws ec2 run-instances --image-id ami-02396cdd13e9a1257 --count 1 --instance-type t2.micro --key-name PciKeys --security-group-ids $extracted_data_sg --subnet-id $extracted_data_subnet1)

# Get instance ID of the EC2 instance via jq
extracted_data_insid=$(echo "$json_insid" | jq -r '.InstanceId')

# Check the state of the instance and Get the public IP address of the instance
aws ec2 describe-instances --instance-ids $extracted_data_insid --query 'Reservations[].Instances[].PublicIpAddress' --output text

# SSH into the instance
ssh -i MyKeyPair.pem ec2-user@<public-ip-address>

