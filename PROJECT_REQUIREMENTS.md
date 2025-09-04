# Project Requirements

本文件定义项目的目标、范围、质量门槛与工作流要求，作为执行与验收的依据。

## 1. 项目基础信息
- **项目名称**: GlobalDeals Gen2 - 全栈电商系统
- **技术栈**: Spring Boot 3.5.5 + Java 17 + React 18 + PostgreSQL 15 + Redis 6
- **容器技术**: Podman（主要）/ Docker（备选），使用 Red Hat 镜像源
- **命名约定**: 所有容器使用 `globaldeals-*` 前缀
- **开发环境凭据**（必须固定，避免 AI 随机生成）：
  - PostgreSQL: `globaldeals_user/globaldeals_password/globaldeals`
  - Redis: `dev123456`

## 2. 全栈工程架构要求
### 工程建立优先级
**后端 → 容器服务 → 前端 → 集成**，确保基础设施稳定后再构建上层应用

### 后端工程规范
- **生成方式**: 使用 Spring Initializr (https://start.spring.io/) 生成 Spring Boot 3.5.5 + Java 17 项目
- **必需依赖**: Spring Web, Spring Data JPA, Spring Security, PostgreSQL Driver, Redis, Flyway, Actuator
- **目录结构**: `backend/src/main/java/com/globaldeals/backend/`
- **配置文件**: 
  - `application.yml` (通用配置)
  - `application-postgres15.yml` (PostgreSQL 15 特定配置)

### 前端工程规范
- **生成方式**: 使用 React 官方推荐的 `npx create-react-app globaldeals-frontend --template typescript`
- **必需依赖**: React 18+, TypeScript, React Router, Axios, 测试框架
- **目录结构**: `frontend/src/` (components, pages, services, contexts, utils)
- **配置文件**: 
  - `.env` (REACT_APP_API_URL)
  - `tsconfig.json` (严格模式)
  - `package.json` (脚本和依赖)
- **开发服务器**: 端口 3000，代理 API 请求到后端

### 容器服务规范
- **PostgreSQL 15**: 
  - 镜像: `registry.redhat.io/rhel9/postgresql-15:latest`
  - 容器名: `globaldeals-postgres-15`
  - 端口: `5433:5432`
- **Redis 6**: 
  - 镜像: `registry.redhat.io/rhel8/redis-6:latest`
  - 容器名: `globaldeals-redis`
  - 端口: `6379:6379`
- **凭据记录**: 必须在 `docs/CONTAINER_INVENTORY.md` 中记录所有用户名、密码、环境变量

### 集成配置要求
- **后端配置**: `application-postgres15.yml` (数据库和 Redis 连接)
- **前端代理**: 开发环境通过 webpack dev server 代理到后端 API
- **CORS 配置**: 后端允许前端域名访问
- **API 基础路径**: `/api` (后端上下文路径)

### 质量门槛
- **代码覆盖率**: 后端 ≥ 80%，前端 ≥ 80%
- **类型安全**: TypeScript 严格模式，Java 强类型
- **测试策略**: 单元测试 + 集成测试，覆盖主流程和边界场景
- **构建要求**: 无 lint 错误，无 TypeScript 编译错误

## 3. 目标与范围
- 目标：
	- 建立统一的工程协作规则（代码生成、流程、测试、安全、提交信息）。
	- 提供标准化的命令记录方式与高频场景示例，支撑开发/运维复用。
- 范围：
	- 规则与模板文档：统一在仓库维护并持续改进。
	- CI/CD 与质量门禁：以最小可行实现上线并逐步强化。
- 非目标（本阶段不做）：
	- 与具体业务系统深度绑定的实现细节。
	- 复杂平台化/门户站式工具（后续按需求评估）。

## 2. 成功判据（验收标准）
- 工程规则清晰可执行，冲突项已消解（MVP 先计划、DRY 优先、覆盖率优先等）。
- 新增功能均配套测试（成功路径 + 边界/错误），整体覆盖率≥80%。
- 关键流程在 `COMMAND_REFERENCE.md` 留痕，包含命令、原因与输出解读。
- 提交信息规范，易读且指向具体变更（如：`feat(auth): add refreshToken API with error handling`）。

## 3. 约束与原则
- 官方文档优先：严禁编造 API/配置；来源仅限项目、依赖与规则文件。
- 先计划后实现：先列函数签名/文件路径/测试点，再产出 MVP。
- DRY：优先复用已有代码/工具；避免重复实现。
- 安全：不输出敏感信息；外部请求设置超时并捕获异常；错误信息不泄露内部细节。
- 风格：通过 Lint/格式化检查；TS/Java 严格类型；目录结构符合约定。

## 4. 交付物
- 规则文档：
	- `COMMAND_REFERENCE.md`（命令记录与高频示例）
	- `.github/copilot-instructions.md`（Copilot 行为规则）
	- `docs/AI_COLLABORATION_STRATEGY.md`（AI 状态管理与话题切换策略）
	- `docs/NEW_TOPIC_STARTER.md`（新话题快速启动模板）
	- `docs/PROJECT_STATUS_SNAPSHOT.md`（项目状态快照，支持无缝话题切换）
- 容器清单：
	- `docs/CONTAINER_INVENTORY.md`（镜像名称、容器名称、端口映射、凭据信息）
	- 强制包含：项目前缀命名、环境变量、启动/清理命令
- 测试：`tests/` 下的单元/集成测试，覆盖主流程与边界场景。
- CI：基础工作流（构建、测试、覆盖率、镜像发布），可最小集成后演进。
- 运维：Nginx/Cerbot、Podman/Compose、蓝绿/金丝雀发布示例（Docker 作为备选方案）。

## 5. 工作流（6A）
1) Accept：澄清需求与约束；记录假设。
2) Analyze：梳理结构与依赖；识别复用点（DRY）。
3) Approach：方案与取舍；风控与回滚策略。
4) Action：先计划后实现 MVP；小步提交；关键命令留痕。
5) Assess：代码审查、测试与性能评估；质量门禁过关。
6) Adjust：根据反馈优化并形成改进项。

