# Command Reference

用于记录人与 AI 协作中执行过的命令、场景背景、参数与结果含义，便于复盘与复用。

## 使用方式
- 每完成一个“场景”（例如：拉取依赖、构建、运行、调试、部署、SSH 运维、Docker 镜像构建/推送、数据库迁移等），请按以下模板追加一节。
- 将命令按执行顺序列出；为每条命令简述“为什么要执行”和“输出中关键字段的含义”。
- 为每个场景补充元信息标签：日期/环境（dev/test/staging/prod）/责任人/关联 PR 或 Issue。

---

## 记录：启用 CI 质量门禁（Gradle 矩阵）与修复 YAML 栅栏

### 元信息
- 日期：2025-09-03
- 环境（dev/test/staging/prod）：dev
- 责任人：pzone618
- 关联（PR/Issue）：待创建（分支 ci/quality-gates-gradle-matrix）

### 场景名称
- 目标/要解决的问题：移除 workflow 文件中的代码块栅栏，确保 GitHub Actions 识别为有效 YAML；补充 Gradle 矩阵与覆盖率阈值门禁的实际记录。
- 环境与前置条件：仓库已存在 `.github/workflows/quality-gates.yml`，当前在分支 `ci/quality-gates-gradle-matrix`。
- 成功判据（Success Criteria）：
  - 工作流文件无 YAML 错误；
  - detect 任务能输出四类矩阵（Python/Node/Maven/Gradle）；
  - PR 指向 main 时触发矩阵并按模块判定覆盖率≥80%。

### 命令清单（按顺序）
1. 命令：列出本地与远端分支
	- 背景/原因：确认特性分支是否已推送，准备开 PR
	- 关键参数：`git --no-pager branch -a`
	- 期望输出：出现 `ci/quality-gates-gradle-matrix`（本地与 remotes/origin）
	- 实际输出与解读：包含本地与远端同名分支，说明分支已推送成功

2. 命令：检查 GitHub CLI 是否可用
	- 背景/原因：后续用 gh 创建 PR
	- 关键参数：`gh --version`
	- 期望输出：版本号
	- 实际输出与解读：返回 2.74.0，CLI 可用

3. 命令：尝试读取仓库信息
	- 背景/原因：确认默认分支与仓库元信息
	- 关键参数：`gh repo view --json name,owner,defaultBranchRef`
	- 期望输出：仓库名称/Owner/默认分支
	- 实际输出与解读：提示 `gh auth login`，后续创建 PR 前需登录或设置 GH_TOKEN

### 补充
- 产物/副作用：已将 `quality-gates.yml` 中多余的 代码块栅栏 移除，工作流有效；
- 遇到问题与解决：GitHub CLI 未登录导致 `repo view` 命令失败，后续在本机执行 `gh auth login` 或配置 GH_TOKEN 后再创建 PR；
- 后续建议：合并至 main 后观察 Actions 运行结果与 README 徽章状态；如 Gradle 模块未启用 JaCoCo XML，请按 `docs/COMMAND_EXAMPLES.md` 示例修正。
## 模板（复制后填写）

### 元信息
- 日期：
- 环境（dev/test/staging/prod）：
- 责任人：
- 关联（PR/Issue）：

### 场景名称
- 目标/要解决的问题：
- 环境与前置条件：
- 成功判据（Success Criteria）：

### 命令清单（按顺序）
1. 命令：
	- 背景/原因：
	- 关键参数：
	- 期望输出：
	- 实际输出与解读：
2. 命令：
	- 背景/原因：
	- 关键参数：
	- 期望输出：
	- 实际输出与解读：

### 补充
- 产物/副作用：
- 遇到问题与解决：
- 后续建议：
示例条目已迁移至：`docs/COMMAND_EXAMPLES.md`

目的：保持本文件聚焦“真实执行记录”，示例集中维护，避免体积过大。

---

## 记录：导出 Manifest 与脚手架生成 + 运行单测

### 元信息
- 日期：2025-09-03
- 环境（dev/test/staging/prod）：dev
- 责任人：pzone618
- 关联（PR/Issue）：N/A

### 场景名称
- 目标/要解决的问题：从 `PROJECT_REQUIREMENTS.md` 导出包含 RTM/第13节的 Manifest（v2），使用生成器产出最小脚手架，并以 pytest 快速回归脚本改动。
- 环境与前置条件：已存在 Python 虚拟环境（.venv）；在仓库根目录执行；脚本位于 `scripts/`。
- 成功判据（Success Criteria）：
  - 生成 `build/project_manifest.json`（meta.version=2，含 requirements_list 与 rtm）。
  - 生成 `scaffold-out/REQUIREMENTS.md` 与 `.github/workflows/quality-gates.yml`。
  - `python -m pytest -q` 全部用例通过。

### 命令清单（按顺序）
1. 命令：导出 Manifest
	- 背景/原因：将需求文档结构化，供脚手架消费
	- 关键参数：无
	- 期望输出：打印 `Wrote build/project_manifest.json`
	- 实际输出与解读：生成文件，meta.version=2

	```bash
	python scripts/requirements_export.py
	```

2. 命令：从 Manifest 生成脚手架
	- 背景/原因：验证生成器可重建最小项目骨架
	- 关键参数：`--manifest build/project_manifest.json --out scaffold-out`
	- 期望输出：`scaffold-out/` 下存在 README.md、REQUIREMENTS.md、.github/workflows/quality-gates.yml
	- 实际输出与解读：文件生成成功，可进一步自定义 CI

	```bash
	python scripts/scaffold_from_manifest.py --manifest build/project_manifest.json --out scaffold-out
	ls -la scaffold-out
	```

