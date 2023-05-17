#!/bin/bash

ROLE_NAME="Administartor"

# Detach all policies from the role
for policy in $(aws iam list-attached-role-policies --role-name $ROLE_NAME --query 'AttachedPolicies[].PolicyArn' --output text)
do
    aws iam detach-role-policy --role-name $ROLE_NAME --policy-arn $policy
done

# Delete the role
aws iam delete-role --role-name $ROLE_NAME