> TRAE 6A 兼容模式（不新增目录的最小实践）：
> - 对齐/澄清：遇到歧义必须中断并提问，先写清第13/14节内容再编码；关键假设在 PR 中明示。
> - 先设计后编码：将分层/模块边界与依赖方向写入本文件的“分层与模块边界”要点（位于分层章节的执行清单中）。
> - 原子化任务：按“输入/输出契约、验收标准”拆分，测试点映射到第16节 RTM；覆盖率≥80% 作为闸门。
> - 审批闸门：以 PR 模板清单（稳定/LTS、分层、覆盖率、回滚）作为合入条件；不达标不合并。
> - 自动化与留痕：执行命令记录至 `COMMAND_REFERENCE.md`；异常与回滚亦需记录。

## 6. 质量门禁（Quality Gates）
- Build：构建通过无阻塞错误。
- Lint/Typecheck：无错误或已豁免且留痕。
- Test：覆盖率≥80%，至少 2 种路径（成功 + 边界/错误）。
- Smoke：基础可运行验证（本地/容器/环境）。

## 7. 安全与合规
- 不记录/输出敏感信息（密码、token、个人隐私）。
- 网络请求设定超时与异常处理；日志不泄露内部实现细节。
- 依赖与镜像版本定期审计与更新（低风险优先）。

## 8. 文档与命令留痕
- 所有重要场景在 `COMMAND_REFERENCE.md` 追加记录：
	- 目标、前置条件、成功判据。
	- 命令、原因、关键参数、期望输出、实际输出与解读。
	- 异常与解决方案。

## 9. 提交与版本
- 提交信息规范：`type(scope): summary`，指向具体变更。
- 常用类型：feat/fix/docs/chore/refactor/test/ci.
- 小步提交，避免混合无关改动；必要时附带迁移/回滚说明。

## 10. 环境与工具前置
- 语言/运行时：Node 18+、Python 3.10+、JDK 21+（视项目而定）。
- 基础工具：Git、Podman/Compose、Make（可选），Docker 作为备选方案。
- 质量工具：ESLint/Prettier、Black/Ruff/MyPy、Checkstyle/SpotBugs、pytest/JaCoCo。

