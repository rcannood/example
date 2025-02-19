#!/bin/bash

# NOTE: The code in the first half of this file assumes you are running this inside the biobox repository!

## TRADITIONAL

# manual run of arriba
# (assuming that you have arriba installed)
arriba \
  -x src/arriba/test_data/A.bam \
  -a src/arriba/test_data/genome.fasta \
  -g src/arriba/test_data/annotation.gtf \
  -b src/arriba/test_data/blacklist.tsv \
  -o fusions.tsv \
  -O fusions_discarded.tsv \
  -i 1,2

# there's a way to do this with docker run as well
# but again requires a lot of boilerplate code
docker run ... ....

## EXECUTABLE
# we have a viash executable for running things via docker
target/executable/arriba/arriba \
  --bam src/arriba/test_data/A.bam \
  --genome src/arriba/test_data/genome.fasta \
  --gene_annotation src/arriba/test_data/annotation.gtf \
  --blacklist src/arriba/test_data/blacklist.tsv \
  --fusions output/fusions.tsv \
  --fusions_discarded output/fusions_discarded.tsv \
  --interesting_contigs 1,2


## Local run with Nextflow
nextflow run target/nextflow/arriba/main.nf \
  -profile docker \
  --bam src/arriba/test_data/A.bam \
  --genome src/arriba/test_data/genome.fasta \
  --gene_annotation src/arriba/test_data/annotation.gtf \
  --blacklist src/arriba/test_data/blacklist.tsv \
  --interesting_contigs 1,2 \
  --publish_dir output

## Alternatively, use a params file
cat > params.yaml << HERE
...
HERE

nextflow run target/nextflow/arriba/main.nf \
  -profile docker \
  -param-file params.yaml

# ------------------------------------------------------
# Using Viash Hub Packages

# EXECUTABLE
# currently working:
DIR=`pwd`
wget -O temp.zip https://viash-hub.com/vsh/biobox/-/archive/v0.3.0/biobox-v0.3.0.zip?path=target/executable/arriba
unzip temp.zip -d ~/Documents && rm temp.zip
cd ~/Documents/biobox-v0.3.0-target-executable-arriba

# id: ...
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

# desired interface:
# not working yet
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


# Local Nextflow run using remote code (viash hub)
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

# Seqera cloud
cat > params.yaml << HERE
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
HERE

cat > nextflow.config << HERE
process {
  memory = 30.GB
  cpus = 10
}
HERE

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
