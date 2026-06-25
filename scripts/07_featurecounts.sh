#!/bin/bash

# ====================================================
# Script: 07_featurecounts.sh
# Purpose: Generate gene count matrix
# Project: Arabidopsis Osmotic Stress RNA-seq
# ====================================================

set -e

PROJECT_DIR="$HOME/RNASEQ/HeatStress_RNAseq"

ALIGN_DIR="$PROJECT_DIR/alignment"
COUNT_DIR="$PROJECT_DIR/counts"

GTF="$HOME/RNASEQ/reference/Arabidopsis_thaliana.TAIR10.62.gtf"

mkdir -p "$COUNT_DIR"

echo "====================================="
echo "Running featureCounts..."
echo "====================================="

featureCounts \
    -T 4 \
    -t exon \
    -g gene_id \
    -a "$GTF" \
    -o "$COUNT_DIR/gene_counts.txt" \
    "$ALIGN_DIR"/*.sorted.bam

echo "====================================="
echo "featureCounts completed!"
echo "====================================="
