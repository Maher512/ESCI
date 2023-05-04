#!/bin/bash

# Place wanted command that produces JSON output between the parentheses
json_vpc=$(aws ec2 create-vpc --cidr-block 10.11.0.0/16)

# Extract the vpc ID using jq
extracted_data_vpc=$(echo "$json_vpc" | jq -r '.Vpc.VpcId')

# Create two subnets
json_subnet1= $(aws ec2 create-subnet --vpc-id $extracted_data_vpc --cidr-block 10.11.1.0/24)

json_subnet2= $(aws ec2 create-subnet --vpc-id $extracted_data_vpc --cidr-block 10.11.2.0/24)

# Extract the subnet ID using jq
extracted_data_subnet1=$(echo "$json_subnet1" | jq -r '.Subnet.SubnetId')

extracted_data_subnet2=$(echo "$json_subnet2" | jq -r '.Subnet.SubnetId')

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

# Associate the desired subnet with a custom route table to make it public
aws ec2 associate-route-table  --subnet-id $extracted_data_subnet1 --route-table-id $extracted_data_rt

# Configure the subnet to issue a public IP address to EC2 instances
aws ec2 modify-subnet-attribute --subnet-id $extracted_data_subnet1 --map-public-ip-on-launch


