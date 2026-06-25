#!/bin/bash

# ====================================================
# Script: 06_samtools.sh
# Purpose: Convert SAM to sorted BAM and create index
# Project: Arabidopsis Osmotic Stress RNA-seq
# ====================================================

set -e

PROJECT_DIR="$HOME/RNASEQ/HeatStress_RNAseq"
ALIGN_DIR="$PROJECT_DIR/alignment"

samples=(
    SRR33482818
    SRR33482817
    SRR33482806
    SRR33482795
    SRR33482788
    SRR33482787
)

echo "====================================="
echo "Running SAMtools..."
echo "====================================="

for sample in "${samples[@]}"
do
    SAM="$ALIGN_DIR/${sample}.sam"
    BAM="$ALIGN_DIR/${sample}.bam"
    SORTED_BAM="$ALIGN_DIR/${sample}.sorted.bam"

    echo "-------------------------------------"
    echo "Processing $sample"
    echo "-------------------------------------"

    # Check SAM file exists
    if [ ! -f "$SAM" ]; then
        echo "ERROR: $SAM not found. Skipping..."
        continue
    fi

    # Convert SAM -> BAM
    if [ ! -f "$BAM" ]; then
        echo "Converting SAM to BAM..."
        samtools view \
            -@ 4 \
            -bS \
            "$SAM" \
            -o "$BAM"
    else
        echo "BAM already exists. Skipping conversion."
    fi

    # Sort BAM
    if [ ! -f "$SORTED_BAM" ]; then
        echo "Sorting BAM..."
        samtools sort \
            -@ 4 \
            "$BAM" \
            -o "$SORTED_BAM"
    else
        echo "Sorted BAM already exists. Skipping sorting."
    fi

    # Index sorted BAM
    if [ ! -f "${SORTED_BAM}.bai" ]; then
        echo "Indexing BAM..."
        samtools index \
            -@ 4 \
            "$SORTED_BAM"
    else
        echo "BAM index already exists. Skipping indexing."
    fi

done

echo "====================================="
echo "SAMtools processing completed!"
echo "====================================="
