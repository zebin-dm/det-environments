
# docker pull nvidia/cuda:11.7.1-cudnn8-devel-ubuntu20.04
PYTHON_VERSION="3.8.12"
UBUNTU_VERSION="ubuntu20.04"
MPI_BUILD_ARG="USE_GLOO=1"
VERSION=$(cat "./VERSION")
CUDA_VERSION="11.7.1"
DOCKERHUB_REGISTRY="zebincai"

docker build -f Dockerfile-base-gpu \
    --build-arg BASE_IMAGE="nvidia/cuda:${CUDA_VERSION}-cudnn8-devel-${UBUNTU_VERSION}" \
    --build-arg PYTHON_VERSION="${PYTHON_VERSION}" \
    --build-arg UBUNTU_VERSION="${UBUNTU_VERSION}" \
    --build-arg "${MPI_BUILD_ARG}" \
    -t ${DOCKERHUB_REGISTRY}/det-environments:py-${PYTHON_VERSION}-cuda-${CUDA_VERSION}-${VERSION} \
    .

TORCH_VERSION="2.0.0"
DEEPSPEED_VERSION="0.9.1"
docker build -f Dockerfile-default-gpu \
    --build-arg BASE_IMAGE=${DOCKERHUB_REGISTRY}/det-environments:py-${PYTHON_VERSION}-cuda-${CUDA_VERSION}-${VERSION} \
    --build-arg TORCH_VER="2.0.0" \
    --build-arg TORCH_TB_PROFILER_PIP="torch-tb-profiler" \
    --build-arg TORCH_CUDA_ARCH_LIST="6.0;6.1;6.2;7.0;7.5;8.0" \
    --build-arg DET_BUILD_NCCL="" \
    --build-arg DEEPSPEED_PIP="deepspeed==${DEEPSPEED_VERSION}" \
    -t ${DOCKERHUB_REGISTRY}/det-dev:torch-${TORCH_VERSION} \
    .
