#!/bin/bash
#
# gh-add-repos-to-team.sh

PERMISSION="pull" # Can be one of: pull, push, admin, maintain, triage
ORG="MyOrg"
TEAM_SLUG="read-only-all-repos"

# Get names with `gh repo list orgname`
REPOS=$(gh repo list "$ORG" --limit 1000 --json nameWithOwner -q '.[] | "\(.nameWithOwner)"')

# Process each repository name
echo "$REPOS" | while read -r REPO; do
  echo "Adding $TEAM_SLUG to $REPO with permission $PERMISSION"
  RESPONSE=$(gh api \
    --method PUT \
    -H "Accept: application/vnd.github+json" \
    -H "X-GitHub-Api-Version: 2022-11-28" \
    /orgs/$ORG/teams/$TEAM_SLUG/repos/$REPO \
    -f "permission=$PERMISSION" 2>&1)

  if echo "$RESPONSE" | grep -q "422"; then
    echo "Error: 422 Validation Failed for $REPO"
    echo "Response: $RESPONSE"
  else
    echo "Successfully added $TEAM_SLUG to $REPO"
  fi
done
