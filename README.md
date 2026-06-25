# Arabidopsis RNA-seq Differential Expression Analysis under Osmotic Stress

An end-to-end RNA-seq analysis pipeline for identifying differentially expressed genes in *Arabidopsis thaliana* under osmotic stress using publicly available sequencing data.

---

## Overview

This project implements a complete bulk RNA-seq workflow starting from raw sequencing data obtained from the NCBI Sequence Read Archive (SRA) through differential gene expression analysis.

The pipeline compares **Mock-treated** and **Sorbitol-treated** *Arabidopsis thaliana* samples to identify genes involved in the osmotic stress response.

---

## Biological Question

How does osmotic stress alter gene expression in *Arabidopsis thaliana*?

Using RNA sequencing, this project identifies genes whose expression changes significantly following sorbitol treatment.

---

## Dataset

**Species:** *Arabidopsis thaliana*

**Treatment:** Mock vs Sorbitol

**Replicates:** 3 biological replicates per condition

**Sequencing Platform:** Illumina

**Read Type:** Single-end

**Read Length:** 86 bp

### Samples

| Sample      | Condition |
| ----------- | --------- |
| SRR33482818 | Mock      |
| SRR33482817 | Mock      |
| SRR33482806 | Mock      |
| SRR33482795 | Sorbitol  |
| SRR33482788 | Sorbitol  |
| SRR33482787 | Sorbitol  |

---

# Workflow

```
SRA Download
      │
      ▼
FASTQ Conversion
      │
      ▼
Quality Control
(FastQC)
      │
      ▼
QC Summary
(MultiQC)
      │
      ▼
Genome Alignment
(HISAT2)
      │
      ▼
SAM → BAM
Sorting & Indexing
(SAMtools)
      │
      ▼
Gene Quantification
(featureCounts)
      │
      ▼
Differential Expression
(DESeq2)
      │
      ▼
Visualization
(PCA, MA Plot,
Volcano Plot,
Heatmap)
```

---

# Software

| Software      | Purpose                                |
| ------------- | -------------------------------------- |
| FastQC        | Raw read quality assessment            |
| MultiQC       | Aggregate QC reports                   |
| HISAT2        | Splice-aware genome alignment          |
| SAMtools      | BAM conversion, sorting and indexing   |
| featureCounts | Gene-level read counting               |
| DESeq2        | Differential expression analysis       |
| R             | Statistical analysis and visualization |

---

# Repository Structure

```
.
├── metadata/
├── results/
│   └── deseq2/
├── scripts/
│   ├── 01_download.sh
│   ├── 02_convert.sh
│   ├── 03_fastqc.sh
│   ├── 04_multiqc.sh
│   ├── 05_align.sh
│   ├── 06_samtools.sh
│   ├── 07_featurecounts.sh
│   └── 08_deseq2.R
├── README.md
└── .gitignore
```

---

# Results

The analysis identified differentially expressed genes between Mock and Sorbitol-treated samples.

Summary:

* Total genes analyzed: **21,623**
* Significantly differentially expressed genes (adjusted p-value < 0.05 and |log₂FC| > 1): **3,009**

The pipeline generated:

* MA Plot
* PCA Plot
* Volcano Plot
* Heatmap of the top differentially expressed genes

Figures are available in:

```
results/deseq2/
```

---

# Skills Demonstrated

* Linux command line
* Bash scripting
* RNA-seq workflow development
* Quality control of sequencing data
* Splice-aware read alignment
* SAM/BAM file processing
* Gene expression quantification
* Differential gene expression analysis
* Data visualization in R
* Reproducible bioinformatics workflows using Git and GitHub

---

# Future Improvements

* Functional enrichment analysis (GO/KEGG)
* Pathway analysis
* Gene annotation of significant hits
* Interactive visualization dashboard
* Workflow automation using Snakemake or Nextflow

---

# Author

Harsh Joshi

M.Sc. Biological Sciences (Plant Molecular Biology)

Interested in Plant Genetics, Functional Genomics and Bioinformatics.
