#!/bin/bash

# ====================================================
# Script: 02_convert.sh
# Purpose: Convert SRA files to FASTQ
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

echo "====================================="
echo "Converting SRA to FASTQ..."
echo "====================================="

for sample in "${samples[@]}"
do
    SAMPLE_DIR="$RAW_DIR/$sample"

    # Skip if FASTQ already exists
    if [ -f "$SAMPLE_DIR/${sample}.fastq" ]; then
        echo "✓ $sample already converted. Skipping."
        continue
    fi

    echo "Converting $sample..."

    fasterq-dump \
        "$SAMPLE_DIR/${sample}.sra" \
        -O "$SAMPLE_DIR"

done

echo "====================================="
echo "Conversion complete!"
echo "====================================="