3. 命令：运行单元测试
	- 背景/原因：验证导出与生成逻辑（解析/写出/最小结构）
	- 关键参数：`-q` 安静模式
	- 期望输出：测试全部通过
	- 实际输出与解读：若首次缺少 pytest，请先安装后重试

	```bash
	python -m pytest -q
	```

### 补充
- 产物/副作用：`build/project_manifest.json`；`scaffold-out/` 目录
- 遇到问题与解决：如提示缺少 pytest，执行 `python -m pip install pytest` 后重试
- 后续建议：在 CI 中加入本仓库脚本的单测与覆盖率门禁

---

## 示例条目（Java & Python 全栈常用场景）

### 场景：本地开发环境准备（Python）
- 目标/要解决的问题：为 Python 后端创建隔离环境并安装依赖
- 环境与前置条件：已安装 Python 3.10+；项目目录包含 `requirements.txt` 或 `pyproject.toml`
- 成功判据：能在虚拟环境中运行应用与测试
### 命令清单（按顺序）
1. 命令：创建虚拟环境
	- 背景/原因：隔离依赖，避免全局冲突
	```bash
	python3 -m venv .venv
	# 激活（macOS/Linux）
	source .venv/bin/activate
	# 升级 pip 并安装依赖
	pip install -U pip
	# 若存在 requirements.txt 则安装；否则按项目说明安装
	[ -f requirements.txt ] && pip install -r requirements.txt || true
	# 可选：运行快速自检
	pytest -q || true
	# 退出虚拟环境（可选）
	deactivate || true
	```

### 补充
- 产物/副作用：`target/*.jar`
- 遇到问题与解决：JDK 版本不匹配；代理问题导致依赖下载失败
- 后续建议：配置本地 maven 镜像以加速

---

### 场景：运行与调试后端（Python FastAPI 示例）
- 目标/要解决的问题：以开发模式启动并热重载
- 环境与前置条件：`uvicorn` 已安装，入口 `app.main:app`
- 成功判据：本地端口可访问；日志显示 Reloading

### 命令清单（按顺序）
1. 命令：启动服务（开发模式）
	- 背景/原因：本地调试
	- 关键参数：`--reload --port 8000`
	- 期望输出：监听 8000；自动重载
	- 实际输出与解读：导入错误表示依赖或路径问题

	```bash
	uvicorn app.main:app --reload --port 8000
	```

---

### 场景：运行与调试后端（Java Spring Boot 示例）
- 目标/要解决的问题：以本地 profile 启动调试
- 环境与前置条件：`application-local.yml` 已配置
- 成功判据：日志显示 `Started ... in X seconds`

### 命令清单（按顺序）
1. 命令：使用本地 profile 运行
	- 背景/原因：隔离开发配置
	- 关键参数：`--spring.profiles.active=local`
	- 期望输出：加载 local 配置
	- 实际输出与解读：配置缺失将报错

	```bash
	mvn spring-boot:run -Dspring-boot.run.profiles=local
	java -jar target/app.jar --spring.profiles.active=local
	```

### 场景：前端构建与本地运行（Node.js/Vite 示例）
- 环境与前置条件：Node.js 18+；`package.json` 存在
- 成功判据：本地端口可访问，HMR 生效

### 命令清单（按顺序）
1. 命令：安装依赖
	- 背景/原因：准备前端运行环境
	- 关键参数：无
	- 期望输出：`node_modules/` 生成
	- 实际输出与解读：网络错误或锁文件冲突需处理

	```bash
	npm ci
	```
2. 命令：启动开发服务器
	- 背景/原因：本地联调
	- 关键参数：`--host`
	- 期望输出：启动成功并可访问
	- 实际输出与解读：端口冲突需调整

	```bash
	npm run dev -- --host
	```

---

### 场景：单元测试与覆盖率（Python）
- 目标/要解决的问题：运行测试并生成覆盖率报告
- 环境与前置条件：已安装 `pytest` 与 `coverage`/`pytest-cov`
- 成功判据：覆盖率≥80%，报告生成

### 命令清单（按顺序）
1. 命令：执行测试并输出覆盖率
	- 背景/原因：验证质量门禁
	- 关键参数：`--cov=src --cov-report=term-missing`
	- 期望输出：覆盖率摘要
	- 实际输出与解读：缺少测试的模块需补测

	```bash
	pytest -q --maxfail=1 --disable-warnings --cov=src --cov-report=term-missing
	```

---

### 场景：单元测试与覆盖率（Java Maven + JaCoCo）
- 目标/要解决的问题：运行测试并生成覆盖率报告
- 环境与前置条件：`pom.xml` 配置 JaCoCo 插件
- 成功判据：`target/site/jacoco/index.html` 生成且覆盖率达标

### 命令清单（按顺序）
1. 命令：运行测试并生成报告
	- 背景/原因：验证质量门禁
	- 关键参数：无
	- 期望输出：测试通过，生成报告
	- 实际输出与解读：失败用例需修复

	```bash
	mvn -q clean test jacoco:report
	open target/site/jacoco/index.html
	```

---

### 场景：代码质量检查（Python：格式化/静态检查/类型）
- 目标/要解决的问题：统一格式并消除常见问题
- 环境与前置条件：已安装 `black`、`ruff`/`flake8`、`mypy`
- 成功判据：无错误，格式一致

### 命令清单（按顺序）
```bash
black .
ruff check . --fix
mypy src/
```

---

### 场景：代码质量检查（Java：Checkstyle/SpotBugs）
- 目标/要解决的问题：静态检查并修复缺陷
- 环境与前置条件：`pom.xml` 已配置相关插件
- 成功判据：无阻塞级别问题

### 命令清单（按顺序）
```bash
mvn -q checkstyle:check spotbugs:check
```

---

