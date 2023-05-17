#!bin/bash

# Creating an S3 Bucket
aws s3 mb s3://maher123-cli-bucket

#Creating a Read Only Policy for the S3 Bucket

json_arn=$(aws iam create-policy --policy-name ReadOnlyS3Policy --policy-document file://s3bucket_read_only.json)

extracted_arn=$(echo "$json_arn" | jq -r '.Policy.Arn')

aws iam create-role --role-name NUser --assume-role-policy-document file://trustpolicy.json

aws iam attach-role-policy --role-name NUser --policy-arn $extracted_arn
