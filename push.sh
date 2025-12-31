#!/bin/bash
set -e

# ========== 配置区域 ==========
REGISTRY="registry.cn-hangzhou.aliyuncs.com"
NAMESPACE="your-namespace"        # 替换为你的命名空间
IMAGE_NAME="rabbitmq"
VERSION="4.0-delayed"

# ========== 推送 ==========
FULL_IMAGE="${REGISTRY}/${NAMESPACE}/${IMAGE_NAME}"

echo ">>> 登录阿里云 ACR..."
docker login ${REGISTRY}

echo ">>> 推送镜像..."
docker push ${FULL_IMAGE}:${VERSION}
docker push ${FULL_IMAGE}:latest

echo ">>> 推送完成!"
echo "拉取命令: docker pull ${FULL_IMAGE}:${VERSION}"
