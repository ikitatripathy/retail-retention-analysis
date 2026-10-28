#!/usr/bin/env bash
# One command to reproduce everything: data -> cleaning -> SQL -> analysis -> charts
set -e
pip install -r requirements.txt
python src/generate_data.py
python src/run_analysis.py
echo "Done. See outputs/charts and outputs/tables"