## 11. 风险与回滚
- 风险：规则落地不一致、覆盖率下降、镜像不可用、证书续期失败。
- 缓解：
	- 引入 CI 门禁与模板；
	- 保持蓝绿/金丝雀发布示例；
	- `certbot renew --dry-run` 与 Nginx 热加载校验；
	- 镜像多阶段构建与 Jib 备选；
	- 关键命令留痕便于快速复盘与回滚。

## 12. 变更管理
- 所有规则与模板变更通过 PR 讨论与审阅；
- 在 PR 描述中标注影响范围与迁移指南；
- 合并后更新 `COMMAND_REFERENCE.md` 示例（如涉及命令/流程变化）。

> 自动化更新（Requirements Bot）
- 支持在 Issue/PR 评论中使用命令更新“第14节 需求清单（样表）”。
- 用法：在评论中输入如下指令（字段可按需省略）：

	/req upsert REQ-123 title="你的需求标题" priority=P1 owner="OwnerName" status="In progress"

- 机器人会自动将/更新该需求行至“需求清单”表格（第14节）。
- 注意：命令仅更新清单，不会自动填写第13节的完整需求模板，请仍以模板撰写完整需求并在第16节 RTM 关联追踪。
	- 必填：title、priority；缺失时机器人会在评论中回帖提示缺漏字段与示例。

- 更新 RTM（第16节）示例：

	/req rtm REQ-123 design="README.md#方案" pr=PR-123 tests="tests/..." coverage="85%" deploy="Release-2025-09-10" rollback="已演练"
	- 至少提供一个字段（design/pr/tests/coverage/deploy/rollback）；否则会回帖提示需要提供的字段之一。

- 修改清单字段（第14节）示例：

	/req set REQ-123 title="更新后的标题" priority=P2 owner="New Owner" status="Done"
	- 至少提供一个字段（title/priority/owner/status）；若不存在该需求，请先使用 upsert 创建。

## 13. 需求登记模板（用于记录工程需求）
- 需求 ID（唯一）：
- 标题/名称：
- 背景与动机：
- 详细描述（用户故事/场景/约束）：
- 优先级（MoSCoW 或 P0/1/2）：
- 验收标准（可量化）：
- 依赖与外部接口：
- 风险与回滚策略：
- 安全/合规影响（数据、权限、日志）：
- 非功能性指标（性能/可用性/容量/延迟）：
- 变更影响面（代码/配置/数据/部署）：
- 责任人/协作人：
- 计划里程碑/截止时间：
- 关联（Issue/PR/设计文档/命令记录链接）：
- 状态（Draft/In progress/Blocked/Done）：

### 需求登记：REQ-002 — Monorepo 质量门禁增强（多模块覆盖率与矩阵）
- 需求 ID（唯一）：REQ-002
- 标题/名称：Monorepo 质量门禁增强（多模块覆盖率与矩阵）
- 背景与动机：当前质量门禁对单项目有效；随着仓库演进为多模块/Monorepo，需要按模块检测语言与运行任务，并对每个模块独立计算与阻断覆盖率，避免单模块"吃掉"其他模块的失败。
- 详细描述（用户故事/场景/约束）：
	- 在 `.github/workflows/quality-gates.yml` 中增加模块发现逻辑（Python/Node/Java：Maven/Gradle），基于路径策略生成矩阵；每个模块运行对应的 Lint/类型检查与测试，产出覆盖率报告。
	- 聚合与判定：对每个模块单独判定覆盖率阈值（≥80%）；任何模块低于阈值即失败，并在总结输出中标明模块名称与覆盖率。
	- 兼容：保持对纯单模块仓库的零配置兼容；在未检测到多模块时退化为单任务。
	- 文档：在 `README.md` 增加 Monorepo 支持说明与常见布局示例；在 `docs/COMMAND_EXAMPLES.md` 增补 CI 片段示例与 Gradle JaCoCo 配置片段。
- 优先级（MoSCoW 或 P0/1/2）：P1
- 验收标准（可量化）：
	- 工作流能根据多模块布局生成矩阵执行（至少 Python + Node + Java Maven/Gradle 示例布局验证）
	- 每模块独立输出覆盖率并执行阈值判定（≥80%），低于阈值的模块在摘要中清晰标识
	- 单模块仓库行为不变；文档更新并在 PR 模板中覆盖相关勾选项
