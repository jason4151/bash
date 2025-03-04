#!/bin/bash
# gh_add_repos_to_team.sh
# Add GitHub repos to a team in an organization with specified permissions

# Default values
PERMISSION="${1:-pull}"  # pull, push, admin, maintain, triage
ORG="${2:-MyOrg}"
TEAM_SLUG="${3:-read-only-all-repos}"

# Check if gh is authenticated
if ! gh auth status >/dev/null 2>&1; then
    echo "Error: GitHub CLI not authenticated. Run 'gh auth login' first."
    exit 1
fi

# Fetch repos (up to 1000, could use --paginate for more)
echo "Fetching repositories from $ORG..."
REPOS=$(gh repo list "$ORG" --limit 1000 --json nameWithOwner -q '.[] | .nameWithOwner') || {
    echo "Error: Failed to list repositories for $ORG."
    exit 1
}

# Process each repository
echo "Adding $TEAM_SLUG to repositories with $PERMISSION permission..."
echo "$REPOS" | while IFS= read -r repo; do
    if [ -z "$repo" ]; then
        continue  # Skip empty lines
    fi
    echo "Processing $repo..."
    response=$(gh api \
        --method PUT \
        -H "Accept: application/vnd.github+json" \
        -H "X-GitHub-Api-Version: 2022-11-28" \
        "/orgs/$ORG/teams/$TEAM_SLUG/repos/$repo" \
        -f "permission=$PERMISSION" 2>&1)

    if [ $? -eq 0 ]; then
        echo "Successfully added $TEAM_SLUG to $repo"
    else
        status_code=$(echo "$response" | grep -o "HTTP/[0-9.]\+ [0-9]\+" | awk '{print $2}' || echo "Unknown")
        echo "Error: Failed to add $TEAM_SLUG to $repo (HTTP $status_code)"
        echo "Response: $response"
    fi
done