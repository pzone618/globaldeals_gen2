# Global Deals Gen2

全栈电商系统 - 基于现代技术栈的可扩展解决方案

## 🏗️ 技术架构

### 后端技术栈
- **Spring Boot 3.5.5** - 企业级Java框架
- **Maven** - 依赖管理和构建工具
- **PostgreSQL 14** - 主数据库（端口5433）
- **Redis** - 缓存和会话存储
- **JWT** - 无状态身份认证
- **JPA/Hibernate** - ORM框架
- **Flyway** - 数据库版本控制
- **MapStruct** - Bean映射工具

### 前端技术栈
- **React 18+** - 现代UI框架
- **TypeScript** - 类型安全
- **React Router** - 路由管理
- **Axios** - HTTP客户端

### 基础设施
- **Podman** - 容器化部署（推荐）
- **Nginx** - 反向代理和负载均衡
- **JaCoCo** - 代码覆盖率分析

## 🚀 快速开始

### 前置要求
- **Java 17+**
- **Node.js 18+**
- **Podman** 及 **Compose**（Docker 作为备选方案）
- **Maven 3.9+**

### 📋 容器信息

本项目使用以下容器（详细信息见 `docs/CONTAINER_INVENTORY.md`）：
- PostgreSQL 15: `globaldeals-postgres-15` (端口 5433)
- Redis 6: `globaldeals-redis` (端口 6379)
- 后端应用: `globaldeals-backend` (端口 8080)
- 前端应用: `globaldeals-frontend` (端口 3000)

**快速查看状态**: `container-status.bat`

### 一键启动（推荐）

#### Windows
```cmd
start-dev.bat
```

#### Linux/macOS
```bash
./start-dev.sh
```

### 手动启动

#### 1. 启动数据服务

使用 Podman 启动 PostgreSQL 15 和 Redis 6 服务：

```bash
# PostgreSQL 15 (Red Hat 镜像)
podman run -d --name globaldeals-postgres-15 \
  -p 5433:5432 \
  -e POSTGRESQL_USER=globaldeals \
  -e POSTGRESQL_PASSWORD=dev123456 \
  -e POSTGRESQL_DATABASE=globaldeals_db \
  registry.redhat.io/rhel9/postgresql-15:latest

# Redis 6 (Red Hat 镜像)
podman run -d --name globaldeals-redis \
  -p 6379:6379 \
  -e REDIS_PASSWORD=dev123456 \
  registry.redhat.io/rhel8/redis-6:latest

# 查看服务状态
container-status.bat
```

**重要提醒**: 
- 使用 Red Hat 官方镜像解决 Docker Hub 网络问题
- 容器命名采用 `globaldeals-*` 前缀避免冲突
- 完整容器信息见 `docs/CONTAINER_INVENTORY.md`
#### 2. 启动后端服务

```bash
cd backend
mvn spring-boot:run
```

或直接运行JAR包：
```bash
cd backend
mvn clean package -DskipTests
java -jar target/globaldeals-backend-1.0.0.jar
```

#### 3. 启动前端服务

```bash
cd frontend
npm install
npm start
```

## 🌐 服务地址

| 服务 | 地址 | 说明 |
|------|------|------|
| 前端应用 | http://localhost:3000 | React开发服务器 |
| 后端API | http://localhost:8080/api | Spring Boot应用 |
| 数据库 | localhost:5433 | PostgreSQL (用户: globaldeals) |
| 缓存 | localhost:6379 | Redis (密码: dev123456) |

**凭据信息**: 详见 `docs/CONTAINER_INVENTORY.md`

## �️ 开发工具

### 容器管理
- `container-status.bat` - 查看所有容器状态和凭据
- `docs/CONTAINER_INVENTORY.md` - 完整容器清单
- `docs/DOCKER_PODMAN_STRATEGY.md` - 容器技术选择策略

### 测试
- 后端测试: `mvn test`
- 覆盖率报告: `mvn jacoco:report`
- 前端测试: `npm test`

### 数据库管理
- 连接信息: 见 `docs/CONTAINER_INVENTORY.md`
- 迁移: Flyway 自动执行
- 备份/恢复: `scripts/db-backup.sh`

## 📁 项目结构

