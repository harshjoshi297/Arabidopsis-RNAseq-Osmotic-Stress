#!/bin/bash

# ====================================================
# Script: 01_download.sh
# Purpose: Download RNA-seq datasets from NCBI SRA
# Project: Arabidopsis Osmotic Stress RNA-seq
# ====================================================

set -e

PROJECT_DIR="$HOME/RNASEQ/HeatStress_RNAseq"
RAW_DIR="$PROJECT_DIR/raw_data"

samples=(
    SRR33482818
    SRR33482817
    SRR33482806
    SRR33482795
    SRR33482788
    SRR33482787
)

mkdir -p "$RAW_DIR"

cd "$RAW_DIR"

echo "====================================="
echo "Starting RNA-seq download..."
echo "====================================="

for sample in "${samples[@]}"
do
    echo "Downloading $sample..."
    prefetch "$sample"
done

echo "====================================="
echo "All downloads completed successfully!"
echo "====================================="
