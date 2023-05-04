#!/bin/bash

# Place wanted command that produces JSON output between the parentheses
json_vpc=$(aws ec2 create-vpc --cidr-block 10.11.0.0/16)

# Extract the vpc ID using jq
extracted_data_vpc=$(echo "$json_vpc" | jq -r '.Vpc.VpcId')

# Create two subnets
json_subnet1= $(aws ec2 create-subnet --vpc-id $extracted_data_vpc --cidr-block 10.11.1.0/24)
sleep 2
json_subnet2= $(aws ec2 create-subnet --vpc-id $extracted_data_vpc --cidr-block 10.11.2.0/24)

# Extract the subnet ID using jq
extracted_data_subnet1=$(echo "$json_subnet1" | jq -r '.Subnet.SubnetId')
extracted_data_subnet2=$(echo "$json_subnet2" | jq -r '.Subnet.SubnetId')

# Create an Internet Gateway
#json_igw=$(aws ec2 create-internet-gateway)