#!/bin/sh

echo "Running in Travis Pipeline"

# Check if releaseNumber.txt exists
echo "Checking if releaseNumber.txt exists in the current directory: $(pwd)"
ls -l  # List files in the current directory to verify if releaseNumber.txt exists

if [ -f "releaseNumber.txt" ]; then
    echo "Found releaseNumber.txt"
else
    echo "releaseNumber.txt not found. Exiting."
    exit 1
fi

# Read the release number from the file
rNumber=$(cat releaseNumber.txt)
echo "Release Number: $rNumber"

# Debugging: Check if rNumber is empty or not
echo "DEBUG: Release number: '$rNumber'"

if [ -z "$rNumber" ]; then
    echo "Release number is empty. Exiting."
    exit 1
fi

# Clone the DEMO repository
echo "Cloning the DEMO repository..."
git clone "git@github.com:gvram13541/DEMO.git"
cd DEMO

# Check if the branch already exists
if git rev-parse --verify "$rNumber" > /dev/null 2>&1; then
    echo "Branch $rNumber exists. Checking out the branch."
    git checkout "$rNumber"
else
    echo "Branch $rNumber does not exist. Creating a new branch."
    git checkout -b "$rNumber"
fi

# Modify the env.yaml file with the release number
echo "Modifying the env.yaml file..."
sed -i.bak "s/api_spec_version: r[0-9]*/api_spec_version: $rNumber/g" env.yaml

# Debugging: Ensure the file has been modified
echo "Content of env.yaml after modification:"
cat env.yaml

# Check if there are any changes to commit
git status

# Stage, commit, and push the changes
git add .
git commit -m "New commit with release number $rNumber"

git push origin "$rNumber"

# Create a pull request using the GitHub CLI (gh)
echo "Creating a pull request..."
gh pr create --repo gvram13541/DEMO --base main --head "$rNumber" --title "New PR with $rNumber" --body "Automated PR from Travis for release $rNumber"