```
globaldeals_gen2/
├── backend/                 # Spring Boot后端
│   ├── src/main/java/      # Java源码
│   │   └── com/globaldeals/backend/
│   │       ├── config/     # 配置类
│   │       ├── controller/ # REST控制器
│   │       ├── dto/        # 数据传输对象
│   │       ├── entity/     # JPA实体
│   │       ├── mapper/     # MapStruct映射器
│   │       ├── repository/ # 数据访问层
│   │       └── service/    # 业务逻辑层
│   ├── src/main/resources/ # 配置文件
│   │   ├── db/migration/   # Flyway迁移脚本
│   │   └── application.yml # 应用配置
│   └── pom.xml            # Maven配置
├── frontend/               # React前端
│   ├── src/
│   │   ├── components/    # 可复用组件
│   │   ├── contexts/      # React Context
│   │   ├── pages/         # 页面组件
│   │   └── services/      # API服务
│   └── package.json       # npm配置
├── docs/                   # 项目文档
│   ├── CONTAINER_INVENTORY.md    # 容器清单
│   ├── DOCKER_PODMAN_STRATEGY.md # 容器策略
│   └── COMMAND_EXAMPLES.md       # 命令示例
├── scripts/                # 自动化脚本
├── .github/               # GitHub配置
│   └── copilot-instructions.md  # AI助手规则
├── container-status.bat   # 容器状态检查工具
├── PROJECT_REQUIREMENTS.md # 项目需求文档
└── COMMAND_REFERENCE.md   # 命令参考
│   ├── nginx/             # Nginx配置
│   └── postgres/          # 数据库初始化
├── podman-compose.yml     # Podman编排（推荐）
├── docker-compose.yml      # Docker编排（备选）
├── podman-compose.yml      # Podman编排
└── docs/                   # 项目文档
```

## 🔐 认证系统

系统实现了基于JWT的认证机制：

### API端点
- `POST /api/auth/register` - 用户注册
- `POST /api/auth/login` - 用户登录
- `POST /api/auth/refresh` - 刷新令牌
- `GET /api/users/me` - 获取当前用户信息
- `GET /api/users/dashboard` - 受保护的仪表板

### 安全特性
- 密码BCrypt加密
- JWT访问令牌（24小时有效）
- JWT刷新令牌（7天有效）
- CORS跨域配置
- 输入验证和SQL注入防护

## 🐳 容器技术策略

### 主要技术: Podman (推荐)
- **优势**: Rootless、无守护进程、安全优先
- **使用场景**: 日常开发、生产部署

### 备选技术: Docker
- **使用条件**: 特定环境或集成需求
- **注意事项**: 需要守护进程权限

**严格分离**: 项目文档和脚本严格区分 Docker/Podman，禁止混用

## 🧪 测试

### 后端测试
```bash
cd backend
mvn test                    # 运行所有测试
mvn jacoco:report          # 生成覆盖率报告
```

### 前端测试
```bash
cd frontend
npm test                   # 运行测试
npm run test:coverage     # 生成覆盖率报告
```

### 集成测试
```bash
# 使用TestContainers进行集成测试
mvn verify
```

## 📊 监控和健康检查

### 应用监控
- Spring Boot Actuator端点：`http://localhost:8080/api/actuator`
- 健康检查：`http://localhost:8080/api/actuator/health`
- 指标收集：`http://localhost:8080/api/actuator/metrics`

### 容器健康检查
所有服务都配置了健康检查，确保服务正常运行。

## 🛠️ 开发工具

### 代码质量
- **JaCoCo** - Java代码覆盖率（目标≥80%）
- **ESLint** - JavaScript/TypeScript代码检查
- **Prettier** - 代码格式化

### 数据库管理
## 📊 监控和健康检查

### 应用健康检查
- Spring Boot Actuator: `http://localhost:8080/actuator/health`
- 容器状态检查: `container-status.bat`

### 关键指标
- **覆盖率要求**: ≥80%
- **构建时间**: <5分钟
- **启动时间**: <30秒

### 技术债务管理
- 定期重构消除代码异味
- 依赖版本管理（安全优先）
- 性能优化持续跟踪

## 🚀 部署

### 容器化部署
```bash
# 构建所有镜像
podman-compose build

# 生产环境部署
podman-compose -f podman-compose.yml up -d
```

### 环境变量
生产环境需要配置以下环境变量：
```bash
DB_USERNAME=your_db_user
DB_PASSWORD=your_db_password
JWT_SECRET=your_jwt_secret_key
REDIS_HOST=your_redis_host
CORS_ALLOWED_ORIGINS=https://yourdomain.com
```

## 📚 开发指南

### 后端开发
1. 遵循分层架构：Controller → Service → Repository → Entity
2. 使用MapStruct进行DTO映射
3. 编写单元测试和集成测试
4. 保持代码覆盖率≥80%

### 前端开发
1. 使用TypeScript严格模式
2. 组件化开发，保持组件纯净
3. 使用Context进行状态管理
4. 编写组件测试

### 数据库变更
1. 创建Flyway迁移脚本：`V{version}__{description}.sql`
2. 更新JPA实体
3. 测试迁移脚本

