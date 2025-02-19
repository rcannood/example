# Example usage of a Viash component

This document outlines how to use the `mycomp` component, including running it directly, building it, and executing it with Nextflow, both locally and remotely.

## Running Directly with Viash

Viash allows you to run the component without explicitly building it. It will handle the build process in a temporary directory.

### Showing Help

```bash
viash run src/mycomp/config.vsh.yaml -- --help
```

### Running with Input and Output

```bash
viash run src/mycomp/config.vsh.yaml -- \
  --input _viash.yaml \
  --output bar.txt
```

## Building the Component

To build the component for local execution:

```bash
viash ns build --setup cachedbuild
```

## Local Execution of the Executable

After building, the executable is located at `target/executable/mycomp/mycomp`.

### Showing Help

```bash
target/executable/mycomp/mycomp --help
```

### Running with Input and Output

```bash
target/executable/mycomp/mycomp --input _viash.yaml --output bar.txt
```

### Inspecting the Dockerfile

```bash
target/executable/mycomp/mycomp ---dockerfile
```

### Retrieving the Docker Image ID

```bash
target/executable/mycomp/mycomp ---docker_image_id
```

### Rebuilding the Container

```bash
target/executable/mycomp/mycomp ---setup cb
```

## Running with Nextflow

Nextflow allows for more complex workflows and parameterization.

### Running Locally with Arguments

```bash
nextflow run target/nextflow/mycomp/main.nf \
  --id foo \
  --input _viash.yaml \
  --publish_dir .
```

### Running Locally with a Parameter File

Create a `param.yaml` file:

```yaml
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
```

Then run:

```bash
nextflow run target/nextflow/mycomp/main.nf \
  -params-file param.yaml
```

### Running Locally from the Current Directory

```bash
nextflow run . \
  -main-script target/nextflow/mycomp/main.nf \
  -params-file param.yaml
```

### Running from a Remote Repository

```bash
nextflow run rcannood/example \
  -r main \
  -main-script target/nextflow/mycomp/main.nf \
  -params-file param.yaml
```

### Running Remotely from a Remote Repository

Create a `param_remote.yaml` file with remote input URLs:

```yaml
param_list:
  - id: foo
    input: https://raw.githubusercontent.com/rcannood/example/refs/heads/main/_viash.yaml
  - id: bar
    input: https://raw.githubusercontent.com/rcannood/example/refs/heads/main/_viash.yaml
publish_dir: gs://di-temporary/scratch/temp_example_output
```

Then launch the remote execution using `tw launch`:

```bash
tw launch [https://github.com/rcannood/example](https://github.com/rcannood/example) \
  --revision main \
  --main-script target/nextflow/mycomp/main.nf \
  --params-file param_remote.yaml \
  --workspace 20807160317427 \
  --compute-env 5TiKa1zTFJTQSbyeU6QSYb
```
