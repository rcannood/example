# build all components
viash ns build --setup cachedbuild

# show help
target/executable/mycomp/mycomp --help

# run locally with arguments
target/executable/mycomp/mycomp --input _viash.yaml --output bar.txt

# show dockerfile
target/executable/mycomp/mycomp ---dockerfile

# show docker image id
target/executable/mycomp/mycomp ---docker_image_id

# rebuild container
target/executable/mycomp/mycomp ---setup cb

# run locally with arguments
nextflow run target/nextflow/mycomp/main.nf \
  --id foo \
  --input _viash.yaml \
  --publish_dir .

# run locally with params file
cat > param.yaml << HERE
param_list:
  - id: foo
    input: _viash.yaml
  - id: bar
    input: _viash.yaml
  - id: zing
    input: _viash.yaml
  - id: dong
    input: _viash.yaml
  - id: xxx
    input: _viash.yaml
publish_dir: output
HERE

nextflow run target/nextflow/mycomp/main.nf \
  -params-file param.yaml


# run locally with arguments
nextflow run . \
  -main-script target/nextflow/mycomp/main.nf \
  -params-file param.yaml

# run from remote repository
nextflow run rcannood/example \
  -r main \
  -main-script target/nextflow/mycomp/main.nf \
  -params-file param.yaml

# run remotely from remote repository
cat > param_remote.yaml << HERE
param_list:
  - id: foo
    input: https://raw.githubusercontent.com/rcannood/example/refs/heads/main/_viash.yaml
  - id: bar
    input: https://raw.githubusercontent.com/rcannood/example/refs/heads/main/_viash.yaml
publish_dir: gs://di-temporary/scratch/temp_example_output
HERE

tw launch https://github.com/rcannood/example \
  --revision main \
  --main-script target/nextflow/mycomp/main.nf \
  --params-file param_remote.yaml \
  --workspace 20807160317427 \
  --compute-env 5TiKa1zTFJTQSbyeU6QSYb
