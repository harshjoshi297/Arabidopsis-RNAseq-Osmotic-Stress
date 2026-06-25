# ==========================================================
# Script: 08_deseq2.R
# Purpose: Differential Gene Expression Analysis using DESeq2
# Project: Arabidopsis Osmotic Stress RNA-seq
# ==========================================================

# Load libraries
library(DESeq2)

# Project directory
project_dir <- "~/RNASEQ/HeatStress_RNAseq"

# Input files
count_file <- file.path(project_dir, "counts", "gene_counts.txt")
metadata_file <- file.path(project_dir, "metadata", "sample_info.csv")

# Output directory
output_dir <- file.path(project_dir, "results", "deseq2")
dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
# ==========================================================
# Read count matrix
# ==========================================================

counts <- read.table(
  count_file,
  header = TRUE,
  sep = "\t",
  comment.char = "#",
  stringsAsFactors = FALSE,
  check.names = FALSE
)

# Remove annotation columns (Geneid, Chr, Start, End, Strand, Length)
count_data <- counts[, 7:ncol(counts)]

# Use Gene IDs as row names
rownames(count_data) <- counts$Geneid

# Clean sample names (remove paths and .sorted.bam)
colnames(count_data) <- basename(colnames(count_data))
colnames(count_data) <- sub("\\.sorted\\.bam$", "", colnames(count_data))

# Convert to numeric matrix
count_data <- as.matrix(count_data)
mode(count_data) <- "integer"

# ==========================================================
# Read sample metadata
# ==========================================================

sample_info <- read.csv(
  metadata_file,
  stringsAsFactors = FALSE
)

rownames(sample_info) <- sample_info$Sample

# Reorder metadata to match count matrix columns
sample_info <- sample_info[colnames(count_data), ]

# Convert condition to factor
sample_info$Condition <- factor(sample_info$Condition)

# ==========================================================
# Verify everything matches
# ==========================================================

print(colnames(count_data))
print(rownames(sample_info))

stopifnot(all(colnames(count_data) == rownames(sample_info)))
# ==========================================================
# Create DESeq2 dataset
# ==========================================================

dds <- DESeqDataSetFromMatrix(
  countData = count_data,
  colData = sample_info,
  design = ~ Condition
)

# Remove genes with very low counts
dds <- dds[rowSums(counts(dds)) >= 10, ]

cat("Number of genes after filtering:",
    nrow(dds), "\n")

# ==========================================================
# Run differential expression analysis
# ==========================================================

dds <- DESeq(dds)

# Extract results
res <- results(dds)

# Order by adjusted p-value
res <- res[order(res$padj), ]

# Convert to data frame
res_df <- as.data.frame(res)

# Add Gene IDs as a column
res_df$GeneID <- rownames(res_df)

# Move GeneID to first column
res_df <- res_df[, c("GeneID",
                     "baseMean",
                     "log2FoldChange",
                     "lfcSE",
                     "stat",
                     "pvalue",
                     "padj")]
# ==========================================================
# Save DESeq2 results
# ==========================================================

# Save complete results
write.csv(
  res_df,
  file = file.path(output_dir, "deseq2_results.csv"),
  row.names = FALSE
)

# Significant genes
sig_res <- subset(
  res_df,
  padj < 0.05 & abs(log2FoldChange) > 1
)

write.csv(
  sig_res,
  file = file.path(output_dir, "significant_genes.csv"),
  row.names = FALSE
)

# Save normalized counts
normalized_counts <- counts(dds, normalized = TRUE)

write.csv(
  normalized_counts,
  file = file.path(output_dir, "normalized_counts.csv")
)

cat("=====================================\n")
cat("Total genes:", nrow(res_df), "\n")
cat("Significant genes:", nrow(sig_res), "\n")
cat("=====================================\n")

# ==========================================================
# MA Plot
# ==========================================================

pdf(
  file.path(output_dir, "MA_plot.pdf"),
  width = 8,
  height = 6
)

plotMA(
  res,
  ylim = c(-5, 5),
  main = "Mock vs Sorbitol"
)

dev.off()
# ==========================================================
# Additional libraries
# ==========================================================

library(ggplot2)
library(pheatmap)

# ==========================================================
# Variance Stabilizing Transformation
# ==========================================================

vsd <- vst(dds, blind = FALSE)

# ==========================================================
# PCA Plot
# ==========================================================

pdf(file.path(output_dir, "PCA_plot.pdf"), width = 7, height = 6)

plotPCA(vsd, intgroup = "Condition")

dev.off()

# ==========================================================
# Volcano Plot
# ==========================================================

volcano <- res_df

volcano$Significant <- "Not Significant"
volcano$Significant[
    volcano$padj < 0.05 &
    abs(volcano$log2FoldChange) > 1
] <- "Significant"

pdf(file.path(output_dir, "Volcano_plot.pdf"), width = 8, height = 6)

ggplot(volcano,
       aes(x = log2FoldChange,
           y = -log10(padj),
           color = Significant)) +
    geom_point(alpha = 0.7, size = 1.2) +
    theme_bw() +
    labs(
        title = "Volcano Plot",
        x = "Log2 Fold Change",
        y = "-log10 Adjusted P-value"
    )

dev.off()

# ==========================================================
# Heatmap
# ==========================================================

top_genes <- head(rownames(res[order(res$padj), ]), 50)

mat <- assay(vsd)[top_genes, ]

mat <- mat - rowMeans(mat)

pdf(file.path(output_dir, "Heatmap_top50.pdf"),
    width = 8,
    height = 10)

pheatmap(
    mat,
    annotation_col = sample_info,
    show_rownames = FALSE,
    fontsize_col = 12
)

dev.off()

cat("Analysis completed successfully!\n")
