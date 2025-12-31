#!/bin/bash
set -e

# ========== 配置区域 ==========
# 阿里云 ACR 地址（根据你的地域修改）
REGISTRY="registry.cn-hangzhou.aliyuncs.com"
NAMESPACE="your-namespace"        # 替换为你的命名空间
IMAGE_NAME="rabbitmq"
VERSION="4.0-delayed"

# ========== 构建配置 ==========
FULL_IMAGE="${REGISTRY}/${NAMESPACE}/${IMAGE_NAME}"

echo ">>> 构建镜像..."
docker build -t ${FULL_IMAGE}:${VERSION} -t ${FULL_IMAGE}:latest .

echo ">>> 构建完成: ${FULL_IMAGE}:${VERSION}"
echo ""
echo "推送命令:"
echo "  docker login ${REGISTRY}"
echo "  docker push ${FULL_IMAGE}:${VERSION}"
echo "  docker push ${FULL_IMAGE}:latest"
