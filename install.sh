#!/bin/bash

set -e

# Create a temporary directory
echo "Creating temporary working directory..."
TEMP_DIR=$(mktemp -d)
echo "Using temp dir: $TEMP_DIR"

# Clone template repo into temp dir
echo "Cloning Laravel template..."
git clone --depth=1 https://github.com/Endkind/laravel_pre_commit.git "$TEMP_DIR/template"

# Remove .git, install.* and .gitattributes from the template directory
rm -rf "$TEMP_DIR/template/.git"
rm -f "$TEMP_DIR/template"/install.*
rm -f "$TEMP_DIR/template/.gitattributes"

# Copy files from template to current directory
cp -r "$TEMP_DIR/template/"* .
cp -r "$TEMP_DIR/template/".* . 2>/dev/null || true

# Remove temp directory
echo "Removing temporary files..."
rm -rf "$TEMP_DIR"

# Initialize git if not present
if [ ! -d ".git" ]; then
  echo "Initializing Git repository..."
  git init
fi

# Ensure .venv is in .gitignore
if ! grep -q "^.venv$" .gitignore 2>/dev/null; then
  echo ".venv" >> .gitignore
fi

# Step 1: Install Composer and NPM dependencies
echo "Installing PHP (Composer) dependencies..."
composer install

echo "Installing NPM dependencies..."
npm install

# Step 2: Install Larastan via Composer
echo "Installing larastan/larastan..."
composer require --dev larastan/larastan

# Step 3: Install ESLint and Stylelint packages
echo "Installing ESLint and Stylelint packages..."
npm install --save-dev eslint stylelint stylelint-config-standard stylelint-config-tailwindcss

# Step 4: Create and activate Python virtual environment
echo "Creating Python virtual environment..."
python3 -m venv .venv
source .venv/bin/activate

# Step 5: Install pre-commit
echo "Installing pre-commit..."
pip install pre-commit

# Step 6: Install pre-commit hooks into git
echo "Installing pre-commit into Git..."
pre-commit install

# Final Step: Git add and commit
echo "Creating initial commit..."
git add .
git commit -m "init" || {
  echo "Initial commit failed, retrying..."
  git add .
  git commit -m "init"
}

# Remove this script
rm -- "$0"

echo "All done!"
