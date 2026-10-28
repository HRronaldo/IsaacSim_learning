# Lab19 M1：遥操作数据采集

> 目标：用键盘或 XR 控制 Franka，完成 10 条 Stack-Cube 人类演示，保存为 HDF5。

---

## 1. 任务

```text
IsaacContrib-Stack-Cube-Franka-IK-Rel
```

目标：把 3 个方块按 **蓝 → 红 → 绿**（从下到上）堆叠。

---

## 2. 键盘控制

没有 XR 设备时使用键盘：

| 按键 | 动作 |
|---|---|
| `K` | 开/合夹爪 |
| `W/S` | 沿 X 移动 |
| `A/D` | 沿 Y 移动 |
| `Q/E` | 沿 Z 移动 |
| `Z/X` | 绕 X 旋转 |
| `T/G` | 绕 Y 旋转 |
| `C/V` | 绕 Z 旋转 |
| `R` | 重置当前演示 |

---

## 3. 采集 10 条演示

Linux 原始命令：

```bash
./isaaclab.sh -p scripts/tools/record_demos.py \
  --task IsaacContrib-Stack-Cube-Franka-IK-Rel \
  --teleop_device keyboard \
  --device cpu \
  --dataset_file /home/ubuntu/Desktop/DLI/19_SMMG/datasets/dataset.hdf5 \
  --num_demos 10
```

Windows 适配（Git Bash）：

```bash
conda activate isaacsim
cd /e/program/isaac_sim/IsaacLab
./isaaclab.bat -p scripts/tools/record_demos.py \
  --task IsaacContrib-Stack-Cube-Franka-IK-Rel \
  --teleop_device keyboard \
  --device cpu \
  --dataset_file <repo>/IsaacSim_19/19_SMMG/datasets/dataset.hdf5 \
  --num_demos 10
```

PowerShell 等价：

```powershell
cd <ISAACLAB_ROOT>
isaaclab.bat -p scripts/tools/record_demos.py `
  --task IsaacContrib-Stack-Cube-Franka-IK-Rel `
  --teleop_device keyboard `
  --device cpu `
  --dataset_file <ISAAC_19_ROOT>/19_SMMG/datasets/dataset.hdf5 `
  --num_demos 10
```

> 如果 `--device cpu` 报错，改成 `--device cuda:0`；以实际 Isaac Lab 3.0 参数为准。

---

## 4. 采集质量

- 动作平滑、连续，不要频繁停顿
- 尽量走直线到目标
- 每条演示尽量短
- 出错按 `R` 重置，不要录失败轨迹
- 完成堆叠后场景会自动重置

---

## 5. 回放验证

```powershell
isaaclab.bat -p scripts/tools/replay_demos.py `
  --task IsaacContrib-Stack-Cube-Franka-IK-Rel `
  --dataset_file <ISAAC_19_ROOT>/19_SMMG/datasets/dataset.hdf5
```

如果回放成功，说明 HDF5 观察/动作空间正确。

---

## 6. 没有 XR / 不想手采

直接用：

```text
IsaacSim_19\19_SMMG\checkpoints\dataset.hdf5
```

复制到：

```text
IsaacSim_19\19_SMMG\datasets\dataset.hdf5
```

---

## 7. 验证清单

- [ ] Stack-Cube 任务能启动
- [ ] 键盘能控制末端和夹爪
- [ ] 能采集 1 条演示
- [ ] 能回放 1 条演示
- [ ] 采集或准备了 10 条演示

---

## 8. 下一步

- [02 GR00T-Mimic](02_groot_mimic.md)

