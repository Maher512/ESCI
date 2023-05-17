#!/bin/bash

aws s3 mb s3://maher123-cli-bucket

# Define policy and role names
POLICY_NAME="MyS3ReadPolicy"
ROLE_NAME="ExistingRoleName"

# Define a JSON policy document
POLICY_DOCUMENT=$(cat <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "Stmt1",
            "Effect": "Allow",
            "Action": [
                "s3:Get*",
                "s3:List*"
            ],
            "Resource": "arn:aws:s3:::maher123-cli-bucket"
        }
    ]
}
EOF
)

# Create an IAM policy and parse the output to get the policy ARN
POLICY_ARN=$(aws iam create-policy --policy-name "$POLICY_NAME" --policy-document "$POLICY_DOCUMENT" | jq -r .Policy.Arn)

echo "Created policy with ARN: $POLICY_ARN"

# Attach the policy to the role
aws iam attach-role-policy --role-name "$ROLE_NAME" --policy-arn "$POLICY_ARN"

echo "Attached policy $POLICY_NAME to role $ROLE_NAME"
