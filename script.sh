#!/bin/bash

# Read inputs from terminal
read -p "Enter your GitHub username: " REPO_OWNER
read -p "Enter your repository name: " REPO_NAME
read -p "Enter your personal access token: " TOKEN

# GitHub API URL
API_URL="https://api.github.com/repos/${REPO_OWNER}/${REPO_NAME}/collaborators"

# Make API request
RESPONSE=$(curl -s -H "Authorization: token $TOKEN" $API_URL)

# Check if request was successful
if [ $? -ne 0 ]; then
  echo "Error: Failed to fetch collaborators. Please check your inputs and try again."
  exit 1
fi

# Check if response contains an error message
ERROR=$(echo $RESPONSE | jq -r '.message')
if [ "$ERROR" != "null" ]; then
  echo "Error: $ERROR"
  exit 1
fi

# Parse response with jq
USERS=$(echo $RESPONSE | jq -r '.[].login')

# Output users with access
if [ -z "$USERS" ]; then
  echo "No users found with access to $REPO_OWNER/$REPO_NAME."
else
  echo "Users with access to $REPO_OWNER/$REPO_NAME:"
  echo "$USERS"
fi

