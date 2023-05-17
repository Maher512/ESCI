#!bin/bash

# Creating an S3 Bucket
aws s3 mb s3://maher123-cli-bucket

#Creating a Read Only Policy for the S3 Bucket

json_arn_rp=$(aws iam create-policy --policy-name ReadOnlyS3Policy --policy-document file://s3bucket_read_only.json)

extracted_arn=$(echo "$json_arn_rp" | jq -r '.Policy.Arn')

aws iam create-role --role-name NUser --assume-role-policy-document file://trustpolicy.json

aws iam attach-role-policy --role-name NUser --policy-arn $extracted_arn

echo "Created a Read Only Policy for the S3 Bucket and attached it to a normal user role with limited permissions"

sleep 2

echo "Creating an Admin Role"

json_arn_ap=$(aws iam create-policy --policy-name AdminPolicy --policy-document file://PermissionPolicy.json)

extracted_arn_ap=$(echo "$json_arn_ap" | jq -r '.Policy.Arn')

aws iam create-role --role-name Admin --assume-role-policy-document file://trustpolicy.json

aws iam attach-role-policy --role-name Admin --policy-arn $extracted_arn_ap

echo "Created an Admin Role"





