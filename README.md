# **BactGenomePipeline: Bacterial Genome Annotation Pipeline**

**BactGenomePipeline** is a streamlined Snakemake pipeline designed to annotate bacterial genomes starting from raw FASTQ reads. The pipeline uses popular bioinformatics tools like **Flye**, **Prokka**, **NanoPlot**, **Porechop**, **Filtlong**, and others to QC, assemble, and annotate bacterial genomes.

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
```

### **2. Install Snakemake**

Ensure that Snakemake is installed:
```bash
conda install -c bioconda -c conda-forge snakemake -y
```

### **3. Create the Conda Environments**

The pipeline uses multiple Conda environments for different steps. You can create and activate them using the following command:
```bash
snakemake --use-conda --conda-create-envs-only
```
Snakemake will automatically create the required environments and install all dependencies as specified in the `environment` folder.

### **4. Install Conda Dependencies (if necessary)**

If you need to install individual Conda environments for preprocessing, assembly, and annotation, use the following commands:
- **Preprocessing**:
```bash
conda env create -f environment/preprocessing.yaml
```
- **Assembly**:
```bash
conda env create -f environment/assembly.yaml
```
- **Annotation**:
```bash
conda env create -f environment/annotation.yaml
```

---

## **Input Files**

The pipeline expects the following input:
- **FASTQ** file: Raw nanopore sequencing data (e.g., `SRR30810013.fastq.gz`).
The input files should be placed in the `data/` directory.

---

## **Pipeline Overview**

The pipeline processes the data in a series of steps:

### **1. Quality Control and Preprocessing**
- **NanoPlot**: Generates quality statistics and plots for the raw reads.
- **Porechop**: Removes adapter sequences from the raw reads.
- **Filtlong**: Filters the reads based on mean quality score and length.

### **2. Genome Assembly**

- **Flye**: Assembles the genome using nanopore raw reads. This step requires a sample file for the genome size and target genome.

### **3. Genome Annotation**

- **Prokka** : Annotates the assembled genome using a prokaryotic genome database and standard annotation parameters.

---

## **Configuration**
The pipeline is configured using the `config.yaml` file. Below is an example configuration:

```bash
samples:
  - SRR30810013
```
The `samples` field defines the list of sample identifiers (usually the name of the input FASTQ file without the extension).

---

## **Running the Pipeline**
To run the pipeline, execute the following command from the project directory:

```bash
snakemake --use-conda --cores 16 --jobs 16 --scheduler greedy -p
```
### **Options** 

- `--use-code` : Uses conda environments specified in the Snakefile.
- `--cores` : Allocates 16 CPU cores for execution. Adjust according to your available hardware.
- `--jobs 16`: Specifies that 16 jobs can be run in parallel.
- `--scheduler greedy`: Uses the "greedy" scheduler, which resolves jobs in a more flexible manner and can help avoid certain issues during scheduling.
- `-p`: Prints the commands as they are executed.

This command will process the input data, perform the necessary preprocessing, assembly, and annotation, and store the results in the `results/` directory. Additionally, this configuration ensures that the pipeline runs efficiently while utilizing available resources.

---

## **Output**

After running the pipeline, the following outputs will be generated:
- **Genome Assembly**:
  - `results/SRR30810013/assembly/polished_1.fasta`: The final polished genome assembly.
- **Genome Annotation**:
  - `results/SRR30810013/annotation/annotated.gbk`: GenBank format annotated genome.
  - `results/SRR30810013/annotation/annotated.gff`: GFF format annotated genome.
- **Reports**:
  - `results/SRR30810013/raw_statreports`: NanoPlot quality reports for raw reads.
  - `results/SRR30810013/filtered_statreports`: NanoPlot quality reports for filtered reads.

---

## **License**
This project is licensed under the MIT License - see the [LICENSE](https://github.com/bhanugandham/BactGenomePipeline/blob/main/LICENSE) file for details.

---

## **Acknowledgments**
This pipeline integrates several tools, including:

- **Flye** for genome assembly.
- **Prokka** for genome annotation.
- **NanoPlot**, **Porechop**, **Filtlong**, and others for quality control and preprocessing.

Special thanks to the authors of these tools for their contributions to bioinformatics.
Feel free to adapt and extend this pipeline based on your needs. If you encounter issues or have suggestions for improvements, please open an issue on the GitHub repository.