- 依赖与外部接口：GitHub Actions、pytest/coverage、JaCoCo、nyc/ts-jest 等覆盖率工具
- 风险与回滚策略：模块发现误判导致漏检或误阻断；可通过开关变量回退至当前单任务模式，并保留原版工作流片段以快速回滚
- 安全/合规影响（数据、权限、日志）：无敏感数据；日志不含令牌与机密
- 非功能性指标（性能/可用性/容量/延迟）：CI 总时长控制在基线×1.5 以内；矩阵并发不阻塞队列
- 变更影响面（代码/配置/数据/部署）：CI 工作流、README、命令示例文档、PR 模板
- 责任人/协作人：Repo Maintainer / Contributors
- 计划里程碑/截止时间：2025-09-15
- 关联（Issue/PR/设计文档/命令记录链接）：Issue-TBD、分支 ci/quality-gates-gradle-matrix（PR 待创建）、docs/COMMAND_EXAMPLES.md#ci-质量门禁
- 状态（Draft/In progress/Blocked/Done）：In progress

### 需求登记：REQ-003 — 全栈系统架构建立（Spring Boot + React + PostgreSQL + Podman）
- 需求 ID（唯一）：REQ-003
- 标题/名称：全栈系统架构建立（Spring Boot + React + PostgreSQL + Podman）
- 背景与动机：基于现有规则项目，建立一个可生产使用的全栈系统架构，支持业务快速开发和部署
- 详细描述（用户故事/场景/约束）：
	- 后端：Spring Boot 3.5.5 + Maven + JDK 21 + JPA + JWT认证 + MapStruct映射 + Flyway数据库迁移 + Redis缓存
	- 前端：React 18+ 官方脚手架，TypeScript严格模式，与后端API集成
	- 数据库：PostgreSQL 15 (Red Hat)，端口5433，包含数据库迁移脚本
	- 容器化：Podman容器编排，多阶段构建优化，开发/生产环境分离
	- **镜像策略**：优先使用 Red Hat 企业镜像 (registry.redhat.io)，避免 Docker Hub 网络问题
		- PostgreSQL: registry.redhat.io/rhel9/postgresql-15:latest  
		- Redis: registry.redhat.io/rhel8/redis-6:latest
		- 环境变量: Red Hat 镜像使用 POSTGRESQL_*, REDIS_PASSWORD (必须)
	- **容器命名**：使用项目前缀 `globaldeals-*` 避免与其他项目冲突
		- PostgreSQL: globaldeals-postgres-15 (端口 5433)
		- Redis: globaldeals-redis (端口 6379)
		- 后端: globaldeals-backend (端口 8080)
		- 前端: globaldeals-frontend (端口 3000)
	- **凭据管理**：开发环境凭据清晰记录（避免 AI 重启服务时随机生成导致人工介入困难），生产环境使用环境变量注入
	- 代理：Nginx反向代理，静态资源服务，SSL终端
	- 安全：JWT令牌管理，输入校验，SQL注入防护，敏感信息加密
	- 分层架构：Controller → Service → Repository → Entity，依赖单向，便于测试
- 优先级（MoSCoW 或 P0/1/2）：P0
- 验收标准（可量化）：
	- 后端能正常启动并通过健康检查，覆盖率≥80%
	- 前端能正常构建并展示登录/主页面，TypeScript无错误
	- 数据库连接正常，Flyway迁移执行成功
	- **容器清单完整**：`docs/CONTAINER_INVENTORY.md` 包含所有镜像名称、容器名称、端口映射、凭据信息
	- Podman compose能一键启动完整环境（backend + frontend + db + redis + nginx）
	- 用户能完成注册/登录/访问受保护资源的端到端流程
	- 所有密钥通过环境变量注入，日志不包含敏感信息
