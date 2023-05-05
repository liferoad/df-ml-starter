# df-ml-starter

## Prerequisites

* conda
* make
* docker
* gcloud

## Directory structure
TO-Do

## User Guide

* copy .env.template to .env and update settings

## FAQ

### Permission error when using any GCP command
```bash
gcloud auth login
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