### 场景：使用 Docker 构建并运行（Python/Java）
- 目标/要解决的问题：容器化应用并本地验证
- 环境与前置条件：已安装 Docker；项目有 Dockerfile
- 成功判据：容器启动并可访问健康端点

### 命令清单（按顺序）
1. 构建镜像
	```bash
	docker build -t myapp:dev .
	docker images | grep myapp
	```
2. 运行容器（映射端口/传入环境变量）
	```bash
	docker run --rm -it -p 8080:8080 --env-file .env myapp:dev
	docker logs -f <container_id>
	```

### 补充
- 产物/副作用：本地镜像与容器
- 遇到问题与解决：端口冲突、镜像体积大
- 后续建议：多阶段构建、使用 `.dockerignore`

---

### 场景：Docker Compose（应用 + 数据库）
- 目标/要解决的问题：一键拉起应用与依赖数据库
- 环境与前置条件：`docker-compose.yml` 已配置
- 成功判据：服务全部 healthy

### 命令清单（按顺序）
```bash
docker compose up -d
docker compose ps
docker compose logs -f app
docker compose down
```

---

### 场景：Podman Compose（应用 + 数据库，禁用 Docker 场景）
- 目标/要解决的问题：在仅允许 Podman 的环境中，等价替代 Docker Compose 的一键编排。
- 环境与前置条件：已安装 Podman；优先使用 rootless；系统支持 `podman compose`（较新版本），否则使用 `podman-compose`（Python 工具）。
- 成功判据：服务全部 healthy，日志正常；无需特权。

### 命令清单（按顺序）
```bash
# 如支持 Podman 内置 compose 插件：
podman compose up -d
podman compose ps
podman compose logs -f app
podman compose down

# 若环境不支持内置 compose，使用 podman-compose（语法与 docker-compose 近似）：
# podman-compose up -d
# podman-compose ps
# podman-compose logs -f app
# podman-compose down
```

### 补充
- 默认 rootless 运行；避免 `--privileged`；挂载尽量只读（`-v host:ctr:ro`）。
- Compose 文件与 Docker 基本兼容；如使用 socket/特权能力，请改造为 rootless 可用的方案（如使用 `--userns keep-id`、只读卷、capabilities 最小化）。

---

### 场景：数据库迁移（Python Alembic / Django Migrations）
- 目标/要解决的问题：安全升级数据库结构
- 环境与前置条件：已配置连接串；迁移脚本存在
- 成功判据：迁移成功且无数据丢失

### 命令清单（按顺序）
```bash
alembic upgrade head
# 或 Django
python manage.py makemigrations
python manage.py migrate
```

---

### 场景：数据库迁移（Java Flyway/Liquibase）
- 目标/要解决的问题：在启动或独立模式下执行迁移
- 环境与前置条件：配置好 `spring.flyway.*` 或 Liquibase 配置
- 成功判据：迁移版本前进，无失败记录

### 命令清单（按顺序）
```bash
mvn -q -DskipTests package
java -jar target/app.jar --spring.profiles.active=prod
```

---

### 场景：部署到服务器（SSH + Systemd）
- 目标/要解决的问题：将构建产物部署至 Linux 服务器并以服务方式运行
- 环境与前置条件：可 SSH；服务器具备运行环境
- 成功判据：服务常驻并可健康访问

### 命令清单（按顺序）
```bash
ssh user@host
sudo cp app.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable --now app
sudo systemctl status app -l
journalctl -u app -f
```

---

### 场景：日志与排障（Linux / Docker）
- 目标/要解决的问题：快速定位问题
- 环境与前置条件：具备日志访问权限
- 成功判据：找到异常根因或可疑点

### 命令清单（按顺序）
```bash
ls -lah logs/
tail -n 200 -f logs/app.log
grep -R "ERROR" -n logs/
docker logs -f <container_id>
```

---

### 场景：文件与代码快速定位（find/grep）
- 目标/要解决的问题：快速查找文件与内容
- 环境与前置条件：Linux/Mac shell
- 成功判据：定位目标文件/文本

### 命令清单（按顺序）
```bash
find . -name "*.py" -or -name "*.java"
grep -R "TODO" -n src/
```

---

## 镜像构建优化（Java / Python）

### 场景：Docker 多阶段构建（Java Maven → 运行时 JRE）
- 目标/要解决的问题：缩小镜像体积，加速启动
- 环境与前置条件：有 `Dockerfile`
- 成功判据：生成小体积运行时镜像并可正常启动

### 命令清单（按顺序）
1. 构建并运行
	 ```bash
	 docker build -f Dockerfile -t my-java-app:prod .
	 docker run --rm -p 8080:8080 my-java-app:prod
	 ```

### 参考 Dockerfile 片段（示例）
```Dockerfile
FROM maven:3.9-eclipse-temurin-17 AS build
WORKDIR /app
COPY pom.xml .
RUN mvn -q -e -B -DskipTests dependency:go-offline
COPY src ./src
RUN mvn -q -e -B -DskipTests package

FROM eclipse-temurin:17-jre
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java","-jar","/app/app.jar"]
```

---

### 场景：使用 Jib 构建 Java 镜像（无 Dockerfile）
- 目标/要解决的问题：无需 Dockerfile/守护进程，直接用 Maven 构建镜像
- 环境与前置条件：`pom.xml` 配置了 `jib-maven-plugin`
- 成功判据：镜像构建并在本地或远端仓库可见

### 命令清单（按顺序）
```bash
mvn -q -DskipTests jib:dockerBuild -Dimage=my-java-app:jib
# 推送到远端（需登录 registry 且 pom 配置好目标）
mvn -q -DskipTests jib:build
docker run --rm -p 8080:8080 my-java-app:jib
```

---

