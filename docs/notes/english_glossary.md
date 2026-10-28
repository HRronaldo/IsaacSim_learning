# NVIDIA / Isaac Sim 英文词汇表（持续更新）

> 用法：每天 Day 任务结束后，把当天遇到的新词补进来。不要背整张表，优先背“在图中/文档中反复出现”的词。

---

## 1. 这张图的词（Asset Pipeline）

| English | 音标（近似） | 中文 | 说明 |
|---|---|---|---|
| asset | /ˈæsɛt/ | 资产 | 一个可复用的 3D 资源：机器人、道具、场景 |
| source | /sɔːrs/ | 来源 | 数据从哪来 |
| transformation | /ˌtrænsfərˈmeɪʃən/ | 转换 | 这里指“把原始资产改造成仿真可用结构”，不是数学变换 |
| feature | /ˈfiːtʃər/ | 功能特性 | 可选能力模块：物理、传感器、ROS、控制 |
| pipeline | /ˈpaɪplaɪn/ | 管线 / 流水线 | 一串按顺序处理的步骤 |
| extract | /ɪkˈstrækt/ | 提取 | 把原始数据取出来 |
| transform | /trænsˈfɔːrm/ | 转换 | 加工成需要的形态 |
| load | /loʊd/ | 加载 | 把处理好的东西装进最终资产 |
| base | /beɪs/ | 基础 | 最原始的底座 |
| parts | /pɑːrts/ | 零件 | 可复用的子组件 |
| materials | /məˈtɪriəlz/ | 材质 | 颜色、粗糙度、贴图等“外观” |
| sublayer | /ˈsʌbleɪər/ | 子层 | USD 里把一层叠在另一层下面的组合方式 |
| reference | /ˈrɛfərəns/ | 引用 | 像“超链接”一样把另一个 USD 文件引进来 |
| payload | /ˈpeɪloʊd/ | 载荷 | 一种“可按需加载”的引用，适合很重的资产 |
| interface | /ˈɪntərfeɪs/ | 接口 | 对外暴露的那一层 |
| entry point | /ˈɛntri pɔɪnt/ | 入口点 | 用户只需要打开这一个文件 |
| reorganize | /riˈɔːrɡənaɪz/ | 重新组织 | 按仿真需要重排层级 |
| simulation | /ˌsɪmjəˈleɪʃən/ | 仿真 | 用计算机模拟真实世界 |
| structure | /ˈstrʌktʃər/ | 结构 | 层级/组织方式 |
| breakdown | /ˈbreɪkdaʊn/ | 拆分 | 把整体拆成部件 |
| visual | /ˈvɪʒuəl/ | 视觉的 | 这里指“看得见的网格” |
| collider | /kəˈlaɪdər/ | 碰撞体 | 物理引擎用来算碰撞的形状，常比视觉网格简单 |
| merge | /mɜːrdʒ/ | 合并 | 把多个网格合成一个 |
| mesh | /mɛʃ/ | 网格 | 3D 模型的三角面片 |
| clean | /kliːn/ | 干净的 / 清理 | 去掉多余层级、命名、空节点 |
| instanceable | /ɪnˈstænsəbəl/ | 可实例化的 | 多个地方共享同一份数据，省内存 |
| physics | /ˈfɪzɪks/ | 物理 | 刚体、关节、质量、碰撞 |
| sensor | /ˈsɛnsər/ | 传感器 | 相机、激光雷达、IMU 等 |
| control | /kənˈtroʊl/ | 控制 | 驱动器、控制器 |
| non-destructive | /ˌnɑːn dɪˈstrʌktɪv/ | 非破坏性的 | 改东西不破坏原始文件 |
| modular | /ˈmɑːdʒələr/ | 模块化的 | 每个功能单独一层，可拆可换 |
| workflow | /ˈwɜːrkfloʊ/ | 工作流 | 从导入到使用的整套流程 |

**短语：**
- `Asset as it was imported` = 资产按导入时的原样（还没加工）
- `as required for simulation` = 按仿真需要
- `as needed` = 按需
- `entry point for asset use` = 资产使用的入口
- `Extract-Transform-Load Pipeline` = 提取-转换-加载管线

---

## 2. USD 组合术语（必背，NVIDIA 文档高频）

| English | 中文 | 一句话理解 |
|---|---|---|
| Layer | 层 | 一个 USD 文件就是一层 |
| Layer Stack | 层堆栈 | 多层按强度叠在一起 |
| Sublayer | 子层 | 把一层叠在下面，弱的会被强的覆盖 |
| Reference | 引用 | 把另一个 USD 当组件引进来，可复用、可覆盖 |
| Payload | 载荷 | 可延迟加载的引用，适合大资产 |
| Variant | 变体 | 同一个资产的不同版本（如夹爪开/合） |
| Inherit | 继承 | 从父级继承属性 |
| Specialize | 特化 | 一种较弱的组合方式 |
| Override | 覆盖 | 在上层改下层的值 |
| Composition Arc | 组合弧 | 以上这些“把层/资产组合起来”的机制统称 |
| Stage | 舞台 | 打开 USD 后看到的整个场景 |
| Prim | 图元 | 场景里的一个对象/节点 |
| Attribute | 属性 | 对象上的一个值（位置、质量等） |
| Relationship | 关系 | 对象之间的指向关系 |

---

## 3. 读 NVIDIA 文档的句型

| 句型 | 中文 | 例子 |
|---|---|---|
| X allows Y to Z | X 允许 Y 做 Z | This structure allows assets to be combined modularly. |
| X is used to Y | X 用于 Y | This tool is used to import URDF. |
| X is required for Y | Y 需要 X | Physics is required for simulation. |
| Ensure that ... | 确保…… | Ensure that the file is saved. |
| Navigate to ... | 导航到…… | Navigate to File > Import. |
| Select ... | 选择…… | Select the UR10e prim. |
| Set ... to ... | 把……设为…… | Set the value to 300. |
| Verify that ... | 验证…… | Verify that the robot does not collapse. |
| If ... , then ... | 如果……，那么…… | If the asset fails to load, then use the checkpoint. |

**读法建议：** 先找动词（Open / Select / Set / Ensure / Verify），再找宾语；名词复合词从右往左读。

---

## 4. 名词复合词：从右往左读

- `robot asset structure` = structure of robot assets（机器人资产的结构）
- `simulation structure` = structure for simulation（用于仿真的结构）
- `interface layer` = layer that serves as an interface（作为接口的层）
- `entry point for asset use` = the point of entry for using the asset（使用资产的入口）
- `extract-transform-load pipeline` = a pipeline of extract, transform, load（提取-转换-加载管线）

---

## 5. 小练习（先自己译，再看答案）

1. Asset as it was imported.
2. Reorganizing from base as required for simulation.
3. Simulation structure (breakdown visual / colliders as needed).
4. Merging meshes; clean, instanceable references.
5. Interface layer; entry point for asset use.
6. Extract-Transform-Load Pipeline for Robots in USD.

**答案：**
1. 资产按导入时的原样保存。
2. 按仿真需要，从基础资产重新组织。
3. 仿真结构（按需拆分视觉网格/碰撞体）。
4. 合并网格；清理并做成可实例化的引用。
5. 接口层；资产使用的入口。
6. USD 机器人资产的提取-转换-加载管线。

