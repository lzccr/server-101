# First time only
sudo apt install git

# Config Info
git config --global user.name "lzccr"
git config --global user.email "someone@example.com"
git init

# Add default branch
git config --global init.defaultBranch main

# Stage All Changes
git add .

# Add the Repo
git remote add origin https://github.com/lzccr/repo.git

# Commit
git commit -m "First Commit"

# Push to GitHub
git push -u origin main #pushed to branch `main`

# Troubleshooting: 
# Is GitHub logged in on VSCode or not? 
# Is the email added to the GitHub account? 
# Is the permission config correct? 