#!/bin/bash

jump-box() {
  # Check if the user is authenticated
  if ! aws sts get-caller-identity > /dev/null 2>&1; then
    echo "Error: AWS CLI is not authenticated. Please configure your AWS credentials."
    return 1
  fi

  # Get the AWS account ID
  AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query "Account" --output text)
  
  # Get the AWS account name
  AWS_ACCOUNT_NAME=$(aws organizations describe-account --account-id "$AWS_ACCOUNT_ID" --query "Account.Name" --output text 2>/dev/null)
  
  # Check if the account name was retrieved successfully
  if [ -z "$AWS_ACCOUNT_NAME" ]; then
    echo "Error: Could not retrieve the AWS account name. Please ensure you have the necessary permissions."
    return 1
  fi

  # Inform the user about the AWS account they are connected to
  echo "You are connected to AWS account ID: $AWS_ACCOUNT_ID (Account Name: $AWS_ACCOUNT_NAME)"

  # Get the instance ID of the jump-box
  AWS_INSTANCE_ID=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=jump-box" "Name=instance-state-name,Values=running" --query "Reservations[*].Instances[*].[InstanceId]" --output text)
  
  # Check if the instance ID was retrieved successfully
  if [ -z "$AWS_INSTANCE_ID" ]; then
    echo "Error: Could not find an instance with the tag Name=jump-box."
    return 1
  fi

  # Start the SSM session
  aws ssm start-session --target "$AWS_INSTANCE_ID" --document-name AWS-StartInteractiveCommand --parameters command="bash -l"
  
  # Check if the SSM session started successfully
  if [ $? -ne 0 ]; then
    echo "Error: Failed to start SSM session."
    return 1
  fi
}

# Call the function
jump-box
