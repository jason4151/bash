# Shell Scripts
An assortment of shell scripts that do various things.

# AWS Jump-Box Script

This script is designed to establish a secure session with a jump-box (EC2 instance) in an AWS environment. It performs several checks and operations to ensure a smooth connection.

## Prerequisites

- AWS CLI and Session Manager Plugin (SSM) must be installed and configured with the necessary credentials.
- The user must have the required permissions to access AWS STS, Organizations, EC2, and SSM services.

## Script Details

### Function: `jump-box`

1. **Authentication Check**:
   - The script first checks if the AWS CLI is authenticated by attempting to retrieve the caller identity using `aws sts get-caller-identity`.

2. **Retrieve AWS Account Information**:
   - It fetches the AWS account ID and account name using `aws sts get-caller-identity` and `aws organizations describe-account`.

3. **Inform User**:
   - The script informs the user about the AWS account they are connected to by displaying the account ID and name.

4. **Retrieve Jump-Box Instance ID**:
   - It retrieves the instance ID of the jump-box by filtering EC2 instances with the tag `Name=jump-box`.

5. **Start SSM Session**:
   - The script starts an SSM session with the jump-box instance using `aws ssm start-session`.

## Usage

To use the script, set its mode to executable and run it in your terminal:
```
chmod +x aws-jump-box.sh
./aws-jump-box.sh
```

# AWS Jump-Box Port Forwarding Script

This script is designed to establish a secure port forwarding session to a jump-box (EC2 instance) in an AWS environment. It includes several functions to handle authentication, retrieve necessary information, and start the session.

## Prerequisites

- AWS CLI and Session Manager Plugin (SSM) must be installed and configured with the necessary credentials.
- The user must have the required permissions to access AWS STS, Organizations, EC2, and SSM services.

## Script Details

### Function: `error_exit`

- Handles errors by printing an error message and exiting the script.

### Function: `get_user_auth`

1. **Authentication Check**:
   - Checks if the AWS CLI is authenticated by attempting to retrieve the caller identity using `aws sts get-caller-identity`.

2. **Retrieve AWS Account Information**:
   - Fetches the AWS account ID and account name using `aws sts get-caller-identity` and `aws organizations describe-account`.

3. **Inform User**:
   - Informs the user about the AWS account they are connected to by displaying the account ID and name.

### Function: `get_instance_id`

- Retrieves the instance ID of the jump-box by filtering EC2 instances with the tag `Name=jump-box`.

### Function: `get_user_input`

- Prompts the user to enter the remote hostname and port number for the port forwarding session.

### Function: `port_forward`

- Starts the port forwarding session using AWS SSM.

## Usage

To use the script, set its mode to executable and run it in your terminal:
```
chmod +x aws-port-forward.sh
./aws-port-forward.sh
```