### 场景：Python Slim 镜像 + 预构建 wheels 缓存
- 目标/要解决的问题：缩小镜像体积，加速安装
- 环境与前置条件：有 `Dockerfile`
- 成功判据：镜像体积明显下降，启动正常

### 命令清单（按顺序）
```bash
docker build -t my-py-app:slim .
docker run --rm -p 8000:8000 my-py-app:slim
```

### 参考 Dockerfile 片段（示例）
```Dockerfile
FROM python:3.11-slim AS base
ENV PIP_DISABLE_PIP_VERSION_CHECK=1 \
		PYTHONDONTWRITEBYTECODE=1 \
		PYTHONUNBUFFERED=1

FROM base AS builder
RUN apt-get update && apt-get install -y build-essential && rm -rf /var/lib/apt/lists/*
WORKDIR /wheels
COPY requirements.txt .
RUN pip wheel --no-cache-dir -r requirements.txt -w /wheels

FROM base AS runtime
WORKDIR /app
COPY --from=builder /wheels /wheels
RUN pip install --no-cache-dir --no-index --find-links=/wheels -r /wheels/requirements.txt || true
COPY . .
EXPOSE 8000
CMD ["python","-m","app"]
```

---

## Nginx 静态托管与反向代理

### 场景：Nginx 静态资源托管 + 后端反代（Docker 运行）
- 目标/要解决的问题：前后端一体化本地联调或部署
- 环境与前置条件：`dist/` 为前端构建产物；后端监听 `http://host.docker.internal:8080`
- 成功判据：静态资源可访问，API 通过 Nginx 反代成功

### 命令清单（按顺序）
```bash
docker run --name web -d -p 80:80 \
	-v $(pwd)/dist:/usr/share/nginx/html:ro \
	-v $(pwd)/nginx.conf:/etc/nginx/conf.d/default.conf:ro \
	nginx:alpine
docker logs -f web
curl -I http://127.0.0.1/
curl -i http://127.0.0.1/api/health
```

### 参考 nginx.conf（示例）
```nginx
server {
	listen 80;
	server_name _;
	root /usr/share/nginx/html;
	index index.html;

	location /api/ {
		proxy_pass http://host.docker.internal:8080/;
		proxy_set_header Host $host;
		proxy_set_header X-Real-IP $remote_addr;
	}

	location / {
		try_files $uri /index.html;
	}
}
```

---

## 记录：启用 Python 脚本 CI（pytest + 覆盖率≥80%）

### 元信息
- 日期：2025-09-03
- 环境（dev/test/staging/prod）：dev
- 责任人：pzone618
- 关联（PR/Issue）：`.github/workflows/scripts-ci.yml`

### 场景名称
- 目标/要解决的问题：为本仓库的 Python 脚本添加 CI，运行 pytest 并强制覆盖率≥80%，修复 YAML 中保留字 `on` 的引号问题。
- 环境与前置条件：已存在 `.venv`；测试位于 `tests/`；工作流文件 `scripts-ci.yml` 已提交到主分支。
- 成功判据（Success Criteria）：
  - 本地 `python -m pytest -q` 全部通过；
  - CI 工作流可运行并在覆盖率低于 80% 时失败；
  - YAML 通过语法校验（`on` 使用引号）。

### 命令清单（按顺序）
1. 命令：本地运行测试
	- 背景/原因：在提交前验证脚本与用例
	- 关键参数：`-q`
	- 期望输出：`5 passed`
	- 实际输出与解读：`5 passed in 0.01s`

    ```bash
    python -m pytest -q
    ```

2. 命令：提交并推送工作流（修复 `on` 引号）
	- 背景/原因：确保 Actions 正确解析工作流触发器
	- 关键参数：`on: "[push, pull_request]"` 或多行 YAML 中为 `"on":`
	- 期望输出：Actions 接受工作流，无 YAML 错误
	- 实际输出与解读：推送后工作流正常显示与运行

### 补充
- 产物/副作用：工作流产出 `coverage.xml` 工件；PR 上展示测试结果。
- 遇到问题与解决：若报 `pytest: command not found`，请在 CI 中安装依赖或使用虚拟环境解释器运行。
- 后续建议：将脚本 CI 覆盖率汇总到主质量门禁工作流的检测摘要中。

---

## CI/CD（GitHub Actions 常用 Job 模板）

### 场景：Java（Maven + 缓存 + 测试 + JaCoCo 报告）
- 目标/要解决的问题：CI 上快速构建与测试，产出覆盖率
- 环境与前置条件：GitHub 仓库；将 workflow 提交到 `.github/workflows/java-ci.yml`
- 成功判据：工作流成功，产出测试与覆盖率报告工件

### 命令清单（按顺序）
```bash
mkdir -p .github/workflows
cat > .github/workflows/java-ci.yml <<'YAML'
name: Java CI
on: [push, pull_request]
jobs:
	build:
		runs-on: ubuntu-latest
		steps:
			- uses: actions/checkout@v4
			- uses: actions/setup-java@v4
				with:
					distribution: 'temurin'
					java-version: '17'
					cache: 'maven'
			- run: mvn -q -B clean test jacoco:report
			- uses: actions/upload-artifact@v4
				with:
					name: jacoco-report
					path: target/site/jacoco
YAML
git add .github/workflows/java-ci.yml && git commit -m "ci(java): add Java CI with JaCoCo" || true
```

---

### 场景：Python（pip 缓存 + pytest + 覆盖率）
- 目标/要解决的问题：CI 上快速安装依赖、运行测试并上传覆盖率
- 环境与前置条件：GitHub 仓库；将 workflow 提交到 `.github/workflows/python-ci.yml`
- 成功判据：工作流成功，产出覆盖率摘要或工件

