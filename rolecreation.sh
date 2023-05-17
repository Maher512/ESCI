#!/bin/bash

echo "Creating role MyEC2S3Role with policy MyEC2S3Policy"

aws iam create-role --role-name MyEC2S3Role --assume-role-policy-document file://trustpolicy.json

aws iam put-role-policy --role-name MyEC2S3Role --policy-name MyEC2S3Policy --policy-document file://PermissionPolicy.json

echo "Created role MyEC2S3Role with policy MyEC2S3Policy"