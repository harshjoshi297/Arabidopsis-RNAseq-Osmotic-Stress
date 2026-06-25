#!/bin/bash

# ====================================================
# Script: 04_multiqc.sh
# Purpose: Generate MultiQC report
# Project: Arabidopsis Osmotic Stress RNA-seq
# ====================================================

set -e

PROJECT_DIR="$HOME/RNASEQ/HeatStress_RNAseq"
QC_DIR="$PROJECT_DIR/qc"

cd "$QC_DIR"

echo "====================================="
echo "Running MultiQC..."
echo "====================================="

multiqc . --force

echo "====================================="
echo "MultiQC completed successfully!"
echo "====================================="
