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

## 推送到 Docker Hub

### 本地构建和推送

1. **登录 Docker Hub**

```bash
docker login
```

输入你的 Docker Hub 用户名和密码。

2. **修改配置**

编辑 `build.sh` 和 `push.sh`，替换以下变量：

```bash
REGISTRY="docker.io"           # Docker Hub 地址
NAMESPACE="your-username"      # 你的 Docker Hub 用户名
IMAGE_NAME="rabbitmq"          # 镜像名称
VERSION="4.0-delayed"          # 版本号
```

3. **构建镜像**

```bash
./build.sh
```

4. **推送镜像**

```bash
./push.sh
```


## 生产环境部署

### 1. 拉取镜像

```bash
docker pull your-username/rabbitmq:4.0-delayed
```

### 2. 修改配置

编辑 `docker-compose.prod.yml`，替换镜像地址：

```yaml
image: your-username/rabbitmq:4.0-delayed
```

### 3. 启动服务

```bash
docker compose -f docker-compose.prod.yml up -d
```

## GitHub Actions 自动构建

### 配置 Secrets

在 GitHub 仓库 Settings → Secrets and variables → Actions 中添加：

| Secret 名称 | 说明 | 示例 |
|------------|------|------|
| `DOCKER_USERNAME` | Docker Hub 用户名 | `your-username` |
| `DOCKER_PASSWORD` | Docker Hub 访问令牌或密码 | 建议使用 [Access Token](https://hub.docker.com/settings/security) |

**推荐使用 Access Token 而不是密码：**

1. 登录 [Docker Hub](https://hub.docker.com/)
2. 进入 Account Settings → Security → Access Tokens
3. 点击 "New Access Token"
4. 输入描述（如 "GitHub Actions"），选择权限（读写）
5. 复制生成的 Token，添加到 GitHub Secrets 的 `DOCKER_PASSWORD`

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

构建完成后，镜像会自动推送到 Docker Hub：
- `your-username/rabbitmq:版本号`
- `your-username/rabbitmq:latest`

可以通过以下命令拉取：

```bash
docker pull your-username/rabbitmq:版本号
# 或
docker pull your-username/rabbitmq:latest
```

## 版本说明

| 组件 | 版本 |
|------|------|
| RabbitMQ | 4.0 |
| rabbitmq_delayed_message_exchange | 4.0.2 |

## 参考链接

- [RabbitMQ 官方镜像](https://hub.docker.com/_/rabbitmq)
- [延迟消息插件](https://github.com/rabbitmq/rabbitmq-delayed-message-exchange)
- [Docker Hub](https://hub.docker.com/)
