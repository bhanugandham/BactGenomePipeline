# **BactAnno: Bacterial Genome Annotation Pipeline**

**BactAnno** is a streamlined Snakemake pipeline designed to annotate bacterial genomes starting from raw FASTQ reads. The pipeline uses popular bioinformatics tools like **Flye**, **Prokka**, **NanoPlot**, **Porechop**, **Filtlong**, and others to process, assemble, and annotate bacterial genomes.

---

## **Overview**

This pipeline automates the process of:
1. **Quality Control and Preprocessing**: From raw FASTQ files to filtered reads.
2. **Genome Assembly**: Using the Flye assembler for nanopore sequencing data.
3. **Genome Annotation**: Annotating the assembled genome with Prokka.

**Outputs**: The pipeline generates an annotated genome in **GBK** and **GFF** formats.

---

## **Table of Contents**

- [Installation](#installation)
- [Input Files](#input-files)
- [Pipeline Overview](#pipeline-overview)
- [Configuration](#configuration)
- [Running the Pipeline](#running-the-pipeline)
- [Output](#output)
- [License](#license)

---

## **Installation**

To set up and run this pipeline, follow these steps:

### **1. Clone the Repository**

Clone the GitHub repository to your local machine:
```bash
git clone <repository_url>
cd <repository_name>
