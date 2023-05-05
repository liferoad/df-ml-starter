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