#!/bin/bash

# Function to handle errors
error_exit() {
    echo "Error: $1"
    exit 1
}

# Check if the user is authenticated with an AWS account
get_user_auth() {
  if ! aws sts get-caller-identity > /dev/null 2>&1; then
    error_exit "AWS CLI is not authenticated. Please configure your AWS credentials."
  fi

  # Get the AWS account ID
  AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query "Account" --output text)
  
  # Get the AWS account name
  AWS_ACCOUNT_NAME=$(aws organizations describe-account --account-id "$AWS_ACCOUNT_ID" --query "Account.Name" --output text 2>/dev/null)
  
  # Check if the account name was retrieved successfully
  if [ -z "$AWS_ACCOUNT_NAME" ]; then
    error_exit "Could not retrieve the AWS account name. Please ensure you have the necessary permissions."
  fi

  # Inform the user about the AWS account they are connected to
  echo "You are connected to AWS account ID: $AWS_ACCOUNT_ID (Account Name: $AWS_ACCOUNT_NAME)"
}

# Function to retrieve the instance ID of the jump-box
get_instance_id() {
    echo "Retrieving instance ID for jump-box..."
    INSTANCE_ID=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=jump-box" "Name=instance-state-name,Values=running" --query "Reservations[*].Instances[*].[InstanceId]" --output text)
    if [[ -z "$INSTANCE_ID" ]]; then
        error_exit "Failed to retrieve instance ID for jump-box."
    fi
}

# Function to prompt the user for the hostname and port number
get_user_input() {
    read -p "Enter the remote hostname: " REMOTE_HOSTNAME
    read -p "Enter the port number to be used: " PORT_NUMBER
    if [[ -z "$REMOTE_HOSTNAME" || -z "$PORT_NUMBER" ]]; then
        error_exit "Hostname and port number are required."
    fi
}

# Function to start the port forwarding session
port_forward() {
    echo "Starting port forwarding session..."
    SESSION_ID=$(aws ssm start-session \
        --target "$INSTANCE_ID" \
        --document-name AWS-StartPortForwardingSessionToRemoteHost \
        --parameters "{\"host\":[\"$REMOTE_HOSTNAME\"],\"portNumber\":[\"$PORT_NUMBER\"],\"localPortNumber\":[\"$PORT_NUMBER\"]}" \
        --region us-west-2 \
        --query "SessionId" \
        --output text) || error_exit "Failed to start session."
}

# Function to keep the session alive using nc
keep_alive() {
    while true; do
        sleep 300
        echo "Sending keep-alive command..."
        echo -n | nc -w 1 localhost "$PORT_NUMBER" || error_exit "Failed to send keep-alive command."
    done
}

# Call the functions
get_user_auth
get_user_input
get_instance_id
port_forward&
keep_alive

# Wait for the session to end
wait $SESSION_ID
