#!/bin/bash

set -e

# Step 1: Install Composer and NPM dependencies
echo "Installing PHP (Composer) dependencies..."
composer install

echo "Installing NPM dependencies..."
npm install

# Step 2: Create and activate Python virtual environment
echo "Creating Python virtual environment..."
python3 -m venv .venv
source .venv/bin/activate

# Step 3: Install pre-commit and register hooks
echo "Installing pre-commit and setting up hooks..."
pip install pre-commit
pre-commit install

echo "Dependencies installed and pre-commit hooks configured."