- 依赖与外部接口：Spring Initializr、React官方CLI、PostgreSQL、Redis、Podman、Nginx
- 风险与回滚策略：组件启动失败时有明确错误提示和回滚步骤；保留 Docker Compose 作为备选方案
- 安全/合规影响（数据、权限、日志）：JWT密钥轮换机制，密码哈希存储，审计日志记录用户操作，CORS配置
- 非功能性指标（性能/可用性/容量/延迟）：API响应时间<200ms，数据库连接池10-50，Redis键TTL设置，支持500并发用户
- 变更影响面（代码/配置/数据/部署）：新增backend/、frontend/目录，podman-compose.yml、nginx配置、数据库迁移脚本
- 责任人/协作人：Tech Lead / Full Stack Developer
- 计划里程碑/截止时间：2025-09-15
- 关联（Issue/PR/设计文档/命令记录链接）：本PR、COMMAND_REFERENCE.md#全栈环境搭建、docs/ARCHITECTURE.md
- 状态（Draft/In progress/Blocked/Done）：In progress

## 14. 需求清单（样表）
| 需求ID | 标题 | 优先级 | 负责人 | 状态 | 验收标准（摘要） | 依赖 | 回滚策略 |
| --- | --- | --- | --- | --- | --- | --- | --- |
| REQ-001 | | P0 | | Draft | | | |
| REQ-002 | Monorepo 质量门禁增强（多模块覆盖率与矩阵） | P1 | Repo Maintainer | In progress | 每模块覆盖率≥80%，矩阵执行与单模块兼容（含 Java Maven/Gradle） | GH Actions 与覆盖率工具 | 一键回退至单任务工作流 |
| REQ-003 | 全栈系统架构建立（Spring Boot + React + PostgreSQL + Podman） | P0 | Tech Lead | In progress | 端到端用户流程可用，后端/前端覆盖率≥80%，Podman一键部署 | Spring Initializr、React CLI、PostgreSQL、Podman | Docker Compose备选，组件级回滚 |

## 15. 非功能性需求（NFR）清单
- 性能：
	- 峰值 QPS/并发、P95/P99 延迟、批处理 SLA
- 可用性与恢复：
	- 目标可用性（如 99.9%）、RTO/RPO、降级与熔断策略
- 安全与隐私：
	- 访问控制、最小权限、脱敏/加密、审计日志、依赖漏洞
- 可扩展性与容量：
	- 水平/垂直扩展策略、容量预估与上限告警
- 可维护性与可观测性：
	- 日志/指标/追踪、告警规则、SLO/SLI、运行手册
- 合规与地域：
	- 数据驻留、合规标准（如 GDPR）、跨境、地域容灾

## 16. 需求追踪矩阵（RTM）
| 需求ID | 设计/文档 | 代码变更（PR） | 测试用例 | 覆盖率 | 部署记录 | 回滚演练 |
| --- | --- | --- | --- | --- | --- | --- |
| REQ-001 | | | tests/test_x.py::TestX | 85% | Release-2025-09-10 | 演练通过 |
| REQ-002 | README.md#质量门禁与Monorepo、docs/COMMAND_EXAMPLES.md#ci-质量门禁 | 分支 ci/quality-gates-gradle-matrix（PR-TBD） | workflow 矩阵干跑与路径匹配验证（act 或分支验证） | 每模块≥80%（阈值判定，含 Gradle） | 启用 quality-gates 工作流 v2（日期TBD） | 已验证单任务回退路径 |
| REQ-003 | docs/ARCHITECTURE.md、README.md#全栈架构 | 本PR（全栈工程搭建） | backend/src/test/**、frontend/src/**/*.test.ts | 后端≥80%、前端≥80% | Podman compose部署演练（2025-09-15） | Docker Compose备选验证 |

## 17. 需求变更记录（Changelog）
| 日期 | 需求ID | 变更内容 | 原因/讨论 | 影响范围 | 审批/PR |
| --- | --- | --- | --- | --- | --- |
| 2025-09-03 | REQ-001 | 验收标准细化 | 评审建议 | 测试、文档 | #123 |
| 2025-09-03 | REQ-002 | 扩展到 Gradle 矩阵；修复工作流 YAML；更新文档与清单；创建分支 | 采纳工程建议并实施 | CI、文档 | 分支 ci/quality-gates-gradle-matrix（PR 待创建） |

