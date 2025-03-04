#!/bin/bash

aws_portforward() {
    local profile="$1"
    local aws_cmd="aws"

    # Use aws-vault if profile provided
    if [ -n "$profile" ]; then
        if ! command -v aws-vault >/dev/null 2>&1; then
            echo "Error: aws-vault not installed."
            return 1
        fi
        aws_cmd="aws-vault exec $profile -- aws"
    fi

    # Check authentication
    if ! $aws_cmd sts get-caller-identity >/dev/null 2>&1; then
        echo "Error: AWS CLI not authenticated. Configure credentials or use aws-vault."
        return 1
    fi

    # Get account info
    local aws_account_id=$($aws_cmd sts get-caller-identity --query "Account" --output text)
    if [ -z "$aws_account_id" ]; then
        echo "Error: Failed to retrieve AWS account ID."
        return 1
    fi
    local aws_account_name=$($aws_cmd organizations describe-account --account-id "$aws_account_id" --query "Account.Name" --output text 2>/dev/null || echo "Unknown")
    echo "Connected to AWS account ID: $aws_account_id (Name: $aws_account_name)"

    # Get user input
    local remote_hostname
    local port_number
    read -p "Enter the remote hostname: " remote_hostname
    read -p "Enter the port number to be used: " port_number
    if [ -z "$remote_hostname" ] || [ -z "$port_number" ]; then
        echo "Error: Hostname and port number are required."
        return 1
    fi

    # Get instance ID (first jump-box)
    echo "Retrieving instance ID for jump-box..."
    local instance_id=$($aws_cmd ec2 describe-instances --filters "Name=tag:Name,Values=jump-box" "Name=instance-state-name,Values=running" --query "Reservations[*].Instances[*].[InstanceId]" --output text | head -n 1)
    if [ -z "$instance_id" ]; then
        echo "Error: No running jump-box instance found."
        return 1
    fi

    # Start port forwarding in background
    echo "Starting port forwarding from localhost:$port_number to $remote_hostname:$port_number via $instance_id..."
    $aws_cmd ssm start-session \
        --target "$instance_id" \
        --document-name AWS-StartPortForwardingSessionToRemoteHost \
        --parameters "{\"host\":[\"$remote_hostname\"],\"portNumber\":[\"$port_number\"],\"localPortNumber\":[\"$port_number\"]}" \
        --region "${AWS_REGION:-us-west-2}" &

    local ssm_pid=$!
    echo "Port forwarding started (PID: $ssm_pid). Use Ctrl+C to stop."

    # Wait for the SSM process to end (no keep-alive needed)
    wait $ssm_pid
    echo "Port forwarding session ended."
}

# Call with optional profile
if [ $# -gt 0 ]; then
    aws_portforward "$1"
else
    aws_portforward
fi