### 命令清单（按顺序）
```bash
mkdir -p .github/workflows
cat > .github/workflows/python-ci.yml <<'YAML'
name: Python CI
on: [push, pull_request]
jobs:
	test:
		runs-on: ubuntu-latest
		steps:
			- uses: actions/checkout@v4
			- uses: actions/setup-python@v5
				with:
					python-version: '3.11'
					cache: 'pip'
			- run: pip install -U pip && pip install -r requirements.txt
			- run: pytest -q --maxfail=1 --disable-warnings --cov=src --cov-report=xml
			- uses: actions/upload-artifact@v4
				with:
					name: coverage-xml
					path: coverage.xml
YAML
git add .github/workflows/python-ci.yml && git commit -m "ci(python): add Python CI with coverage" || true
```

---

### 场景：Docker Build & Push（多平台）
- 目标/要解决的问题：在 CI 上构建多平台镜像并推送
- 环境与前置条件：仓库已配置 registry 登录密钥（如 GHCR 或 Docker Hub）
- 成功判据：目标 registry 出现新镜像标签

### 命令清单（按顺序）
```bash
mkdir -p .github/workflows
cat > .github/workflows/docker-publish.yml <<'YAML'
name: Docker Publish
on:
	push:
		tags: ['v*.*.*']
jobs:
	build:
		runs-on: ubuntu-latest
		permissions:
			contents: read
			packages: write
		steps:
			- uses: actions/checkout@v4
			- uses: docker/setup-qemu-action@v3
			- uses: docker/setup-buildx-action@v3
			- uses: docker/login-action@v3
				with:
					registry: ghcr.io
					username: ${{ github.actor }}
					password: ${{ secrets.GITHUB_TOKEN }}
			- uses: docker/build-push-action@v6
				with:
					context: .
					push: true
					platforms: linux/amd64,linux/arm64
					tags: ghcr.io/${{ github.repository }}:latest
YAML
git add .github/workflows/docker-publish.yml && git commit -m "ci(docker): add multi-arch docker publish" || true
```

## 前端框架（React / Angular）

### 场景：React（Vite + React TS）项目创建与本地运行
- 目标/要解决的问题：创建 React+TS 项目并本地开发
- 环境与前置条件：Node.js 18+；网络可访问 npm registry
- 成功判据：开发服务器启动，浏览器可访问

### 命令清单（按顺序）
1. 命令：创建项目
	- 背景/原因：初始化项目骨架
	- 关键参数：`--template react-ts`
	- 期望输出：生成项目目录结构
	- 实际输出与解读：若网络失败可切换镜像
   
	```bash
	npm create vite@latest my-react-app -- --template react-ts
	cd my-react-app
	npm ci
	```
2. 命令：本地运行与生产构建
	- 背景/原因：验证开发与构建流程
	- 关键参数：`--host` 便于局域网访问
	- 期望输出：本地可访问；产出 `dist/`
	- 实际输出与解读：端口冲突需调整
   
	```bash
	npm run dev -- --host
	npm run build
	npm run preview -- --host
	```

### 补充
- 产物/副作用：`node_modules/`、`dist/`
- 遇到问题与解决：若 ESLint/TS 报错，按提示修复或调整配置

---

### 场景：Angular（Angular CLI）项目创建与本地运行
- 目标/要解决的问题：创建 Angular 项目并本地调试/构建
- 环境与前置条件：Node.js 18+；安装 `@angular/cli`
- 成功判据：`ng serve` 启动，`ng build` 产出 `dist/`

### 命令清单（按顺序）
1. 命令：安装 CLI 与初始化项目
	- 背景/原因：使用官方脚手架
	- 关键参数：`--routing --style=scss`
	- 期望输出：创建项目
	- 实际输出与解读：按需选择包管理器
   
	```bash
	npm i -g @angular/cli
	ng version
	ng new my-ng-app --routing --style=scss
	cd my-ng-app
	```
2. 命令：本地运行、测试与构建
	- 背景/原因：验证开发、测试、生产构建流程
	- 关键参数：`--host 0.0.0.0 --port 4200`
	- 期望输出：本地可访问；生成 `dist/`
	- 实际输出与解读：测试覆盖率可在 `coverage/` 查看
   
	```bash
	ng serve --host 0.0.0.0 --port 4200
	ng test --watch=false --code-coverage
	ng build --configuration production
	```

---

### 场景：前端质量（Lint/Format/Type Check）
- 目标/要解决的问题：统一代码风格与质量门禁
- 环境与前置条件：项目配置 eslint/prettier/tsc
- 成功判据：命令通过无阻塞问题

### 命令清单（按顺序）
```bash
npx eslint . --ext .ts,.tsx,.js,.jsx --fix
npx prettier . -w
npx tsc --noEmit
```

---

## 数据库（PostgreSQL / MySQL / MongoDB / Redis）

### 场景：PostgreSQL 本地容器与连接测试
- 目标/要解决的问题：快速拉起 Postgres 并验证连接
- 环境与前置条件：已安装 Docker；本地无端口冲突
- 成功判据：`psql` 连接成功并 `SELECT 1`

### 命令清单（按顺序）
```bash
docker run -d --name pg -e POSTGRES_PASSWORD=pass -e POSTGRES_DB=app -p 5432:5432 postgres:15
PGPASSWORD=pass psql -h 127.0.0.1 -U postgres -d app -c "SELECT 1;"
```

### 场景：PostgreSQL 备份与恢复
- 目标/要解决的问题：导出/导入数据库
- 环境与前置条件：具备网络与权限
- 成功判据：备份文件生成；恢复成功

### 命令清单（按顺序）
```bash
PGPASSWORD=pass pg_dump -h 127.0.0.1 -U postgres -d app -Fc -f backup.dump
PGPASSWORD=pass pg_restore -h 127.0.0.1 -U postgres -d app -c backup.dump
```

