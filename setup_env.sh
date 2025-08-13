#!/usr/bin/env bash
# Simple setup script to create a virtual environment and install all Python dependencies.
set -e

python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt -r requirements-dev.txt

echo "Environment ready. Activate it with 'source venv/bin/activate'."
