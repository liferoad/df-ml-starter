# df-ml-starter

## Summary
This repo contains a simple Beam RunInference project, which demonstrates how to run this Beam pipeline using DirectRunner to develope and test
and launch the production job using DataflowRunner on either CPUs or GPUs. It can be served as a boilerplate to create a new Dataflow ML project.

## Prerequisites

* conda
* git
* make
* docker
* gcloud
* python3-venv

```bash
sudo apt-get update
sudo apt-get install -y python3-venv git make
```
Install Docker on Debian: https://docs.docker.com/engine/install/debian/
Without sudo,
```bash
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker
```

## Directory structure
```
.
├── LICENSE
├── Makefile                <- Makefile with commands and type `make` to get the command list
├── README.md               <- The top-level README for developers using this project
├── data                    <- Any data for local development and testing
│   └── openimage_10.txt    <- A sample test data that contains the gcs file path for each image
├── pyproject.toml          <- The TOML format Python project configuration file
├── requirements.dev.txt    <- Packages for the development such as `pytest`
├── requirements.txt        <- The auto-generated packages for the production environment
├── requirements.prod.txt   <- Packages for the production environment and produces `requirements.txt`
├── setup.py                <- Used in `python setup.py sdist` to create the multi-file python package
├── src                     <- Source code for use in this project
│   ├── __init__.py         <- Makes src a Python module
│   ├── config.py           <- `pydantic` model classes to define sources, sinks, and models
│   ├── pipeline.py         <- Builds the Beam RunInference pipeline
│   └── run.py              <- A run module to parse the command options and run the Beam pipeline
├── tensor_rt.Dockerfile    <- A Dockerfile to create a customer container with TensorRT
└── tests                   <- Tests to cover local developments
    └── test_pipeline.py
```

## User Guide

**This process is only tested on GCE with Debian.**

### Step 1: Clone this repo and edit .env

```bash
git clone https://github.com/liferoad/df-ml-starter.git
cd df-ml-starter
cp .env.template .env
```
Use your editor to fill in the information in the `.env` file.

If you want to try other ML models under `gs://apache-beam-ml/models/`,
```bash
gsutil ls gs://apache-beam-ml/models/
```

It is highly recommended to run through this guide once using `resnet101` for image classification.

All the useful actions can be triggered using `make`:
```console
$ make

  make targets:

     clean                     Remove virtual environment, downloaded models, etc
     clean-lite                Remove pycache files, pytest files, etc
     docker                    Build a custom docker image and push it to Artifact Registry
     format                    Run formatter on source code
     help                      Print this help
     init                      Init virtual environment
     init-venv                 Create virtual environment in venv folder
     lint                      Run linter on source code
     run-df                    Run a Dataflow job using the custom container with GPUs
     run-direct                Run a local test with DirectRunner
     test                      Run tests
```

### Step 2: Initialize a venv for your project
```bash
make init
source venv/bin/activate
```
Note you must make sure the base Python version matches the version defined in `.env`.
The base python can be configured using `conda`, e.g.,
```bash
conda create --name py38 python=3.8
conda activate py38
```
If anything goes wrong, you can rebuild the `venv`,
```bash
make clean
make init
```
To check the `venv` is created correctly,
```bash
make test
```

### Step 3: Test the Beam pipeline using DirectRunner
`DirectRunner` provides the local way to validate whether your Beam pipeline works correctly,
```bash
make run-direct
```

### Step 4: Run the Beam pipeline using DataflowRunner
To run a Dataflow job using CPUs without a custom container, try this (took ~30m and cost ~1.4$):
```bash
make run-df-cpu
```

To speed up the Dataflow worker startup time, custom container can be built by,
```bash
make docker
```
The final docker image will be pushed to Artifact Registry. For this guide,
we use `tensor_rt.Dockerfile` to demonstrate how to build the container to run the inference on GPUs with TensorRT.

## Pipeline Details

## FAQ

### Permission error when using any GCP command
```bash
gcloud auth login
gcloud auth application-default login
# replace it with the appropriate region
gcloud auth configure-docker us-docker.pkg.dev
```
Make sure you specify the appropriate region for Artifact Registry.

### AttributeError: Can't get attribute 'default_tensor_inference_fn'
```
AttributeError: Can't get attribute 'default_tensor_inference_fn' on <module 'apache_beam.ml.inference.pytorch_inference' from '/usr/local/lib/python3.8/dist-packages/apache_beam/ml/inference/pytorch_inference.py'>
```
This error indicates your Dataflow job uses the old Beam SDK. If you use `--sdk_location container`, it means your Docker container has the old Beam SDK.

### QUOTA_EXCEEDED
```
Startup of the worker pool in zone us-central1-a failed to bring up any of the desired 1 workers. Please refer to https://cloud.google.com/dataflow/docs/guides/common-errors#worker-pool-failure for help troubleshooting. QUOTA_EXCEEDED: Instance 'benchmark-tests-pytorch-i-05041052-ufe3-harness-ww4n' creation failed: Quota 'NVIDIA_T4_GPUS' exceeded. Limit: 32.0 in region us-central1.
```
Please check https://cloud.google.com/compute/docs/regions-zones and select another zone with your desired machine type to relaunch the Dataflow job.

### ERROR: failed to solve: failed to fetch anonymous token: unexpected status: 401 Unauthorized
```
failed to solve with frontend dockerfile.v0: failed to create LLB definition: failed to authorize: rpc error: code = Unknown desc = failed to fetch anonymous token: unexpected status: 401 Unauthorized
```
Restarting the docker could resolve this issue.

## Useful Links
* https://cloud.google.com/dataflow/docs/guides/using-custom-containers#docker
* https://cloud.google.com/dataflow/docs/guides/using-gpus#building_a_custom_container_image
* https://beam.apache.org/documentation/sdks/python-pipeline-dependencies/
