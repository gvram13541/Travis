#!/bin/sh

echo "Running in Travis Pipeline"

echo "Checking if releaseNumber.txt exists in the current directory: $(pwd)"
ls -l  # List files in the current directory to verify if releaseNumber.txt exists

if [ -f "releaseNumber.txt" ]; then
    echo "Found releaseNumber.txt"
else
    echo "releaseNumber.txt not found. Exiting."
    exit 1
fi

# Read release number from the file and use it
# while IFS= read -r rNumber || [ -n "$rNumber" ]; do
#     echo "Release Number: $rNumber"
# done < releaseNumber.txt

cat releaseNumber.txt

# Read release number from the file and use it
rNumber=$(cat releaseNumber.txt)
echo "Release Number: $rNumber"

# Debugging: Check if rNumber is empty or not
echo "DEBUG: Release number: '$rNumber'"

# Clone the DEMO repository
echo "Cloning the DEMO repository..."
git clone "git@github.com:gvram13541/DEMO.git"
cd DEMO

# Modify the env.yaml file
sed -i.bak "s/api_spec_version: r\*/api_spec_version: $rNumber/g" env.yaml

# Ensure the new branch name is valid and switch to it (use 'git checkout -b' for compatibility)
git checkout -b new_branch || git checkout new_branch
# Stage, commit, and push the changes
git add .
git commit -m "New commit with release number $rNumber"
git push origin new_branch

# Create a pull request using the GitHub CLI (gh)
echo "Creating a pull request..."
gh pr create --repo gvram13541/DEMO --base main --head new_branch --title "New PR with $rNumber" --body "Automated PR from Travis for release $rNumber"