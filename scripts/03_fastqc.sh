#!/bin/bash

# ====================================================
# Script: 03_fastqc.sh
# Purpose: Run FastQC on all FASTQ files
# Project: Arabidopsis Osmotic Stress RNA-seq
# ====================================================

set -e

PROJECT_DIR="$HOME/RNASEQ/HeatStress_RNAseq"
RAW_DIR="$PROJECT_DIR/raw_data"
QC_DIR="$PROJECT_DIR/qc"

samples=(
    SRR33482818
    SRR33482817
    SRR33482806
    SRR33482795
    SRR33482788
    SRR33482787
)

mkdir -p "$QC_DIR"

echo "====================================="
echo "Running FastQC..."
echo "====================================="

for sample in "${samples[@]}"
do
    SAMPLE_DIR="$RAW_DIR/$sample"
    FASTQ_FILE="$SAMPLE_DIR/${sample}.fastq"

    # Skip if report already exists
    if [ -f "$QC_DIR/${sample}_fastqc.html" ]; then
        echo "✓ $sample already analyzed. Skipping."
        continue
    fi

    echo "Running FastQC on $sample..."

    fastqc \
        "$FASTQ_FILE" \
        --outdir "$QC_DIR"

done

echo "====================================="
echo "FastQC completed successfully!"
echo "====================================="
