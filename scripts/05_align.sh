#!/bin/bash

# ====================================================
# Script: 05_align.sh
# Purpose: Align FASTQ files to Arabidopsis genome
# Project: Arabidopsis Osmotic Stress RNA-seq
# ====================================================

set -e

PROJECT_DIR="$HOME/RNASEQ/HeatStress_RNAseq"
RAW_DIR="$PROJECT_DIR/raw_data"
ALIGN_DIR="$PROJECT_DIR/alignment"

INDEX="$HOME/RNASEQ/reference/ath_index"

samples=(
    SRR33482818
    SRR33482817
    SRR33482806
    SRR33482795
    SRR33482788
    SRR33482787
)

mkdir -p "$ALIGN_DIR"

echo "====================================="
echo "Running HISAT2 alignment..."
echo "====================================="

for sample in "${samples[@]}"
do
    FASTQ="$RAW_DIR/$sample/${sample}.fastq"
    SAM="$ALIGN_DIR/${sample}.sam"

    # Skip if already aligned
    if [ -f "$SAM" ]; then
        echo "✓ $sample already aligned. Skipping."
        continue
    fi

    echo "-------------------------------------"
    echo "Aligning $sample"
    echo "-------------------------------------"

    hisat2 \
        -p 4 \
        -x "$INDEX" \
        -U "$FASTQ" \
        -S "$SAM"

done

echo "====================================="
echo "Alignment complete!"
echo "====================================="
