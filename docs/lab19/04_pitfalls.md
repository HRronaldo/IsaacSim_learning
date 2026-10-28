# Lab19 踩坑记录

> 状态：**已实操记录**。  
> 当前基线：200 条 3.0 Mimic 数据 + 500 epoch，回放 4/10 = **40% success**。  
> 自动录制：`work/lab19/play_record.py` → `work/lab19/videos/stack_0000.mp4`。

---

## 1. 已知风险

| 风险 | 现象 | 预案 |
|---|---|---|
| `robomimic` 未安装 | `ModuleNotFoundError: robomimic` | 已装 0.4.0；Windows 安装用 `--no-deps` 跳过 `egl_probe` |
| `termcolor` 缺失 | `ModuleNotFoundError: termcolor` | `pip install termcolor imageio-ffmpeg` |
| `train.py` 报 `unrecognized arguments: --device` | 训练脚本 CLI 不含 AppLauncher 参数 | 去掉 `--device cuda:0`；`play.py` 才支持 `--device` |
| 官方 checkpoint 0% success | 旧 Lab19/4.5 checkpoint 与 3.0 任务/动作空间不完全匹配 | 用 3.0 的 1000 条数据重新训练；不要用官方模型判断链路 |
| 官方 1003 数据训练后仍 0% | 1003 是 2025 年的旧数据，当前 3.0 任务/动作语义可能已变化 | 用 3.0 自己生成的 Mimic 数据训练；不要直接拿旧 1003 当最终数据 |
| `Fatal Python error: init_fs_encoding ... null bytes` | 训练和 play 同时启动/多个 Isaac Lab 进程 | 只保留一个 Isaac Lab 进程；先彻底停止训练，再 play |
| `egl_probe` 构建失败 | `CMake must be installed` | training/play 不需要 `egl_probe`；用 `pip install --no-deps robomimic` |
| 旧任务名 `Isaac-Stack-Cube-Franka-IK-Rel-v0` | `TaskNotFound` | 3.0 用 `IsaacContrib-Stack-Cube-Franka-IK-Rel` |
| `isaaclab_mimic` 未安装 | `ModuleNotFoundError: isaaclab_mimic` | `pip install -e E:\program\isaac_sim\IsaacLab\source\isaaclab_mimic --no-deps` |
| `isaaclab_teleop` 未安装 | `ModuleNotFoundError: isaaclab_teleop`，来自 `isaaclab.devices.openxr` | `pip install -e E:\program\isaac_sim\IsaacLab\source\isaaclab_teleop --no-deps` |
| `isaaclab.bat` 选到系统 Python 3.13 | 报 “3.12 is required” | 先 `conda activate isaacsim`，确认 `CONDA_PREFIX` |
| Windows 路径 | Linux 命令/路径不识别 | 用 `isaaclab.bat -p`，所有路径改成本地绝对路径 |
| XR 设备不可用 | 无法用 Apple Vision Pro | 用 keyboard，或直接用官方 `dataset.hdf5` |
| `num_envs` 过大 | 显存不足 / 卡死 | 先 10，再 50；不要直接 400 |
| HDF5 路径错误 | replay/annotate 找不到文件 | 统一用 `IsaacSim_19\19_SMMG\datasets\` |
| 任务未注册 | `TaskNotFound` | 确认 Isaac Lab 3.0 里有 Stack-Cube 任务 |
| 生成数据质量差 | 训练不收敛 | 先小规模 replay，检查子任务标注 |
| `--device cpu` 不可用 | 参数报错 | 改 `cuda:0` 或按 3.0 的 CLI 帮助 |
| `play.py` 没有窗口、没有视频 | low-dim policy 不启用相机渲染 | 正常；用 `work/lab19/play_record.py` 自动录制 |
| 任务管理器 GPU 3D 显示 1% | 误以为没用 GPU | 用 `nvidia-smi` 看 CUDA；实测 19% / 3.7GB |
| `moviepy is required` | Isaac Lab 的 video recorder 需要 `moviepy<2` | 安装 `moviepy<2`，并保留 Pillow 12.x |
| Mimic 生成成功率约 39% | 200/507 成功 | 正常；只导出成功轨迹 |
| 200 条 3.0 数据 + 500 epoch | 4/10 = 40% | 当前基线；不是生产级，可继续加数据/epoch |

---

## 2. 记录模板

```markdown
## YYYY-MM-DD · 标题

- 模块：
- 现象：
- 根因：
- 证据：
- 修复：
- 验证：
- 预防：
- 关联：
```

---

## 3. 相关文档

- [Lab19 总览](00_overview.md)
- [Lab19 遥操作](01_teleop.md)
- [Lab19 Mimic](02_groot_mimic.md)
- [Lab19 BC-RNN](03_bc_rnn.md)