---

### 场景：MySQL 本地容器与连接测试
- 目标/要解决的问题：快速拉起 MySQL 并验证连接
- 环境与前置条件：已安装 Docker；本地无端口冲突
- 成功判据：`SELECT 1` 返回成功

### 命令清单（按顺序）
```bash
docker run -d --name mysql -e MYSQL_ROOT_PASSWORD=pass -e MYSQL_DATABASE=app -p 3306:3306 mysql:8
mysql -h 127.0.0.1 -uroot -ppass -D app -e "SELECT 1;"
```

### 场景：MySQL 备份与恢复
- 目标/要解决的问题：导出/导入数据库
- 环境与前置条件：具备网络与权限
- 成功判据：备份文件生成；恢复成功

### 命令清单（按顺序）
```bash
mysqldump -h 127.0.0.1 -uroot -ppass app > backup.sql
mysql -h 127.0.0.1 -uroot -ppass app < backup.sql
```

---

### 场景：MongoDB 本地容器与连接测试
- 目标/要解决的问题：快速拉起 Mongo 并验证连接
- 环境与前置条件：已安装 Docker；`mongosh` 可用
- 成功判据：`db.runCommand({ ping: 1 })` 返回 ok

### 命令清单（按顺序）
```bash
docker run -d --name mongo -p 27017:27017 mongo:6
mongosh "mongodb://127.0.0.1:27017" --eval 'db.runCommand({ ping: 1 })'
```

### 场景：MongoDB 备份与恢复
- 目标/要解决的问题：导出/导入数据
- 环境与前置条件：具备网络与权限
- 成功判据：dump 目录生成；恢复成功

### 命令清单（按顺序）
```bash
mongodump --uri "mongodb://127.0.0.1:27017/app" --out dump/
mongorestore --uri "mongodb://127.0.0.1:27017/app" dump/
```

---

### 场景：Redis 本地容器与连接测试
- 目标/要解决的问题：快速拉起 Redis 并验证连接
- 环境与前置条件：已安装 Docker；`redis-cli` 可用
- 成功判据：`PONG` 响应

### 命令清单（按顺序）
```bash
docker run -d --name redis -p 6379:6379 redis:7
redis-cli -h 127.0.0.1 -p 6379 ping
```

### 场景：Redis 持久化与备份（基础）
- 目标/要解决的问题：触发 RDB 保存并备份文件
- 环境与前置条件：容器可访问；具备权限
- 成功判据：`dump.rdb` 生成并完成备份

### 命令清单（按顺序）
```bash
redis-cli -h 127.0.0.1 -p 6379 save
docker cp redis:/data/dump.rdb ./dump.rdb
```


---

## HTTPS 与证书（Certbot/Nginx）运维

### 场景：Certbot 自动续期与 Nginx 热加载检查
- 目标/要解决的问题：验证证书自动续期是否按期执行，确保续期后 Nginx 平滑热加载
- 环境与前置条件：服务器基于 systemd 或 cron 调度 certbot；Nginx 已安装
- 成功判据：`certbot renew --dry-run` 通过；systemd/cron 定时任务存在；Nginx 配置校验通过并成功 reload

### 命令清单（按顺序）
```bash
# 1) 检查 systemd 计时器（如使用 systemd）
sudo systemctl list-timers | grep -i certbot || true
sudo systemctl status certbot.timer || true
sudo journalctl -u certbot -n 200 --no-pager || true

# 2) 若使用 cron，检查定时任务（常见于老环境）
crontab -l | grep -i certbot || true

# 3) 续期演练（不真正改动证书）
sudo certbot renew --dry-run

# 4) 查看证书清单与到期情况
sudo certbot certificates

# 5) 验证 Nginx 配置并平滑加载（证书续期后建议执行）
sudo nginx -t && sudo systemctl reload nginx
```

---

## 容器镜像推送（Docker Hub / Harbor）

### 场景：Docker Hub 登录、打标签与推送
- 目标/要解决的问题：将本地镜像发布到 Docker Hub 仓库
- 环境与前置条件：已拥有 Docker Hub 账号与访问令牌
- 成功判据：Docker Hub 对应仓库出现新标签

### 命令清单（按顺序）
```bash
# 登录（推荐使用 token）
echo "$DOCKERHUB_TOKEN" | docker login -u "$DOCKERHUB_USER" --password-stdin

# 设定变量并打标签
IMAGE=myapp
TAG=1.0.0
docker tag ${IMAGE}:prod ${DOCKERHUB_USER}/${IMAGE}:${TAG}

# 推送与校验
docker push ${DOCKERHUB_USER}/${IMAGE}:${TAG}
docker pull ${DOCKERHUB_USER}/${IMAGE}:${TAG}

# 退出登录（可选）
docker logout
```

### 场景：Harbor 登录、打标签与推送
- 目标/要解决的问题：将镜像推送至私有 Harbor 仓库
- 环境与前置条件：可访问的 Harbor 实例与项目/命名空间权限
- 成功判据：Harbor 项目中出现新镜像标签

### 命令清单（按顺序）
```bash
HARBOR=harbor.example.com
PROJECT=myproj
REPO=myapp
TAG=1.0.0

docker login ${HARBOR}
docker tag ${REPO}:prod ${HARBOR}/${PROJECT}/${REPO}:${TAG}
docker push ${HARBOR}/${PROJECT}/${REPO}:${TAG}

# 可选：如需 pull 验证
docker pull ${HARBOR}/${PROJECT}/${REPO}:${TAG}
```

---

## 发布策略（Nginx 蓝绿 / K8s 金丝雀）