### 容器管理规范
1. **命名约定**: 所有容器名称使用 `globaldeals-*` 前缀
2. **凭据管理**: 开发环境凭据记录在 `docs/CONTAINER_INVENTORY.md`（避免 AI 重启服务时随机生成导致人工介入困难）
3. **技术分离**: 严格区分 Podman 和 Docker 使用场景
4. **状态监控**: 定期使用 `container-status.bat` 检查

## 🔧 故障排除

### 常见问题

**1. 数据库连接失败**
```bash
# 检查PostgreSQL是否运行
podman ps | grep globaldeals-postgres-15
# 检查端口是否正确（5433）
# 查看完整连接信息
container-status.bat
```

**2. 前端无法连接后端**
```bash
# 检查后端是否运行在8080端口
curl http://localhost:8080/actuator/health
```

**3. 容器启动失败**
```bash
# 查看容器日志
podman logs globaldeals-postgres-15
podman logs globaldeals-redis
```

**4. 端口冲突**
```bash
# 检查端口占用
netstat -an | findstr ":5433"
netstat -an | findstr ":6379"
```

### 容器疑难解答
1. **镜像拉取问题**: 使用 Red Hat 镜像源避免 Docker Hub 网络问题
2. **权限问题**: Podman rootless 模式避免权限冲突
3. **数据持久化**: 容器重启后数据丢失需要配置数据卷
4. **网络连接**: 确保容器间网络连通性

### 开发环境重置
```bash
# 停止并删除所有开发容器
podman stop globaldeals-postgres-15 globaldeals-redis
podman rm globaldeals-postgres-15 globaldeals-redis

# 重新启动（参考启动命令）
# 见"手动启动"章节
```
## 📖 相关文档

### 核心文档
- [项目需求文档](PROJECT_REQUIREMENTS.md) - 完整需求规格
- [命令参考手册](COMMAND_REFERENCE.md) - 常用命令速查
- [容器清单](docs/CONTAINER_INVENTORY.md) - 所有容器信息
- [AI 协作策略](docs/AI_COLLABORATION_STRATEGY.md) - AI 状态管理与话题切换
- [新话题启动指南](docs/NEW_TOPIC_STARTER.md) - 新窗口快速上下文加载
- [项目状态快照](docs/PROJECT_STATUS_SNAPSHOT.md) - 当前完整状态记录

### 技术文档
- [容器技术策略](docs/DOCKER_PODMAN_STRATEGY.md) - Docker/Podman 选择指南
- [命令示例](docs/COMMAND_EXAMPLES.md) - 实际操作示例
- [环境配置](docs/envs/README.md) - 环境搭建详解

### 开发工具
- `container-status.bat` - 容器状态检查工具
- `.github/copilot-instructions.md` - AI 助手协作规则

## 🤝 贡献指南

### 代码贡献流程
1. Fork 项目到个人仓库
2. 创建功能分支: `git checkout -b feature/your-feature`
3. 提交更改: `git commit -m 'Add some feature'`
4. 推送分支: `git push origin feature/your-feature`
5. 创建 Pull Request

### 开发规范
- 遵循现有代码风格
- 编写单元测试（覆盖率≥80%）
- 更新相关文档
- 容器变更需更新 `docs/CONTAINER_INVENTORY.md`

### 容器管理贡献
- 新增容器必须使用 `globaldeals-*` 命名
- 更新 `docs/CONTAINER_INVENTORY.md` 记录所有信息
- 区分 Podman/Docker 使用场景
## 📄 许可证

本项目采用MIT许可证 - 查看[LICENSE](LICENSE)文件了解详情。

## 👥 开发团队

- **Tech Lead** - 架构设计和技术决策
- **Full Stack Developer** - 全栈开发
- **DevOps Engineer** - 容器化和部署

## 🚨 重要提醒

### 容器管理要求
- ✅ **使用 Red Hat 镜像源**（避免 Docker Hub 网络问题）
- ✅ **严格 Podman/Docker 分离**（禁止混用）
- ✅ **统一命名前缀** `globaldeals-*`（避免冲突）
- ✅ **维护容器清单** `docs/CONTAINER_INVENTORY.md`（记录所有信息）

### 开发准则
- 📋 **代码覆盖率** ≥80%
- 🔒 **安全优先** - 凭据管理和输入验证
- 📚 **文档同步** - 代码变更同步更新文档
- 🧪 **测试驱动** - 先写测试再写功能

---

🌟 **Star** 这个项目如果它对你有帮助！

📞 **问题反馈**: 创建 [Issue](../../issues) 或联系开发团队