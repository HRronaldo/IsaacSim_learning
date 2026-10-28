# Lab19 总览：SMMG / Isaac Lab 模仿学习

> 原始资料：`IsaacSim_19/19_smmg_lab_instructions/lab_instructions/`  
> 主题：使用 Isaac Lab + Cosmos 的合成数据生成与模仿学习。  
> 状态：**M1-M3 已完成**；当前最佳策略为 200 条 3.0 Mimic 数据 + 500 epoch，**4/10 = 40% success**。

---

## 1. 这个 Lab 在教什么

目标：用 **Franka + Stack-Cube** 任务走完一条完整的模仿学习流水线：

```text
遥操作采集 10 条人类演示
        ↓
GR00T-Mimic 子任务标注
        ↓
生成大量合成演示
        ↓
BC-RNN（RoboMimic）训练
        ↓
仿真回放 / 部署策略
```

---

## 2. 三个模块

| 模块 | 内容 | 章节 |
|---|---|---|
| M1 | 使用键盘/XR 遥操作采集数据 | [01 遥操作](01_teleop.md) |
| M2 | GR00T-Mimic 标注与数据生成 | [02 GR00T-Mimic](02_groot_mimic.md) |
| M3 | BC-RNN 模仿学习训练/回放 | [03 BC-RNN](03_bc_rnn.md) |

排错记录：

- [04 Lab19 踩坑记录](04_pitfalls.md)

---

## 3. 前置

- Isaac Sim 6.1 + Isaac Lab 3.0 环境可用
- 能运行 `isaaclab.bat` 或 `isaaclab` 命令
- `isaaclab_teleop` 已 editable 安装（否则 `record_demos.py` 会报 `No module named 'isaaclab_teleop'`）
- `isaaclab_mimic` 已 editable 安装（Mimic 任务需要）
- `robomimic` 0.4.0 已安装（Windows 上用 `--no-deps`，跳过仅 Linux 需要的 `egl_probe`）
- 磁盘预留：生成数据 + 训练日志至少 2-3 GB
- RTX 5080 16GB：Mimic 的 `--num_envs` 先从 10 开始

安装命令（当前 `isaacsim` 环境）：

```bash
python -m pip install -e <ISAACLAB_ROOT>/source/isaaclab_teleop --no-deps
python -m pip install -e <ISAACLAB_ROOT>/source/isaaclab_mimic --no-deps
```

---

## 4. 已有资产

| 文件 | 内容 |
|---|---|
| `IsaacSim_19/19_SMMG/checkpoints/dataset.hdf5` | 10 条人类演示 |
| `IsaacSim_19/19_SMMG/checkpoints/annotated_dataset.hdf5` | 已标注数据 |
| `IsaacSim_19/19_SMMG/checkpoints/generated_dataset.hdf5` | 约 1000 条生成数据（195MB） |
| `IsaacSim_19/19_SMMG/checkpoints/model_epoch_1200.pth` | 预训练 BC-RNN |
| `IsaacSim_19/19_SMMG/checkpoints/model_epoch_2000.pth` | 预训练 BC-RNN |
| `IsaacSim_19/19_SMMG/datasets/dataset.hdf5` | 本地练习数据 |

> 可以先用自己的小数据跑通流程，再用官方 1000 条数据/预训练模型做完整结果。

---

## 5. 6.1 / Windows 适配

Lab19 资料默认 Linux：

```text
./isaaclab.sh -p scripts/...
```

Windows 下替换为：

```powershell
isaaclab.bat -p scripts/...
```

路径也要换成本地路径，例如：

```text
<ISAAC_19_ROOT>/19_SMMG/datasets/
<ISAAC_19_ROOT>/19_SMMG/training_logs/
```

> `<ISAAC_19_ROOT>` 指 NVIDIA GTC Lab19 官方课程目录（即 `19_SMMG/` 的上一级）。原始数据集与训练日志体积大且属第三方材料，**不随本仓库分发**，请按官方流程自行生成。

任务名：

```text
IsaacContrib-Stack-Cube-Franka-IK-Rel          # 基础任务（3.0 / tasks 18.0.1）
Isaac-Stack-Cube-Franka-IK-Rel-Mimic-v0        # Mimic 任务
```

> **旧 Lab19 的 `Isaac-Stack-Cube-Franka-IK-Rel-v0` 在 3.0 没有注册**，必须换成 `IsaacContrib-Stack-Cube-Franka-IK-Rel`。  
> `isaaclab_mimic` 已以 editable 方式安装到当前 `isaacsim` 环境；Mimic 任务需要先 `import isaaclab_mimic.envs` 才会注册。  
> `robomimic 0.4.0` 已安装；Windows 上用 `--no-deps`，并补 `termcolor` / `imageio-ffmpeg`。  
> 自动录制使用 `work/lab19/play_record.py`，输出 `work/lab19/videos/stack_0000.mp4`。

---

## 6. 完成标准

- [x] 能启动 Stack-Cube 任务
- [x] 能采集/回放 10 条演示（本次手动 1 条 + 官方 10 条）
- [x] 能标注并生成 Mimic 数据（10 条 + 200 条）
- [x] 能训练/加载 BC-RNN（500 epoch，`model_epoch_500.pth`）
- [x] 能在仿真中成功堆叠 3 个方块（10 次 rollout 成功 4 次，40%）
- [x] 记录 Lab19 踩坑
- [x] 自动录制 `work/lab19/videos/stack_0000.mp4`

---

## 7. 下一步

- [01 遥操作](01_teleop.md)
- [Lab16 总览](../lab16/00_overview.md)

