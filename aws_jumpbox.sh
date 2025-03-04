#!/bin/bash

aws_jumpbox() {
    local profile="$1"  # Optional aws-vault profile

    # Use aws-vault if a profile is provided
    if [ -n "$profile" ]; then
        if ! command -v aws-vault >/dev/null 2>&1; then
            echo "Error: aws-vault not installed."
            return 1
        fi
        local aws_cmd="aws-vault exec $profile -- aws"
    else
        local aws_cmd="aws"
    fi

    # Check if the user is authenticated
    if ! $aws_cmd sts get-caller-identity >/dev/null 2>&1; then
        echo "Error: AWS CLI is not authenticated. Configure credentials or use aws-vault."
        return 1
    fi

    # Get the AWS account ID
    AWS_ACCOUNT_ID=$($aws_cmd sts get-caller-identity --query "Account" --output text)
    if [ -z "$AWS_ACCOUNT_ID" ]; then
        echo "Error: Failed to retrieve AWS account ID."
        return 1
    fi

    # Get the AWS account name (optional)
    AWS_ACCOUNT_NAME=$($aws_cmd organizations describe-account --account-id "$AWS_ACCOUNT_ID" --query "Account.Name" --output text 2>/dev/null || echo "Unknown")
    
    # Inform the user about the AWS account
    echo "Connected to AWS account ID: $AWS_ACCOUNT_ID (Name: $AWS_ACCOUNT_NAME)"

    # Get the instance ID of the jump-box (take the first if multiple)
    AWS_INSTANCE_ID=$($aws_cmd ec2 describe-instances --filters "Name=tag:Name,Values=jump-box" "Name=instance-state-name,Values=running" --query "Reservations[*].Instances[*].[InstanceId]" --output text | head -n 1)
    
    if [ -z "$AWS_INSTANCE_ID" ]; then
        echo "Error: No running instance found with tag Name=jump-box."
        return 1
    fi

    echo "Starting SSM session to jump-box instance: $AWS_INSTANCE_ID"
    $aws_cmd ssm start-session --target "$AWS_INSTANCE_ID" --document-name AWS-StartInteractiveCommand --parameters command="bash -l"
    
    if [ $? -ne 0 ]; then
        echo "Error: Failed to start SSM session."
        return 1
    fi
}

# Call the function with optional profile argument
if [ $# -gt 0 ]; then
    aws_jumpbox "$1"
else
    aws_jumpbox
fi