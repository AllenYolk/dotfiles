# MiniMax-M2.7-highspeed 用于 Neovim 行内补全的可行性调查

调查日期：2026-07-31
范围：中国区 MiniMax 开放平台（当前配置使用 `api.minimaxi.com`）、当前仓库中的 Neovim/Minuet 配置，以及 `lazy-lock.json` 锁定的 Minuet 实现。外部事实只采用 MiniMax 官方文档、官方模型页/公告；Minuet 行为采用其锁定版本的官方源码。

## 结论

`MiniMax-M2.7-highspeed` **仍是当前正式可用的 API 模型，也有足够的代码能力**，准确 model ID 为 `MiniMax-M2.7-highspeed`。中国区 OpenAI-compatible endpoint 仍是 `https://api.minimaxi.com/v1/chat/completions`，支持流式输出。MiniMax 当前模型概览将 M2.7 和 M2.7-highspeed 列在现役语言模型区，而 M2.5 起才位于“历史模型”区；Chat Completions 的 `model` 枚举也仍包含该 ID。[当前模型概览](https://platform.minimaxi.com/docs/guides/models-intro)；[Chat Completions API](https://platform.minimaxi.com/docs/api-reference/text-chat-openai)

但是，**不建议在现有 Minuet 配置中将 `MiniMax-M3` 替换为 `MiniMax-M2.7-highspeed`**。原因不是 M2.7 的代码能力不足，而是这条低延迟补全链路与 M2.x 的强制 thinking 不匹配：

1. MiniMax 官方明确说明，M2.x 的 thinking 无法关闭；即使传入 `thinking = { type = "disabled" }`，thinking 仍会开启。未启用 `reasoning_split` 时，thinking 会留在 `content` 的 `<think>...</think>` 中。[OpenAI SDK：Thinking 控制](https://platform.minimaxi.com/docs/api-reference/text-openai-api)
2. 当前配置锁定的 Minuet `d29dec4c...` 在流式模式下只读取并拼接 `choices[1].delta.content`，后续只按 `<endCompletion>` 拆分、裁剪空白，没有 `<think>` 过滤。因此 M2.x 原生内容会污染行内候选。[锁定版本 `openai_base.lua`](https://github.com/milanglacier/minuet-ai.nvim/blob/d29dec4c36be2b41aa10e70938b7b09a03f0bdba/lua/minuet/backends/openai_base.lua#L5-L10)；[锁定版本 `common.lua`](https://github.com/milanglacier/minuet-ai.nvim/blob/d29dec4c36be2b41aa10e70938b7b09a03f0bdba/lua/minuet/backends/common.lua#L87-L98)
3. 当前请求只有 `2.5s` timeout 和 `56` 个 completion token。M2.x 的强制 thinking 会占用这份很小的生成预算，并推迟真正代码内容；因此有被截断、超时或只得到 reasoning 而没有可用补全的风险。这是根据官方输出格式与本地配置作出的工程推断，不是 MiniMax 公布的专项测试结果。
4. 官方标注 M2.7-highspeed 约 `100 TPS`，但 TPS 的计算从“首 token”才开始，不包含排队、prefill 或首 token 等待时间。它不能证明用户关心的补全启动延迟会比当前 M3 更短。[TPS 官方定义](https://platform.minimaxi.com/docs/faq/about-apis)
5. MiniMax 官方反而明确指出：M3 关闭 thinking 后响应更快，适合对延迟敏感的 conversation 和 **code completion**。当前配置正是 `MiniMax-M3` + `thinking.disabled`，与该官方推荐一致。[M3 官方发布说明](https://www.minimax.io/blog/minimax-m3)；[OpenAI SDK：M3 thinking 参数](https://platform.minimaxi.com/docs/api-reference/text-openai-api)

因此本次调查建议：**保持 `MiniMax-M3` 和 `thinking = { type = "disabled" }` 不变，不执行模型替换。** 若还要继续比较，应扩大真实输入上的 A/B 测量，指标至少包括 TTFT、首个可用代码 token 时间、2.5 秒内成功率和候选正确率；仅比较官方 TPS 不足以支持切换。

### 当前配置的本机 API 冒烟检查

2026-07-31 在本机使用现有凭据做了最小检查；未读取、打印或记录 API key。该结果是特定网络、账户和平台负载下的小样本观测，**不是 MiniMax 官方 benchmark**：

- `GET /v1/models/MiniMax-M2.7-highspeed` 成功，进一步确认当前账户可访问该 model ID。
- 使用相同的流式请求、`max_completion_tokens = 56` 和 `thinking = { type = "disabled" }`，每个模型各运行两次。
- M3 的首个可用内容分别在 `2.328s` 和 `2.172s` 出现，两次都落在当前 Minuet 的 `2.5s` timeout 内。
- M2.7-highspeed 两次都观察到 thinking：一次到 `3.785s` 结束仍没有可用补全内容；另一次首个可用内容在 `2.523s` 出现，已超过当前 timeout。

因此在这组直接对应现有配置的检查中，M2.7-highspeed 的 `2.5s` 内可用补全成功率为 `0/2`，M3 为 `2/2`。样本量不足以描述一般 API 性能，却足以否定“按当前参数直接替换后可以正常降低 latency”这一变更前提；它也实证了 M2.x 的 disabled thinking 不生效。

## 官方事实

### 1. 可用性、ID、协议和 endpoint

| 项目 | 当前官方信息 |
| --- | --- |
| 生命周期 | M2.7/M2.7-highspeed 位于现役语言模型区，不在“历史模型”区 |
| 准确 model ID | `MiniMax-M2.7-highspeed` |
| 中国区 OpenAI base URL | `https://api.minimaxi.com/v1` |
| 当前配置使用的完整 endpoint | `POST https://api.minimaxi.com/v1/chat/completions` |
| OpenAI compatibility | 官方支持；Chat Completions 的 model 枚举包含 M2.7-highspeed |
| Anthropic compatibility | 官方也支持；本次 Minuet 配置使用 OpenAI-compatible 路径 |
| 流式输出 | 支持，`stream: true` 时分批返回 `chat.completion.chunk` |

证据：

- [MiniMax 当前模型概览](https://platform.minimaxi.com/docs/guides/models-intro)
- [MiniMax API 概览](https://platform.minimaxi.com/docs/api-reference/api-overview)
- [OpenAI SDK 兼容文档](https://platform.minimaxi.com/docs/api-reference/text-openai-api)
- [OpenAI Chat Completions API](https://platform.minimaxi.com/docs/api-reference/text-chat-openai)
- [Anthropic SDK 兼容文档](https://platform.minimaxi.com/docs/api-reference/text-anthropic-api)

上述页面截至调查日仍同时列出 M3、M2.7 和 M2.7-highspeed，足以证明平台层面的正式可用性；本机 smoke check 也确认当前账户能够检索该 model ID。实际生成仍取决于账户当下的套餐/额度，本调查没有读取、打印或记录本地凭据。

### 2. 上下文、代码能力和流式输出

| 项目 | MiniMax-M2.7-highspeed |
| --- | --- |
| 上下文窗口 | 204,800 tokens，输入与输出合计 |
| 官方输出速度 | 约 100 TPS |
| 与 M2.7 的关系 | 官方称能力和效果相同，但推理速度大幅提升 |
| 流式输出 | OpenAI-compatible Chat Completions 支持 `stream: true` |
| 代码能力 | 继承 M2.7 的真实软件工程、端到端项目交付、bug hunting、代码安全和机器学习任务能力 |

[API 概览](https://platform.minimaxi.com/docs/api-reference/api-overview)列出 204,800 上下文和约 100 TPS；[当前模型概览](https://platform.minimaxi.com/docs/guides/models-intro)称其“与 M2.7 效果不变，速度大幅提升”。[M2.7 官方模型页](https://www.minimax.io/models/text/m27)称 M2.7 在真实软件工程、端到端项目交付、日志分析定位 bug、代码安全和机器学习任务中表现良好，并给出 SWE-Pro 56.22%、VIBE-Pro 55.6%、Terminal Bench 2 57.0% 等结果；同页也把 highspeed 作为面向 AI coding tools 的高 TPS 版本。

所以，“能够生成和续写代码”有充分官方依据；但 MiniMax 没有发布 Neovim 行内补全或 FIM 的专项 benchmark。认为它“能做自动补全”属于由代码能力和通用 Chat Completions 能力推导出的合理结论，不是官方对当前 Minuet 配置的兼容承诺。

### 3. Thinking 是阻止直接替换的关键约束

MiniMax 当前 OpenAI SDK 文档明确区分：

- M3 可用 `thinking: { type: "disabled" }` 跳过 thinking，直接回答。
- M2.x 无法关闭 thinking；即使传入同一 disabled 参数，thinking 仍保持开启。
- `reasoning_split` 只改变 thinking 的返回位置，不会关闭 thinking。
- 未分离时，原生 Chat Completions 会把 thinking 放在 `content` 的 `<think>...</think>` 标签中。

来源：[OpenAI SDK 的 Thinking 控制章节](https://platform.minimaxi.com/docs/api-reference/text-openai-api)；[Chat Completions 参数定义](https://platform.minimaxi.com/docs/api-reference/text-chat-openai)。

当前本地状态：

- `nvim/lua/plugins/core.lua` 使用 `MiniMax-M3`、`request_timeout = 2.5`、`max_completion_tokens = 56`、`thinking = { type = "disabled" }`。
- `nvim/lazy-lock.json` 将 Minuet 锁定在 `d29dec4c36be2b41aa10e70938b7b09a03f0bdba`。
- 该版本流式解析器返回 `json.choices[1].delta.content`，没有读取或丢弃 MiniMax 的 reasoning 字段，也没有剥离 `<think>`。

如果只替换 model ID，disabled 参数对 M2.7-highspeed 不生效。强制 thinking 会同时带来三类风险：真正代码的首 token 更晚；`<think>` 进入虚拟文本候选；56-token 输出上限可能先被 reasoning 消耗。这些是基于官方协议和锁定源码的直接集成分析。

### 4. 价格（中国区按量付费）

截至调查日，中国区官方标准层价格如下，单位均为人民币元/百万 tokens：

| 模型 | 输入 | 输出 | 缓存读取 | 缓存写入 |
| --- | ---: | ---: | ---: | ---: |
| MiniMax-M3，输入不超过 512K，当前永久五折价 | 2.10 | 8.40 | 0.42 | 官方当前表格未列 |
| MiniMax-M2.7-highspeed | 4.20 | 16.80 | 0.42 | 2.625 |

M2.7-highspeed 的输入和输出单价是当前 M3 标准层（≤512K）的两倍。M3 `priority` 层为标准价格的 1.5 倍，官方称其提供优先准入、响应更快并降低失败率；这仍不是 M2.7-highspeed 的功能等价替代，但如果实际瓶颈来自请求排队，它是比换成强制 thinking 模型更贴近问题的一条可测方案。

来源：[中国区按量计费](https://platform.minimaxi.com/docs/guides/pricing-paygo)；[Chat Completions 的 `service_tier`](https://platform.minimaxi.com/docs/api-reference/text-chat-openai)。

### 5. 速率限制

中国区充值用户的当前公开限额：

| 模型 | RPM | TPM（输入 + 输出） |
| --- | ---: | ---: |
| MiniMax-M3 | 200 | 10,000,000 |
| MiniMax-M2.7 / M2.7-highspeed | 500 | 20,000,000 |

M2.7-highspeed 在公开限额上更宽松。对单用户 Neovim 行内补全，这通常不是首个候选等待时间的直接决定因素；只有实际遇到限流时才会成为主要优势。

来源：[MiniMax 中国区速率限制](https://platform.minimaxi.com/docs/guides/rate-limits)。

## 与当前 MiniMax-M3 的延迟比较

可核验事实：

- M2.7-highspeed：官方约 100 TPS。
- M3：官方 API 文档没有公布可直接与 100 TPS 横向比较的常规请求 TPS、TTFT、P50 或 P95 延迟。
- 官方 TPS 公式仅使用“最后 token 时间 - 第一 token 时间”，所以不含首 token 之前的全部等待。
- M3 可关闭 thinking；M2.x 不可关闭。
- M3 官方发布说明明确把关闭 thinking 的模式定位于对延迟敏感的 conversation 和 code completion。

由此可得的推断：

- 100 TPS 证明 M2.7-highspeed 在开始输出后具有较高解码吞吐，不证明更快出现首个可用代码 token。
- 对只有几十个输出 token 的行内补全，TTFT 和 thinking 前置时间可能比解码吞吐更重要。
- 在当前 2.5 秒 timeout 下，M3 non-thinking 的协议特性比 M2.7-highspeed 的 100 TPS 更符合目标。
- 官方资料本身不足以声称 M2.7-highspeed 会降低当前观察到的 latency；本机两轮 A/B 小样本也没有显示改善，反而两次都未能在 2.5 秒内提供可用补全。

## 决策记录

| 判断 | 结果 | 依据 |
| --- | --- | --- |
| M2.7-highspeed 仍可通过官方 API 使用吗？ | 是 | 当前模型区、Chat Completions model 枚举、价格和限流页面均仍列出 |
| 准确 ID/endpoint 是否适配当前 OpenAI-compatible provider？ | 是 | `MiniMax-M2.7-highspeed` + 当前 `/v1/chat/completions` |
| 模型是否有能力完成代码补全？ | 是 | 与 M2.7 效果相同；M2.7 有明确软件工程与 coding 证据 |
| 能否证明它比当前 M3 non-thinking 的补全启动更快？ | 否 | 100 TPS 不含 TTFT，M3 API TPS/TTFT 未公布，且 M2.x 强制 thinking |
| 是否应在现有 Minuet 配置中直接替换？ | 否 | thinking 无法关闭、parser 不过滤 `<think>`、56-token/2.5s 预算过紧 |
| 本次推荐 | 保持当前 M3 + thinking disabled | 与 MiniMax 对 code completion 的官方低延迟定位一致 |
