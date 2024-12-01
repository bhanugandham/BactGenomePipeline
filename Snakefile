# Load configuration
configfile: "config.yaml"

# Define rules
rule all:
    input:
        expand(
            [
                "results/{sample}/assembly/assembly.fasta",
                "results/{sample}/raw_statreports",
                "results/{sample}/filtered_statreports",
                "results/{sample}/annotation"

            ],
            sample=config["samples"])

rule nanoplot_raw:
    input:
        fastq="data/{sample}.fastq.gz"
    output:
        dir=directory("results/{sample}/raw_statreports")
    log:
        "logs/{sample}_nanoplot_raw.log"
    conda:
        "environment/preprocessing.yaml"
    shell:
        "NanoPlot --fastq {input.fastq} --outdir {output.dir}"

rule porechop:
    input:
        fastq="data/{sample}.fastq.gz"
    output:
        fastq="results/{sample}/chopped.fastq.gz"
    log:
        "logs/{sample}_porechop.log"
    conda:
        "environment/preprocessing.yaml"
    shell:
        "porechop -i {input.fastq} -o {output.fastq} --threads 16"

rule filtlong:
    input:
        fastq="results/{sample}/chopped.fastq.gz"
    output:
        fastq="results/{sample}/filtered.fastq.gz"
    log:
        "logs/{sample}_filtlong.log"
    conda:
        "environment/preprocessing.yaml"
    shell:
        "filtlong --min_mean_q 10 --min_length 1000 {input.fastq} | gzip > {output.fastq}"

rule nanoplot_filtered:
    input:
        fastq="results/{sample}/filtered.fastq.gz"
    output:
        dir=directory("results/{sample}/filtered_statreports")
    log:
        "logs/{sample}_nanoplot_filtered.log"
    conda:
        "environment/preprocessing.yaml"
    shell:
        "NanoPlot --fastq {input.fastq} --outdir {output.dir}"

rule seqtk_subsample:
    input:
        fastq="results/{sample}/filtered.fastq.gz"
    output:
        fastq="results/{sample}/subsampled.fastq"
    log:
        "logs/{sample}_seqtk_subsample.log"
    conda:
        "environment/preprocessing.yaml"
    shell:
        "seqtk sample -s42 {input.fastq} 20000 > {output.fastq}"

rule flye:
    input:
        fastq="results/{sample}/subsampled.fastq"
    output:
        fasta="results/{sample}/assembly/assembly.fasta"
    log:
        "logs/{sample}_flye.log"
    conda:
        "environment/assembly.yaml"
    shell:
        "flye --nano-raw {input.fastq} --out-dir results/{wildcards.sample}/assembly --threads 32 --genome-size 4.6M"

rule prokka:
    input:
        fasta="results/{sample}/assembly/assembly.fasta"
    output:
        dir=directory("results/{sample}/annotation")
    log:
        "logs/{sample}_prokka.log"
    conda:
        "environment/annotation.yaml"
    shell:
        "prokka --outdir {output.dir} --prefix annotated --genus Escherichia --species coli --cpus 4 {input.fasta}"