## 18. 使用指南与示例（How-to）
- 使用步骤（5 分钟上手）：
	1) 新建需求：复制第 13 节模板，生成唯一 ID（如 REQ-101），按需填写并落到第 14 节清单。
	2) 设计与计划：在 PR 描述中给出最小可行方案（MVP），列出测试点与回滚策略（6A）。
	3) 关联追踪：在第 16 节 RTM 增加一行，将需求与 PR/测试/部署记录关联。
	4) 执行留痕：实施时将关键命令追加到 `COMMAND_REFERENCE.md`（含：目的、命令、期望输出、实际输出解读、异常处理）。
	5) 变更记录：如需求描述/验收标准调整，在第 17 节追加一行 Changelog。
	6) 提交合规：PR 勾选质量门禁（构建、Lint/类型、测试与覆盖率≥80%、Smoke），并更新相关文档链接。

- 示例（文档类需求，便于复用）：
	- 需求（第 13 节模板实例）
		- 需求 ID：REQ-101
		- 标题/名称：Certbot 续期演练文档与命令留痕
		- 背景与动机：定期验证生产证书续期流程，降低到期风险
		- 详细描述：对生产域名执行 `certbot renew --dry-run` 并热重载 Nginx，记录输出与回滚措施
		- 优先级：P1
		- 验收标准：
			- dry-run 成功；Nginx reload 成功且 200/HTTPS 正常
			- `COMMAND_REFERENCE.md` 有完整记录与异常应对
		- 依赖与外部接口：Nginx、Certbot、系统定时任务
		- 风险与回滚策略：reload 失败回滚原配置并恢复旧证书；保留配置与证书备份
		- 安全/合规影响：证书私钥不外泄；日志不包含敏感路径
		- 非功能性：操作无感知中断；演练≤10 分钟
		- 变更影响面：运维文档、运维命令
		- 责任人/协作人：Owner A / Ops B
		- 计划里程碑/截止时间：2025-09-10
		- 关联：docs/COMMAND_EXAMPLES.md#certbot-续期与-nginx-热加载、COMMAND_REFERENCE.md 条目、PR-XYZ
		- 状态：Done

	- RTM（第 16 节示例行）
		- REQ-101 | 设计/文档：docs/COMMAND_EXAMPLES.md#certbot-续期与-nginx-热加载 | 代码变更（PR）：PR-XYZ | 测试用例：N/A（文档/操作演练） | 覆盖率：N/A | 部署记录：运维演练-2025-09-10 | 回滚演练：已验证

	- 命令留痕（`COMMAND_REFERENCE.md` 示例条目骨架）
		- 元信息：
			- 日期：2025-09-10
			- 环境：prod
			- 责任人：Owner A（@github-id）
			- 关联：REQ-101，PR-XYZ
		- 场景：证书续期演练（dry-run）与 Nginx 热加载
		- 命令与解读：
			- certbot renew --dry-run（期望：所有域名模拟续期成功）
			- nginx -t && nginx -s reload（期望：配置校验通过并热重载成功）
			- 验证：curl -I https://your-domain（期望：HTTP/2 200 与有效证书）
		- 异常与处理：如校验失败，回滚至备份配置，恢复服务后再查因

---

附：快速执行清单（Checklist）
- [ ] Accept：需求/约束确认，假设记录
- [ ] Analyze：依赖/结构梳理，DRY 复用点识别
- [ ] Approach：方案与权衡，回滚路径
- [ ] Action：先计划后 MVP，提交小步化
- [ ] Assess：构建/Lint/测试/覆盖率/Smoke 全过
- [ ] Adjust：改进项登记与跟进
- [ ] 文档：更新 `COMMAND_REFERENCE.md`；提交信息规范

### 导出与再生（Manifest）
- 可选能力：当仓库具备对应脚本/工作流时，更新本文件可以导出 `build/project_manifest.json` 构件（见“导出需求清单（Manifest）”工作流）。
- 该 JSON 可作为脚手架输入，生成同构项目骨架。
- 若你只复制了四个核心文件（`.github/copilot-instructions.md`、`.vscode/settings.json`、`COMMAND_REFERENCE.md`、`PROJECT_REQUIREMENTS.md`），仍可先按本文件执行规则与留痕；需要导出/脚手架时再引入脚本：
	- `scripts/requirements_export.py`（导出 Manifest v2）
	- `scripts/scaffold_from_manifest.py`（根据 Manifest 生成最小脚手架）
	- 使用示例：
		- python scripts/requirements_export.py
		- python scripts/scaffold_from_manifest.py --manifest build/project_manifest.json --out scaffold-out
