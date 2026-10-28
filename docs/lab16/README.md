# Lab16 总览：USD for Robotics

> 目标：从 URDF 开始，做出一个可仿真的 UR10e + Robotiq 2F-140 机器人资产，放进仓库场景，并完成一轮资产优化。  
> 原始资料：`IsaacSim_16/16_usd_robo_lab_instructions/gtc25-16-usd-for-robotics/`  
> **当前状态：M1-M6 全部完成。M6 已完成 Mesh Merge、Instancing、Collider 实操。**

---

## 1. 学完能做什么

- 理解机器人 USD 资产的结构：Link / Joint / Rigid Body / Collision / Articulation
- 用 URDF Importer 导入 UR10e，并调好关节 Drive
- 导入 Robotiq 2F-140 闭链夹爪，理解 PhysxMimic
- 用 Reference + Fixed Joint 把夹爪装到 UR10e
- 把机器人放进仓库场景，验证 Play 稳定
- 用 Mesh Merge / Instancing / Collider 优化 Jetbot 资产

---

## 2. 模块

| 模块 | 内容 | 章节 |
|---|---|---|
| M1 | 机器人资产结构 | [01 资产结构](01_asset_structure.md) |
| M2 | UR10e 导入 + Gain Tuner | [02 UR10e 导入](02_ur10e_import_gain_tuner.md) |
| M3 | Robotiq 2F-140 夹爪 | [03 2F-140 夹爪](03_robotiq_gripper.md) |
| M4 | UR10e + 2F-140 组装 | [04 组装](04_ur10e_gripper_assembly.md) |
| M5 | 仓库训练场景 | [05 仓库场景](05_warehouse_scene.md) |
| M6 | 资产优化 | [06 资产优化](06_asset_optimization.md) |

排错记录：

- [07 Lab16 踩坑记录](07_pitfalls.md)

---

## 3. 最终资产

| 文件 | 作用 |
|---|---|
| `work/lab16/ur10_1/ur10_with_gripper.usda` | 最终组装资产 |
| `work/lab16/robotiq_2f_140/robotiq_2f_140.usda` | 最终 5 关节 PhysxMimic 夹爪 |
| `work/lab16/warehouse.usda` | M5 仓库场景 |
| `work/lab16/ur10_1/ur10_with_gripper_test.usda` | 夹爪隔离测试装配 |
| `work/lab16/robotiq_2f_140/robotiq_2f_140_fixed.usda` | 官方完成版配置副本 |

---

## 4. 完成标准

- [x] UR10e 导入后 Play 不软塌
- [x] 2F-140 张开/闭合稳定，黑色支架不掉
- [x] 夹爪通过 `gripper_fixed_joint` 连到 `wrist_3_link`
- [x] 机器人通过 `base_fixed_joint` 固定在仓库场景
- [x] 仓库 Play 60 秒不飞、不爆炸
- [x] 夹爪 Target 0 / 40 可切换
- [x] Jetbot 资产优化：Mesh Merge、Instancing、Collider 实操完成
- [x] 文档和踩坑记录已归档

---

## 5. 关键经验

1. `base_link` 可能只是 Xform，刚体是 `base_link_inertia`
2. `tool0` 可能只是 frame，夹爪要锚 `wrist_3_link`
3. 6.1 的 Importer 写 `NewtonMimicAPI`，不是 4.5 的 `PhysxMimicJointAPI`
4. 2F-140 是闭链，不能照搬 2F-85 的 Physx_Loop
5. URDF mimic multiplier 不能直接抄成 PhysxMimic gearing
6. 视觉上在架子上，不代表碰撞体不重叠

---

## 6. 下一步

- [Lab19 SMMG 总览](../lab19/README.md)
- [6.1 版本陷阱](../shared/version_traps.md)
