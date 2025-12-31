# RabbitMQ 自定义镜像

基于官方 RabbitMQ 4.0 镜像，预装延迟消息交换插件。

## 预装插件

- `rabbitmq_delayed_message_exchange` - 延迟消息交换插件

## 项目结构

```
├── .github/workflows/
│   └── build.yml          # GitHub Actions 自动构建
├── Dockerfile              # 镜像定义
├── build.sh               # 构建脚本（本地）
├── push.sh                # 推送脚本（本地）
├── docker-compose.yml     # 本地开发用
└── docker-compose.prod.yml # 生产环境用（拉取远程镜像）
```

## 快速开始

### 本地开发

```bash
# 构建并启动
docker compose up -d --build

# 查看日志
docker compose logs -f

# 停止
docker compose down
```

访问管理界面：http://localhost:15672
- 用户名：admin
- 密码：admin

### 验证插件

```bash
docker exec rabbitmq rabbitmq-plugins list | grep delayed
```

输出 `[E*] rabbitmq_delayed_message_exchange` 表示插件已启用。

## 推送到阿里云 ACR

### 1. 准备工作

1. 登录 [阿里云容器镜像服务](https://cr.console.aliyun.com/)
2. 创建**个人实例**（免费）
3. 创建**命名空间**
4. 创建**镜像仓库**，选择"本地仓库"

### 2. 修改配置

编辑 `build.sh` 和 `push.sh`，替换以下变量：

```bash
REGISTRY="registry.cn-hangzhou.aliyuncs.com"  # 你的地域
NAMESPACE="your-namespace"                     # 你的命名空间
IMAGE_NAME="rabbitmq"                          # 镜像名称
VERSION="4.0-delayed"                          # 版本号
```

### 3. 构建镜像

```bash
./build.sh
```

### 4. 推送镜像

```bash
./push.sh
```

首次推送会提示登录，使用阿里云账号或在 ACR 控制台设置的固定密码。

## 生产环境部署

### 1. 登录镜像仓库

```bash
docker login registry.cn-hangzhou.aliyuncs.com
```

### 2. 修改配置

编辑 `docker-compose.prod.yml`，替换镜像地址：

```yaml
image: registry.cn-hangzhou.aliyuncs.com/your-namespace/rabbitmq:4.0-delayed
```

### 3. 启动服务

```bash
docker compose -f docker-compose.prod.yml up -d
```

## 阿里云地域列表

| 地域 | Registry 地址 |
|------|--------------|
| 杭州 | registry.cn-hangzhou.aliyuncs.com |
| 上海 | registry.cn-shanghai.aliyuncs.com |
| 北京 | registry.cn-beijing.aliyuncs.com |
| 深圳 | registry.cn-shenzhen.aliyuncs.com |
| 广州 | registry.cn-guangzhou.aliyuncs.com |
| 成都 | registry.cn-chengdu.aliyuncs.com |
| 香港 | registry.cn-hongkong.aliyuncs.com |

## GitHub Actions 自动构建

### 配置 Secrets

在 GitHub 仓库 Settings → Secrets and variables → Actions 中添加：

| Secret 名称 | 说明 | 示例 |
|------------|------|------|
| `ALIYUN_REGISTRY` | 阿里云 ACR 地址 | `registry.cn-hangzhou.aliyuncs.com` |
| `ALIYUN_NAMESPACE` | 命名空间 | `your-namespace` |
| `ALIYUN_USERNAME` | 登录用户名 | 阿里云账号或 RAM 用户 |
| `ALIYUN_PASSWORD` | 登录密码 | 在 ACR 控制台设置固定密码 |

### 触发方式

**方式一：推送 Tag 自动触发**

```bash
git tag v4.0-delayed
git push origin v4.0-delayed
```

**方式二：手动触发**

1. 进入 GitHub 仓库 → Actions → Build and Push RabbitMQ Image
2. 点击 "Run workflow"
3. 输入版本号，点击运行

### 构建结果

构建完成后，镜像会自动推送到阿里云 ACR：
- `registry.cn-xxx.aliyuncs.com/namespace/rabbitmq:版本号`
- `registry.cn-xxx.aliyuncs.com/namespace/rabbitmq:latest`

## 版本说明

| 组件 | 版本 |
|------|------|
| RabbitMQ | 4.0 |
| rabbitmq_delayed_message_exchange | 4.0.2 |

## 参考链接

- [RabbitMQ 官方镜像](https://hub.docker.com/_/rabbitmq)
- [延迟消息插件](https://github.com/rabbitmq/rabbitmq-delayed-message-exchange)
- [阿里云容器镜像服务](https://cr.console.aliyun.com/)
