# 99 入门教程收尾

> 状态：**入门教程阶段到此告一段落。**  
> 完成范围：Lab16 M1-M6 + Lab19 M1-M3。  
> 已知限制：Lab19 当前策略为 **4/10 = 40% success baseline**，不是生产级策略。  
> 可选后续：Capstone、更高成功率训练、ROS/MEGA（当前跳过）。

---

## 1. 完成范围

| 阶段 | 内容 | 状态 |
|---|---|---|
| Lab16 M1 | 机器人资产结构 | 完成 |
| Lab16 M2 | UR10e 导入 + Gain Tuner | 完成 |
| Lab16 M3 | Robotiq 2F-140 闭链夹爪 | 完成 |
| Lab16 M4 | UR10e + 夹爪组装 | 完成 |
| Lab16 M5 | 仓库训练场景 | 完成 |
| Lab16 M6 | Jetbot 资产优化 | 完成 |
| Lab19 M1 | 键盘遥操作数据采集 | 完成 |
| Lab19 M2 | GR00T-Mimic 标注与生成 | 完成 |
| Lab19 M3 | BC-RNN 训练、回放、自动录制 | 完成（40% baseline） |

已跳过：

- Lab18 Isaac ROS
- `instructions_sil` MEGA / SIL

---

## 2. 核心产物

### Lab16

```text
work/lab16/ur10_1/ur10_with_gripper.usda
work/lab16/robotiq_2f_140/robotiq_2f_140.usda
work/lab16/warehouse.usda
work/lab16/jetbot/Jetbot_Optimized/jetbot_m6_merged.usd
work/lab16/jetbot/Jetbot_Optimized/jetbot_m6_instanced.usd
work/lab16/jetbot/Jetbot_physics/jetbot_m6_physics.usd
```

### Lab19

```text
IsaacSim_19/19_SMMG/datasets/annotated_m1.hdf5
IsaacSim_19/19_SMMG/datasets/generated_m1_small.hdf5
IsaacSim_19/19_SMMG/datasets/generated_m1_200.hdf5
IsaacSim_19/19_SMMG/training_logs/IsaacContrib-Stack-Cube-Franka-IK-Rel/bc_rnn_m1_3p0/20261027124906/models/model_epoch_500.pth
work/lab19/play_record.py
work/lab19/videos/stack_0000.mp4
work/lab19/README.md
```

成功样例视频：

[stack_0000.mp4](lab19/assets/stack_0000.mp4)

---

## 3. 验收结果

### Lab16

- UR10e + 2F-140 组装完成
- 夹爪 5 关节 PhysxMimic：`2500 Hz / 0.005`，gearing `+1/+1/+1/-1/-1`
- 仓库 Play 稳定
- 机器人高度 `Z=1.21913`，与支架约 5mm 间隙
- Jetbot M6：Mesh `8→3`，Instanceable `558`，Collider `4→7`

### Lab19

```text
任务：IsaacContrib-Stack-Cube-Franka-IK-Rel
数据：200 条 3.0 Mimic 成功数据
训练：BC-RNN 500 epoch
回放：4/10 = 40% success
视频：work/lab19/videos/stack_0000.mp4
```

Mimic 数据生成：

- 小规模 10 条：10/28，35.7%
- 200 条规模：200/507，39.4%

---

## 4. 已知限制

1. **Lab19 只有 40% success**  
   这是可演示的 baseline，不是生产级策略。  
   要提升，应该增加 3.0 Mimic 数据（1000 条左右）并训练 1200-2000 epoch。

2. **官方 2025 年 1003 条数据不适用于 3.0**  
   官方数据训练和官方 checkpoint 在 3.0 上都是 0%。  
   当前有效路线是：3.0 自己标注 + 自己生成 + 自己训练。

3. **Capstone 未做**  
   Capstone 是后续可选项目，不属于本次入门教程的完成条件。

---

## 5. 复现路径

### 环境

- Isaac Sim 6.1.0.0
- Isaac Lab 3.0.0
- Python 3.12.14
- RTX 5080 16GB
- Git Bash + conda `isaacsim`

详见：

- [00 环境搭建](shared/README.md)
- [01 Isaac Sim 基础](shared/01_isaac_sim_basics.md)

### Lab16

- [总览](lab16/README.md)
- [资产结构](lab16/01_asset_structure.md)
- [UR10e 导入](lab16/02_ur10e_import_gain_tuner.md)
- [2F-140 夹爪](lab16/03_robotiq_gripper.md)
- [组装](lab16/04_ur10e_gripper_assembly.md)
- [仓库场景](lab16/05_warehouse_scene.md)
- [资产优化](lab16/06_asset_optimization.md)
- [踩坑记录](lab16/07_pitfalls.md)

### Lab19

- [总览](lab19/README.md)
- [遥操作](lab19/01_teleop.md)
- [Mimic](lab19/02_groot_mimic.md)
- [BC-RNN](lab19/03_bc_rnn.md)
- [踩坑记录](lab19/04_pitfalls.md)

---

## 6. 最重要的经验

1. **URDF → USD 不是版本无关的**  
   4.5 的 PhysxMimic 和 6.1 的 NewtonMimic 行为不同。

2. **2F-140 是闭链，不是串行 IK**  
   Physx_Loop 适合 2F-85；2F-140 要用 5 关节 PhysxMimic。

3. **URDF multiplier 不能直接当 PhysxMimic gearing**  
   导入后的 joint frame 可能翻转。

4. **视觉在架子上 ≠ 物理在架子上**  
   底座和支架碰撞体重叠会让整机飞走；要检查包围盒。

5. **旧数据和旧 checkpoint 不能直接跨版本使用**  
   官方 2025 年 1003 条数据在 3.0 上是 0%。

6. **训练慢不等于 GPU 没用**  
   Windows 任务管理器的 3D 占用不代表 CUDA；用 `nvidia-smi` 看。

7. **low-dim 策略默认不开窗口**  
   没有 camera sensor 就不会创建可见视口；自动录制要用 `VideoRecorderCfg`。

---

## 7. 可选后续

如果以后继续，不要从“重学入门”开始，直接做以下之一：

### A. 把 Lab19 做到更高成功率

```text
3.0 生成 1000 条 Mimic 数据
→ BC-RNN 1200-2000 epoch
→ 20-50 次 rollout 评估
```

### B. Capstone A：Franka 视觉模仿学习

任务：

```text
IsaacContrib-Stack-Cube-Franka-IK-Rel-Visuomotor
```

### C. Capstone B：UR10e + 2F-140 进入 Isaac Lab

把 Lab16 的资产注册成 Isaac Lab 任务，做 reach / pick-place。

### D. ROS / MEGA

需要时再回到 Lab18 + MEGA，当前跳过。

---

## 8. 收尾声明

本次入门教程覆盖：

```text
Isaac Sim 基础
→ URDF/USD 资产
→ 机器人导入与组装
→ 场景与物理
→ 资产优化
→ Isaac Lab 遥操作
→ Mimic 数据生成
→ BC-RNN 训练与回放
```

**教程到这里告一段落。**  
后续的 Capstone 和更高成功率训练属于进阶项目，不再是入门教程的遗留问题。
