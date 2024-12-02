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
    conda:
        "environment/preprocessing.yaml"
    shell:
        "NanoPlot --fastq {input.fastq} --outdir {output.dir}"

rule porechop:
    input:
        fastq="data/{sample}.fastq.gz"
    output:
        fastq="results/{sample}/chopped.fastq.gz"
    conda:
        "environment/preprocessing.yaml"
    shell:
        "porechop -i {input.fastq} -o {output.fastq} --threads 16"

rule filtlong:
    input:
        fastq="results/{sample}/chopped.fastq.gz"
    output:
        fastq="results/{sample}/filtered.fastq.gz"
    conda:
        "environment/preprocessing.yaml"
    shell:
        "filtlong --min_mean_q 10 --min_length 1000 {input.fastq} | gzip > {output.fastq}"

rule nanoplot_filtered:
    input:
        fastq="results/{sample}/filtered.fastq.gz"
    output:
        dir=directory("results/{sample}/filtered_statreports")
    conda:
        "environment/preprocessing.yaml"
    shell:
        "NanoPlot --fastq {input.fastq} --outdir {output.dir}"

rule seqtk_subsample:
    input:
        fastq="results/{sample}/filtered.fastq.gz"
    output:
        fastq="results/{sample}/subsampled.fastq"
    conda:
        "environment/preprocessing.yaml"
    shell:
        "seqtk sample -s42 {input.fastq} 20000 > {output.fastq}"

rule flye:
    input:
        fastq="results/{sample}/subsampled.fastq"
    output:
        fasta="results/{sample}/assembly/assembly.fasta"
    conda:
        "environment/assembly.yaml"
    shell:
        "flye --nano-raw {input.fastq} --out-dir results/{wildcards.sample}/assembly --threads 32 --genome-size 4.6M"

rule prokka:
    input:
        fasta="results/{sample}/assembly/assembly.fasta"
    output:
        dir=directory("results/{sample}/annotation")
    conda:
        "environment/annotation.yaml"
    shell:
        "prokka --outdir {output.dir} --prefix annotated --genus Escherichia --species coli --cpus 4 {input.fasta}"


