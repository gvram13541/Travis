#!/bin/sh

echo "Running in Travis Pipeline"

# DEBUG STEP
echo "Checking if releaseNumber.txt exists in the current directory: $(pwd)"
ls -l

echo "Finding the release_number.txt file..."
if [ -f "releaseNumber.txt" ]; then
    echo "Found releaseNumber.txt"
else
    echo "releaseNumber.txt not found. Exiting."
    exit 1
fi

echo "Copyting relaese number form text file to variable..."
rNumber=$(cat releaseNumber.txt)
echo "Release Number: $rNumber"

# rNumber=r100015

# DEBUG STEP
if [ -z "$rNumber" ]; then
    echo "Release number is empty. Exiting."
    exit 1
fi

echo "Cloning the DEMO repository..."
git clone "git@github.com:gvram13541/DEMO.git"
cd DEMO

# pr_list=$(gh pr list --state open --author "@me" --label spec_version --json number,headRefName -q '.[].number')
pr_list=$(gh pr list --state open --author "@me" --label spec_version --json headRefName -q '.[].headRefName')
if [ -n "$pr_list" ]; then
    echo "Open PRs with label 'spec_version':"
    echo "$pr_list"

    branch="$pr_list"
    echo "Checking out the branch: $branch"

    echo "Creting and changing to new branch..."
    if git rev-parse --verify "$branch" > /dev/null 2>&1; then
        echo "Branch "$branch" exists. Checking out the branch."
        git checkout "$branch" 
    else
        echo "Branch "$branch" does not exist. Creating a new branch."
        git checkout -b "$branch"
    fi
    
    git pull --rebase origin "$branch"

    echo "Modifying the env.yaml file..."
    sed -i.bak "s/api_spec_version: r[0-9]*/api_spec_version: $rNumber/g" env.yaml
    
    echo "Content of env.yaml after modification:"
    cat env.yaml

    echo "Checking for changes, adding them, committing and pushing..."
    git status
    git add env.yaml env.yaml.bak
    git commit -m "New commit with release number $rNumber"
    git push origin "$branch"

    echo "All PR's: "
    gh pr list 

    echo "Wanted PR's List: "
    gh pr list --state open --author "@me" --label spec_version
else
    echo "NO EXISTING PR's AVAILABLE...."

    echo "Creting and changing to new branch..."
    if git rev-parse --verify "$rNumber" > /dev/null 2>&1; then
        echo "Branch $rNumber exists. Checking out the branch."
        git checkout "$rNumber"
    else
        echo "Branch $rNumber does not exist. Creating a new branch."
        git checkout -b "$rNumber"
    fi

    echo "Modifying the env.yaml file..."
    sed -i.bak "s/api_spec_version: r[0-9]*/api_spec_version: $rNumber/g" env.yaml

    # DEBUG STEP
    echo "Content of env.yaml after modification:"
    cat env.yaml

    echo "Checking for changes, adding them, committing and pushing..."
    git status
    git add env.yaml env.yaml.bak
    git commit -m "New commit with release number $rNumber"
    git push origin "$rNumber"

    echo "Creating a pull request..."
    gh pr create --repo gvram13541/DEMO --base main --head "$rNumber" --title "New PR with $rNumber" --body "Automated PR from Travis for release $rNumber" --label "spec_version" --assignee "@me"

    echo "All PR's: "
    gh pr list 

    echo "Wanted PR's List: "
    gh pr list --state open --author "@me" --label spec_version
fi