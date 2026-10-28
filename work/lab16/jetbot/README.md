# Lab16 M6 Jetbot 工作副本

> 这里是从 `IsaacSim_16/16_USD_FOR_ROBOTICS/Jetbot` 复制出来的工作副本。  
> 原始资料不要改；所有练习都在这里做。

## 起点

- 已预加载基础资产的 Stage：`Jetbot_Optimized/jetbot_m6_loaded.usd`
- 空白 Stage（手动练习 Insert Sublayer）：`Jetbot_Optimized/jetbot_m6_work.usd`
- 基础资产：`Jetbot_Base/Jetbot_base.usd`

> 注意：Layers 面板要用 **Insert Sublayer**（插入已有层），不要用 **Create Sublayer**（新建空层）。  
> 如果 Stage 仍然为空，先检查 Stage 面板的过滤器和 Layer 的静音/可见性。
- 官方参考：
  - `Jetbot_Optimized/Jetbot_optimized_post_merge.usd`（已完成 Mesh Merge）
  - `Jetbot_Optimized/Jetbot_optimized_final.usd`（Merge + Instancing）
  - `Jetbot_physics/Jetbot_physics.usd`（碰撞体练习起点）
  - `Jetbot_physics/Jetbot_physics_final.usd`（碰撞体完成版）

## 目标输出

- `Jetbot_Optimized/jetbot_m6_merged.usd`
- `Jetbot_Optimized/jetbot_m6_instanced.usd`
- `Jetbot_physics/jetbot_m6_physics.usd`

## 三步

### 1. Mesh Merge（6.1 用 Scene Optimizer）

- 打开 `jetbot_m6_work.usd`
- Layer > Insert Sublayer > `../Jetbot_Base/Jetbot_base.usd`
- 6.1 没有 Mesh Merge Tool；改用 `Window > Utilities > Scene Optimizer`
- 添加 `Merge Static Meshes`，或运行 README 对应的脚本
- 目标是这两个 mesh prim：
  - `/Jetbot/left_wheel/_WD_tyre/_WD_tyre`
  - `/Jetbot/left_wheel/_WD_buggy_wheel_v5_1_1/_WD_buggy_wheel_v5_1_1`
- Merge Boundary = `Stage`，Output Name = `/Merged/left_wheel`
- 检查 `/Merged/left_wheel` 是单个 Mesh + GeomSubset
- Save As `jetbot_m6_merged.usd`

### 2. Instancing

- 打开 `Jetbot_optimized_post_merge.usd`
- 把 `Visuals/left_wheel` 重命名为 `wheel`
- 删除 `Visuals/right_wheel`
- 把右轮的 Reference Prim Path 改成 `/Visuals/wheel`
- 选中所有 `Visuals`，勾选 Instanceable
- Save As `jetbot_m6_instanced.usd`

### 3. Colliders

- 打开 `Jetbot_physics/Jetbot_physics.usd`
- 车轮用 Cylinder Collider：
  - Translate `(0, 0, 0.003)`
  - Radius `0.035`
  - Height `0.015`
- 删除旧车轮 Collider
- 保存为 `jetbot_m6_physics.usd`

## 验收

- [x] Mesh Merge：left_wheel 已完成（`/Merged/left_wheel` + 2 GeomSubset）
- [x] Instancing：左右轮共享 `/Visuals/wheel`，Instanceable
- [x] Colliders：车轮圆柱体，旧碰撞体已移除
- [x] 记录前后 Mesh / Instanceable / Collider 数量
- [x] 更新 `docs/lab16/06_asset_optimization.md` 状态为完成