### 场景：Nginx 蓝绿切换（同机双实例）
- 目标/要解决的问题：零停机在两套实例（blue/green）间切换流量
- 环境与前置条件：同一台服务器运行 2 套实例（示例端口 8081/8082）；Nginx 反代
- 成功判据：切换后业务不中断，错误率为 0，Nginx reload 成功

### 命令清单（按顺序）
```bash
# 1) 参考配置：为 blue / green 各自 upstream
cat | sudo tee /etc/nginx/conf.d/app.conf > /dev/null <<'NGINX'
upstream app_blue  { server 127.0.0.1:8081; }
upstream app_green { server 127.0.0.1:8082; }

server {
	listen 80;
	server_name _;
	location / {
		# 初始指向 blue，切换时把 app_blue 改为 app_green
		proxy_pass http://app_blue;
		proxy_set_header Host $host;
		proxy_set_header X-Real-IP $remote_addr;
	}
}
NGINX

# 2) 切换到 green（修改配置中的 upstream 名称）
sudo sed -i.bak 's/app_blue/app_green/g' /etc/nginx/conf.d/app.conf

# 3) 校验并热加载
sudo nginx -t && sudo systemctl reload nginx

# 4) 回滚（如需）
sudo sed -i.bak 's/app_green/app_blue/g' /etc/nginx/conf.d/app.conf
sudo nginx -t && sudo systemctl reload nginx
```

### 场景：Kubernetes NGINX Ingress 金丝雀发布（按权重/请求头/Cookie）
- 目标/要解决的问题：逐步引流至新版本，按权重或规则控制
- 环境与前置条件：使用 NGINX Ingress Controller，已部署 svc `web`（旧）与 `web-canary`（新）
- 成功判据：按策略分流成功，可动态调整并回滚

### 命令清单（按顺序）
```bash
# 1) 基础 Ingress（全部流量至旧版本）
cat > ingress.yaml <<'YAML'
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
	name: web
	annotations:
		kubernetes.io/ingress.class: nginx
spec:
	rules:
		- host: example.com
			http:
				paths:
					- path: /
						pathType: Prefix
						backend:
							service:
								name: web
								port:
									number: 80
YAML

# 2) 金丝雀 Ingress（按权重 20% 分流至新版本）
cat > ingress-canary.yaml <<'YAML'
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
	name: web-canary
	annotations:
		kubernetes.io/ingress.class: nginx
		nginx.ingress.kubernetes.io/canary: "true"
		nginx.ingress.kubernetes.io/canary-weight: "20"
spec:
	rules:
		- host: example.com
			http:
				paths:
					- path: /
						pathType: Prefix
						backend:
							service:
								name: web-canary
								port:
									number: 80
YAML

kubectl apply -f ingress.yaml
kubectl apply -f ingress-canary.yaml

# 3) 动态调节权重或按请求头/Cookie 精准引流
kubectl annotate ingress web-canary \
	nginx.ingress.kubernetes.io/canary-weight="50" --overwrite

# 按请求头：仅当 X-Canary=always 时走新版本
kubectl annotate ingress web-canary \
	nginx.ingress.kubernetes.io/canary-by-header="X-Canary" \
	nginx.ingress.kubernetes.io/canary-by-header-value="always" --overwrite

# 按 Cookie：当 Cookie 中有 canary=1 时走新版本
kubectl annotate ingress web-canary \
	nginx.ingress.kubernetes.io/canary-by-cookie="canary" --overwrite

# 4) 观测与回滚
kubectl describe ingress web-canary
kubectl annotate ingress web-canary nginx.ingress.kubernetes.io/canary-weight- --overwrite  # 清除权重
kubectl delete -f ingress-canary.yaml  # 完全回滚
```

---

### 场景：Podman kube play（本地运行 K8s 清单，禁用 Docker 场景）
- 目标/要解决的问题：在高安全主机上无需 Kubernetes 集群，也能以 Podman 按 K8s YAML 启动/下线一组容器。
- 环境与前置条件：已安装 Podman（rootless）；使用 `podman kube` 子命令；YAML 使用受支持的资源（Pod/Service 等）。
- 成功判据：容器按 YAML 启动，端口可访问；`podman kube down` 可平滑下线。

### 命令清单（按顺序）
```bash
# 1) 准备最小示例（Pod + hostPort 暴露 8080）
cat > kube.yaml <<'YAML'
apiVersion: v1
kind: Pod
metadata:
	name: web
	labels:
		app: web
spec:
	containers:
		- name: nginx
			image: nginx:1.25
			ports:
				- containerPort: 80
					hostPort: 8080
					protocol: TCP
YAML

# 2) 启动（rootless，避免特权）
podman kube play kube.yaml --replace

# 3) 验证
podman ps | grep nginx || true
curl -I http://127.0.0.1:8080/

# 4) 下线
podman kube down kube.yaml
```

### 补充
- 建议将镜像 pin 到 digest（`nginx@sha256:...`）；记录来源与哈希。
- 需要多容器/网络/卷时，先用 `podman generate kube` 导出 YAML 再按需调整，以提升兼容性。

---

## 场景：依赖离线下载与校验（Maven / pip / npm）

- 目标/要解决的问题：在网络不稳定时，采用“本地/缓存优先 → 私服/镜像 → 官方源 → 手动离线下载（校验）”的顺序，确保可重复与合规。
- 环境与前置条件：本地具备基本工具（mvn/pip/npm/curl/shasum）；如走离线，预留 artifacts 存储目录。
- 成功判据：离线包下载并校验通过；构建/安装成功；命令与校验值记录完整。

### 命令清单（按顺序）
1) Maven（优先 go-offline，其次手动安装 JAR）

