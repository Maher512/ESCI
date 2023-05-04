#!/bin/bash

# Set variables
VPC_NAME="my-vpc"
VPC_CIDR_BLOCK="10.11.0.0/16"
SUBNET_CIDR_BLOCK="10.11.1.0/24"
INSTANCE_TYPE="t2.micro"
AMI_ID="ami-02396cdd13e9a1257" # Replace with the desired Amazon Linux 2 AMI ID for your region
KEY_PAIR_NAME="my-key-pair"
SECURITY_GROUP_NAME="my-sg"

# Create VPC
VPC_ID=$(aws ec2 create-vpc --cidr-block $VPC_CIDR_BLOCK --query 'Vpc.VpcId' --output text)
aws ec2 create-tags --resources $VPC_ID --tags Key=Name,Value=$VPC_NAME

# Create Subnet
SUBNET_ID=$(aws ec2 create-subnet --vpc-id $VPC_ID --cidr-block $SUBNET_CIDR_BLOCK --query 'Subnet.SubnetId' --output text)

# Create Internet Gateway
INTERNET_GATEWAY_ID=$(aws ec2 create-internet-gateway --query 'InternetGateway.InternetGatewayId' --output text)
aws ec2 attach-internet-gateway --vpc-id $VPC_ID --internet-gateway-id $INTERNET_GATEWAY_ID

# Configure Route Table
ROUTE_TABLE_ID=$(aws ec2 describe-route-tables --filters Name=vpc-id,Values=$VPC_ID --query 'RouteTables[0].RouteTableId' --output text)
aws ec2 create-route --route-table-id $ROUTE_TABLE_ID --destination-cidr-block 0.0.0.0/0 --gateway-id $INTERNET_GATEWAY_ID
aws ec2 associate-route-table --subnet-id $SUBNET_ID --route-table-id $ROUTE_TABLE_ID

# Create Security Group
SECURITY_GROUP_ID=$(aws ec2 create-security-group --group-name $SECURITY_GROUP_NAME --description "My security group" --vpc-id $VPC_ID --query 'GroupId' --output text)
aws ec2 authorize-security-group-ingress --group-id $SECURITY_GROUP_ID --protocol tcp --port 22 --cidr 0.0.0.0/0

# Launch EC2 instance
INSTANCE_ID=$(aws ec2 run-instances --image-id $AMI_ID --count 1 --instance-type $INSTANCE_TYPE --key-name $KEY_PAIR_NAME --subnet-id $SUBNET_ID --security-group-ids $SECURITY_GROUP_ID --associate-public-ip-address --query 'Instances[0].InstanceId' --output text)

# Wait for the instance to be in a "running" state
aws ec2 wait instance-running --instance-ids $INSTANCE_ID

# Get Public IP address of the instance
PUBLIC_IP=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID --query 'Reservations[0].Instances[0].PublicIpAddress' --output text)

echo "EC2 instance has been deployed with ID: $INSTANCE_ID and public IP: $PUBLIC_IP"





##### COMMANDS BELOW LAUNCH AN EC2 INSTANCE INTO THE SUBNET FOR TESTING #####

# Create a key pair and output to MyKeyPair.pem
aws ec2 create-key-pair --key-name MyKeyPair --query 'KeyMaterial' --output text > ./MyKeyPair.pem

chmod 400 MyKeyPair.pem

# Create a security group with a rule to allow ssh access
json_sg=$(aws ec2 create-security-group --group-name MySecurityGroup --description "My security group" --vpc-id $extracted_data_vpc)

# Extract the Security Group ID using jq
extracted_data_sg=$(echo "$json_sg" | jq -r '.GroupId')

# Add a rule to the security group to allow ssh access
aws ec2 authorize-security-group-ingress --group-id $extracted_data_sg --protocol tcp --port 22 --cidr 0.0.0.0/0

# Launch an EC2 instance into the subnet
json_insid=$(aws ec2 run-instances --image-id ami-02396cdd13e9a1257 --count 1 --instance-type t2.micro --key-name MyKeyPair --security-group-ids $extracted_data_sg --subnet-id $extracted_data_subnet1)

# Get instance ID of the EC2 instance via jq
extracted_data_insid=$(echo "$json_insid" | jq -r '.InstanceId')

# Check the state of the instance and Get the public IP address of the instance
aws ec2 describe-instances --instance-ids $extracted_data_insid --query 'Reservations[].Instances[].PublicIpAddress' --output text

# SSH into the instance
ssh -i MyKeyPair.pem ec2-user@<public-ip-address>