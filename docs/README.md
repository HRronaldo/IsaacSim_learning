# Isaac Sim 6.1 学习教程

> 从 URDF 资产、机器人组装、仓库场景，到 Isaac Lab 模仿学习。  
> 本目录是教程的唯一知识库；`work/` 只放实际资产，不属于 GitBook 页面。

---

## 教程状态

| 阶段 | 状态 |
|---|---|
| Lab16 M1-M6 | 完成 |
| Lab19 M1-M3 | 完成（BC-RNN 40% baseline） |
| 自动录制 | 完成（`work/lab19/videos/stack_0000.mp4`） |
| 教程收尾 | **已完成，见 [99 入门教程收尾](99_course_closeout.md)** |
| Capstone / ROS / MEGA | 可选后续，当前不做 |

---

## 版本基线

| 项目 | 版本 |
|---|---|
| Isaac Sim | **6.1.0.0** |
| Isaac Lab | **3.0.0**（pip 包 17.0.1） |
| PyTorch | 2.11.0+cu128 |
| OS | Windows 11 + Git Bash |

> 官方文档认准 `/6.1.0/`：`https://docs.isaacsim.omniverse.nvidia.com/6.1.0/`

---

## 课程地图

| 顺序 | 模块 | 文件 | 状态 |
|---:|---|---|---|
| 1 | 环境搭建 | [shared/00_environment.md](shared/00_environment.md) | 完成 |
| 2 | Isaac Sim 基础 | [shared/01_isaac_sim_basics.md](shared/01_isaac_sim_basics.md) | 完成 |
| 3 | 6.1 版本陷阱 | [shared/version_traps.md](shared/version_traps.md) | 完成 |
| 4 | Lab16 总览 | [lab16/00_overview.md](lab16/00_overview.md) | 完成 |
| 5 | Lab16 M1 资产结构 | [lab16/01_asset_structure.md](lab16/01_asset_structure.md) | 完成 |
| 6 | Lab16 M2 UR10e 导入 | [lab16/02_ur10e_import_gain_tuner.md](lab16/02_ur10e_import_gain_tuner.md) | 完成 |
| 7 | Lab16 M3 2F-140 夹爪 | [lab16/03_robotiq_gripper.md](lab16/03_robotiq_gripper.md) | 完成 |
| 8 | Lab16 M4 组装 | [lab16/04_ur10e_gripper_assembly.md](lab16/04_ur10e_gripper_assembly.md) | 完成 |
| 9 | Lab16 M5 仓库场景 | [lab16/05_warehouse_scene.md](lab16/05_warehouse_scene.md) | 完成 |
| 10 | Lab16 M6 资产优化 | [lab16/06_asset_optimization.md](lab16/06_asset_optimization.md) | **完成** |
| 11 | Lab16 踩坑记录 | [lab16/07_pitfalls.md](lab16/07_pitfalls.md) | 完成 |
| 12 | Lab19 总览 | [lab19/00_overview.md](lab19/00_overview.md) | 完成（M1-M3） |
| 13 | Lab19 遥操作 | [lab19/01_teleop.md](lab19/01_teleop.md) | 完成（1 条手动 + 官方 10 条） |
| 14 | Lab19 GR00T-Mimic | [lab19/02_groot_mimic.md](lab19/02_groot_mimic.md) | 完成（10 + 200 条） |
| 15 | Lab19 BC-RNN | [lab19/03_bc_rnn.md](lab19/03_bc_rnn.md) | 完成（40% success） |
| 16 | Lab19 踩坑记录 | [lab19/04_pitfalls.md](lab19/04_pitfalls.md) | 已记录 |
| 17 | 原始笔记归档 | [notes/README.md](notes/README.md) | 归档 |
| 18 | 可选 Lab18 ROS | [optional/lab18_isaac_ros.md](optional/lab18_isaac_ros.md) | 跳过 |
| 19 | 可选 MEGA SIL | [optional/mega_sil.md](optional/mega_sil.md) | 跳过 |

> **完整性由本表 + 每章验收清单证明，而不是文件名里的全局编号。**

---

## Lab16 完成情况

Lab16 的 **M1-M6 已完成**：

- M1-M5：UR10e 导入、2F-140 PhysxMimic、组装、仓库场景
- M6：Jetbot Mesh Merge、Instancing、Collider 实操完成

M1-M5 关键验收：

- 夹爪：`2500 Hz / 0.005`，gearing `+1/+1/+1/-1/-1`
- 机器人：`Z=1.21913`，与支架约 5mm 间隙
- GUI Play 稳定；headless 3600 步无爆炸

M6 关键验收：

- Mesh Merge：`/Merged/left_wheel` 是 1 个 Mesh + `Periwinkle_Gray` / `Woodsmoke` 两个 GeomSubset
- Instancing：`558` 个 instanceable prim，`3` 个 Mesh；左右轮共享 `/Visuals/wheel`
- Collider：左右轮 `Collider` 引用 `/Collisions/wheel`，`Instanceable`；旧 `Visuals` Collider 已删除；Cylinder Purpose = `guide`
- 本地产物：
  - `work/lab16/jetbot/Jetbot_Optimized/jetbot_m6_merged.usd`
  - `work/lab16/jetbot/Jetbot_Optimized/jetbot_m6_instanced.usd`
  - `work/lab16/jetbot/Jetbot_physics/jetbot_m6_physics.usd`

---

## Lab19 完成情况

- M1 遥操作：手动 1 条 + 官方 10 条
- M2 Mimic：本次 10 条（35.7%）+ 200 条（39.4%）
- M3 BC-RNN：200 条 3.0 数据 + 500 epoch → **4/10 = 40% success**
- 自动录制：`work/lab19/videos/stack_0000.mp4`
- 旧官方 1003 条（2025 年）在 3.0 上 0%，已确认不匹配，不再作为训练数据
- 最佳 checkpoint：`training_logs/IsaacContrib-Stack-Cube-Franka-IK-Rel/bc_rnn_m1_3p0/20261027124906/models/model_epoch_500.pth`

---

## 目录结构

```text
docs/
├─ README.md
├─ SUMMARY.md                  GitBook 导航
├─ shared/
│  ├─ 00_environment.md
│  ├─ 01_isaac_sim_basics.md
│  ├─ version_traps.md
│  └─ assets/
├─ lab16/
│  ├─ 00_overview.md
│  ├─ 01_asset_structure.md
│  ├─ 02_ur10e_import_gain_tuner.md
│  ├─ 03_robotiq_gripper.md
│  ├─ 04_ur10e_gripper_assembly.md
│  ├─ 05_warehouse_scene.md
│  ├─ 06_asset_optimization.md
│  ├─ 07_pitfalls.md
│  └─ assets/
├─ lab19/
│  ├─ 00_overview.md
│  ├─ 01_teleop.md
│  ├─ 02_groot_mimic.md
│  ├─ 03_bc_rnn.md
│  ├─ 04_pitfalls.md
│  └─ assets/
├─ notes/
├─ optional/
└─ assets/
   └─ raw/
```

---

## 写作约定

- 每个 Lab 内部用 `00, 01, 02...` 编号
- 总顺序看本页课程表，不在文件名里写全局序号
- 踩坑记录放各 Lab 的 `pitfalls.md`
- 跨 Lab 的版本问题放 `shared/version_traps.md`
- 原始笔记放 `notes/`，不作为主教程
- 教程图片放各 Lab 的 `assets/`，原始截图放 `assets/raw/`

---

## 相关链接

- [导航目录](SUMMARY.md)