```bash
# 预热依赖（网络可用时运行一次）
mvn -q -B -DskipTests dependency:go-offline

# 如网络不稳需手工下载某依赖（示例坐标）
GROUP=com.fasterxml.jackson.core
ARTIFACT=jackson-databind
VERSION=2.17.1
BASE=https://repo1.maven.org/maven2
PATH=${GROUP//.//}/${ARTIFACT}/${VERSION}
JAR=${ARTIFACT}-${VERSION}.jar

curl -L -o ${JAR} "${BASE}/${PATH}/${JAR}"
shasum -a 256 ${JAR} | tee ${JAR}.sha256

# 安装到本地仓（~/.m2/repository），便于离线构建
mvn -q install:install-file \
	-Dfile=${JAR} \
	-DgroupId=${GROUP} -DartifactId=${ARTIFACT} -Dversion=${VERSION} -Dpackaging=jar

# 离线构建
mvn -o -q -DskipTests package
```

2) pip（先下载 wheels 再离线安装）

```bash
# 下载依赖（根据项目的 requirements.txt）
mkdir -p wheels
python -m pip download -r requirements.txt -d wheels

# 完整性校验
shasum -a 256 wheels/* | tee wheels/checksums.sha256

# 离线安装（禁用外网索引）
python -m pip install --no-index --find-links=wheels -r requirements.txt
```

3) npm（缓存优先；必要时本地 tgz 安装）

```bash
# 锁文件在位时优先缓存 & 离线倾向
npm ci --prefer-offline --no-audit

# 无法联网时，先打包指定版本为 tgz（需能获取 tarball）
PKG=lodash
VER=4.17.21
npm pack ${PKG}@${VER}

# 本地安装打包产物（无需访问 registry）
npm i ./$(echo ${PKG}-*.tgz | head -n 1)
```

### 补充
- 记录：将下载来源链接与 SHA256 写入本节，便于审计与复现。
- 建议：在 CI 缓存依赖目录（pip/npm/maven/gradle），并把离线仓/镜像源信息写入 PR 描述。

---

## 场景：Docker 镜像复用与清理（查重/节省磁盘/离线）

- 目标/要解决的问题：先复用本地镜像，必要时再拉取；控制磁盘占用；支持离线导入导出。
- 环境与前置条件：已安装 Docker；具备基本磁盘空间管理权限。
- 成功判据：尽量复用现有镜像；磁盘占用可控；必要时可离线传输镜像。

### 命令清单（按顺序）
```bash
# 1) 检查可复用镜像（按名称/标签过滤）
docker image ls | grep -E "(nginx|ubuntu|myapp)" || true

# 查看镜像详情（含 digest/大小/创建时间）
IMG=nginx:1.25
docker inspect "$IMG" --format '{{.Id}} {{index .RepoTags 0}} {{index .RepoDigests 0}} {{.Size}}' || true

# 若需固定到 digest（提高一致性）
docker pull nginx@sha256:REPLACE_WITH_DIGEST  # 可由前一条 inspect 或官方公告获取

# 2) 无本地可复用时再拉取
docker pull ghcr.io/owner/repo:tag

# 3) 离线导出/导入（跨机器/无网场景）
docker save -o myapp.tar ghcr.io/owner/repo:tag
docker load -i myapp.tar

# 4) 磁盘占用盘点与清理
docker system df
docker image prune -f                       # 清理悬空镜像层
docker container prune -f                   # 清理已退出容器
# 如需更彻底（谨慎）：
# docker system prune -af --volumes

# 5) 构建时节省：开启 BuildKit & 复用缓存（CI 建议）
# export DOCKER_BUILDKIT=1
# docker build --cache-from=type=registry,ref=ghcr.io/owner/repo:cache \
#              --cache-to=type=registry,ref=ghcr.io/owner/repo:cache,mode=max \
#              -t ghcr.io/owner/repo:tag .
```

### 补充
- 优先使用 LTS/稳定标签并尽量 pin 到 digest；记录镜像来源。
- 定期审视 `docker system df`，在评估影响后执行清理，避免误删在用资源。

---

## 场景：Podman 镜像复用与清理（高安全/无 Docker 环境）

- 目标/要解决的问题：在禁用 Docker 的高安全环境下，用 Podman 实现与 Docker 等价的镜像复用、离线与清理策略。
- 环境与前置条件：已安装 Podman（rootless 模式）；具备基本磁盘空间管理权限。
- 成功判据：尽量复用现有镜像；磁盘占用可控；必要时可离线传输镜像；全程无特权。

### 命令清单（按顺序）
```bash
# 1) 检查可复用镜像
podman image ls | grep -E "(nginx|ubuntu|myapp)" || true

# 查看镜像详情（含 digest/大小/创建时间）
IMG=nginx:1.25
podman inspect "$IMG" --format '{{.Id}} {{(index .RepoTags 0)}} {{(index .RepoDigests 0)}} {{.Size}}' || true

# 若需固定到 digest（提高一致性）
podman pull nginx@sha256:REPLACE_WITH_DIGEST

# 2) 无本地可复用时再拉取
podman pull registry.example.com/owner/repo:tag

# 3) 离线导出/导入（跨机器/无网场景）
podman save -o myapp.tar registry.example.com/owner/repo:tag
podman load -i myapp.tar

# 4) 磁盘占用盘点与清理（rootless，无特权）
podman system df
podman image prune -f
podman container prune -f
# 如需更彻底（谨慎）
# podman system prune -af --volumes

# 5) 组合/编排（如可用）
# podman compose up -d
# podman compose down
```

### 补充
- 默认 rootless 运行；避免 `--privileged`；挂载尽量只读（`-v host:ctr:ro`）。
- 使用官方/LTS 镜像并 pin 到 digest；记录来源与哈希；按期 `podman system df` 评估并再清理。

