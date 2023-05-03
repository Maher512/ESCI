##### HOW TO CREATE A VPC #####

aws ec2 create-vpc --cidr-block 10.10.0.0/16

## After creating the VPC, copy the VpcId from the output
## Update any command that has a VPC ID in it with the new VpcId:
### Create a subnet via the commands below:

aws ec2 create-subnet --vpc-id vpc-0486f61b9e06acef6 --cidr-block 10.10.1.0/24

aws ec2 create-subnet --vpc-id vpc-0486f61b9e06acef6 --cidr-block 10.10.2.0/24

## Create an Internet Gateway

aws ec2 create-internet-gateway

## After that copy the InternetGatewayId from the output
## Update the internet-gateway-id in the required commands below:

aws ec2 attach-internet-gateway --vpc-id vpc-0486f61b9e06acef6 --internet-gateway-id igw-0e3a3857c8c6e06cf

## Create a custom route table

aws ec2 create-route-table --vpc-id vpc-0486f61b9e06acef6

## Copy RouteTableId from the output
## Update the route-table-id and gateway-id in the required commands below:

aws ec2 create-route --route-table-id rtb-0e35e6174879822db --destination-cidr-block 0.0.0.0/0 --gateway-id igw-0e3a3857c8c6e06cf

## Evaluate the state of the route table to ensure it has been created:

aws ec2 describe-route-tables --route-table-id rtb-0e35e6174879822db

## Retrieve subnet IDs
## Update VPC ID in the command below:

aws ec2 describe-subnets --filters "Name=vpc-id,Values=vpc-0486f61b9e06acef6" --query 'Subnets[*].{ID:SubnetId,CIDR:CidrBlock}'

## Associate the desired subnet with a custom route table to make it public

aws ec2 associate-route-table  --subnet-id subnet-056a020abfd2ce197 --route-table-id rtb-0e35e6174879822db

## Configure the subnet to issue a public IP address to EC2 instances

aws ec2 modify-subnet-attribute --subnet-id subnet-056a020abfd2ce197 --map-public-ip-on-launch


##### COMMANDS BELOW LAUNCH AN EC2 INSTANCE INTO THE SUBNET FOR TESTING #####

## Create a key pair and output to MyKeyPair.pem
## Modify output path accordingly

aws ec2 create-key-pair --key-name MyKeyPair --query 'KeyMaterial' --output text > ./MyKeyPair.pem

## Linux / Mac only - modify permissions

chmod 400 MyKeyPair.pem

## Create a security group with a rule to allow SSH

aws ec2 create-security-group --group-name SSHAccess --description "Security group for SSH access" --vpc-id vpc-0486f61b9e06acef6

## Copy security group ID from output
## Update group-id in the command below:

aws ec2 authorize-security-group-ingress --group-id sg-0262a910d9bccabad --protocol tcp --port 22 --cidr 0.0.0.0/0

## Launch instance in public subnet using security group and key pair created previously:
## Obtain the AMI ID for testing purposes chose a Linux server AMI from the console, update the security-group-ids and subnet-ids

aws ec2 run-instances --image-id ami-02396cdd13e9a1257 --count 1 --instance-type t2.micro --key-name MyKeyPair --security-group-ids sg-0262a910d9bccabad --subnet-id subnet-056a020abfd2ce197

## Copy instance ID from output and use in the command below
## Check instance is in running state:

aws ec2 describe-instances --instance-id i-06aad54be737448dc

## Note the public IP address
## Connect to instance using key pair and public IP

ssh -i MyKeyPair.pem ec2-user@54.197.9.72


