#!/bin/bash

# Place wanted command that produces JSON output between the parentheses
json_output=$(aws ec2 create-vpc --cidr-block 10.11.0.0/16)

# Extract the vpc ID using jq
extracted_data_vpc=$(echo "$json_output" | jq -r '.Vpc.VpcId')

aws ec2 create-subnet --vpc-id $extracted_data_vpc --cidr-block 10.11.1.0/24
aws ec2 create-subnet --vpc-id $extracted_data_vpc --cidr-block 10.11.2.0/24

# Create an Internet Gateway
aws ec2 create-internet-gateway