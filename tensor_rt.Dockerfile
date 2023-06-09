ARG PYTORCH_SERVING_BUILD_IMAGE=nvcr.io/nvidia/pytorch:22.11-py3

FROM ${PYTORCH_SERVING_BUILD_IMAGE}

ENV PATH="/usr/src/tensorrt/bin:${PATH}"

WORKDIR /workspace

COPY requirements.txt requirements.txt

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt install python${PYTHON_VERSION} python${PYTHON_VERSION}-venv python3-venv -y \
    && pip install --upgrade pip \
    && apt-get install ffmpeg libsm6 libxext6 -y --no-install-recommends \
    && pip install cuda-python onnx numpy onnxruntime common \
    && pip install git+https://github.com/facebookresearch/detectron2.git@5aeb252b194b93dc2879b4ac34bc51a31b5aee13 \
    && pip install git+https://github.com/NVIDIA/TensorRT#subdirectory=tools/onnx-graphsurgeon

RUN pip install --no-cache-dir -r requirements.txt && rm -f requirements.txt

# Copy files from official SDK image, including script/dependencies.
COPY --from=apache/beam_python${PYTHON_VERSION}_sdk:${BEAM_VERSION} /opt/apache/beam /opt/apache/beam

# Set the entrypoint to Apache Beam SDK launcher.
ENTRYPOINT ["/opt/apache/beam/boot"]