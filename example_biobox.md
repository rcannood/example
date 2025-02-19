# Biobox component usage

NOTE: The code in the first half of this file assumes you are running this inside the biobox repository!


This document provides instructions on how to run the `arriba` component using various methods, including traditional manual execution, Viash executables, and Nextflow workflows, both locally and remotely.

## Traditional Manual Execution

This method requires `arriba` to be installed directly on your system.

```bash
arriba \
  -x src/arriba/test_data/A.bam \
  -a src/arriba/test_data/genome.fasta \
  -g src/arriba/test_data/annotation.gtf \
  -b src/arriba/test_data/blacklist.tsv \
  -o fusions.tsv \
  -O fusions_discarded.tsv \
  -i 1,2
```

Alternatively, you can use Docker, but this typically involves more complex commands.

## Viash Executable

Viash provides an executable that simplifies running `arriba` within a Docker container.

```bash
target/executable/arriba/arriba \
  --bam src/arriba/test_data/A.bam \
  --genome src/arriba/test_data/genome.fasta \
  --gene_annotation src/arriba/test_data/annotation.gtf \
  --blacklist src/arriba/test_data/blacklist.tsv \
  --fusions output/fusions.tsv \
  --fusions_discarded output/fusions_discarded.tsv \
  --interesting_contigs 1,2
```

## Local Nextflow Execution

Nextflow allows for reproducible and scalable execution of `arriba` workflows.

### Running with Command-Line Arguments

```bash
nextflow run target/nextflow/arriba/main.nf \
  -profile docker \
  --bam src/arriba/test_data/A.bam \
  --genome src/arriba/test_data/genome.fasta \
  --gene_annotation src/arriba/test_data/annotation.gtf \
  --blacklist src/arriba/test_data/blacklist.tsv \
  --interesting_contigs 1,2 \
  --publish_dir output
```

### Running with a Parameter File

Create a `params.yaml` file with your parameters:

```yaml
# ... your parameters here ...
```

Then run Nextflow with the parameter file:

```bash
nextflow run target/nextflow/arriba/main.nf \
  -profile docker \
  -param-file params.yaml
```

## Using Viash Hub Packages

### Executable (Manual Download and Execution)

This demonstrates manually downloading and running the `arriba` executable from Viash Hub.

```bash
DIR=`pwd`
wget -O temp.zip https://viash-hub.com/vsh/biobox/-/archive/v0.3.0/biobox-v0.3.0.zip?path=target/executable/arriba
unzip temp.zip -d ~/Documents && rm temp.zip
cd ~/Documents/biobox-v0.3.0-target-executable-arriba

target/executable/arriba/arriba \
  ---cpus 10 \
  ---memory 4G \
  --bam "$DIR/src/arriba/test_data/A.bam" \
  --genome "$DIR/src/arriba/test_data/genome.fasta" \
  --gene_annotation "$DIR/src/arriba/test_data/annotation.gtf" \
  --blacklist "$DIR/src/arriba/test_data/blacklist.tsv" \
  --fusions "$DIR/output/fusions.tsv" \
  --fusions_discarded "$DIR/output/fusions_discarded.tsv" \
  --interesting_contigs 1,2

cd "$DIR"
```

### Viash Run (Desired Interface - Not Fully Implemented)

This shows the desired interface for running Viash Hub packages directly, which may not be fully functional yet.

```bash
viash run biobox@v0.3.0:arriba -- \
  ---cpus 10 \
  ---memory 4G \
  --bam src/arriba/test_data/A.bam \
  --genome src/arriba/test_data/genome.fasta \
  --gene_annotation src/arriba/test_data/annotation.gtf \
  --blacklist src/arriba/test_data/blacklist.tsv \
  --fusions output/fusions.tsv \
  --fusions_discarded output/fusions_discarded.tsv \
  --interesting_contigs 1,2
```

### Local Nextflow Run Using Remote Code (Viash Hub)

```bash
nextflow run https://viash-hub.com/vsh/biobox \
  -r v0.3.0 \
  -hub vsh \
  -latest \
  -main-script target/nextflow/arriba/main.nf \
  -profile docker \
  --bam src/arriba/test_data/A.bam \
  --genome src/arriba/test_data/genome.fasta \
  --gene_annotation src/arriba/test_data/annotation.gtf \
  --blacklist src/arriba/test_data/blacklist.tsv \
  --interesting_contigs 1,2 \
  --publish_dir output
```

### Seqera Cloud Execution

This demonstrates running `arriba` on Seqera Cloud using remote data and configurations.

Create `params.yaml`:

```yaml
param_list:
  - id: foo
    bam: https://github.com/viash-hub/biobox/raw/refs/heads/main/src/arriba/test_data/A.bam
  - id: bar
    bam: https://github.com/viash-hub/biobox/raw/refs/heads/main/src/arriba/test_data/A.bam
genome: https://raw.githubusercontent.com/viash-hub/biobox/refs/heads/main/src/arriba/test_data/genome.fasta
gene_annotation: https://raw.githubusercontent.com/viash-hub/biobox/refs/heads/main/src/arriba/test_data/annotation.gtf
blacklist: https://raw.githubusercontent.com/viash-hub/biobox/refs/heads/main/src/arriba/test_data/blacklist.tsv
interesting_contigs: ["1", "2"]
publish_dir: gs://di-temporary/scratch/temp_demo_arriba
```

Create `nextflow.config`:

```groovy
process {
  memory = 30.GB
  cpus = 10
}
```

Launch the workflow on Seqera Cloud:

```bash
tw launch \
  https://viash-hub.com/vsh/biobox \
  --revision v0.3.0 \
  --main-script target/nextflow/arriba/main.nf \
  --pull-latest \
  --workspace 20807160317427 \
  --compute-env 5TiKa1zTFJTQSbyeU6QSYb \
  --work-dir gs://di-temporary/work/ \
  --params-file params.yaml \
  --config nextflow.config
```
