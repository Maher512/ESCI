#!/bin/bash

echo "Creating an Admin Role"

aws iam create-role --role-name Admin --assume-role-policy-document file://trustpolicy.json

aws iam put-role-policy --role-name Admin --policy-name AdminPolicy --policy-document file://PermissionPolicy.json

echo "Created an Admin Role"

sleep 2

echo "Creating an S3 Bucket and attaching it to a normal user role with limited permissions"

aws s3 mb s3://maher123-cli-bucket

echo "Created an S3 Bucket now creating the normal user role"

aws iam create-role --role-name Norm-User --assume-role-policy-document file://s3bucket_read_only.json

aws iam put-role-policy --role-name Norm-User --policy-name NormUserPolicy --policy-document file://ec2-ronly.json