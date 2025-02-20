#!/bin/sh

echo "Running in Travis Pipeline"

while IFS= read -r rNumber || [ -n "$rNumber" ]
do
    echo "$rNumber"
done < releaseNumber.txt

git clone "git@github.com:gvram13541/DEMO.git"
cd DEMO

sed -i.bak "s/api_spec_version: r/*/api_spec_version: $rNumber/g" env.yaml

git checkout -b new_branch
git add .
git commit -m "new commit"
git push origin new_branch

gh pr create --repo gvram13541/DEMO --base main --head new_branch --title "New PR" --body "This is a new PR"