# Lab19 工作目录

> Lab19 SMMG：Franka Stack-Cube 遥操作 → Mimic → BC-RNN。  
> 教程见 `docs/lab19/`；阶段收尾见 `docs/99_course_closeout.md`。

---

## 数据

| 文件 | 说明 |
|---|---|
| `IsaacSim_19/19_SMMG/datasets/dataset.hdf5` | 官方 10 条人类演示 |
| `IsaacSim_19/19_SMMG/datasets/annotated_m1.hdf5` | 本次 10 条标注 |
| `IsaacSim_19/19_SMMG/datasets/generated_m1_small.hdf5` | 本次 10 条 Mimic 成功数据 |
| `IsaacSim_19/19_SMMG/datasets/generated_m1_200.hdf5` | 本次 200 条 Mimic 成功数据 |
| `IsaacSim_19/19_SMMG/checkpoints/generated_dataset.hdf5` | 官方 2025 年旧 1003 条数据 |

---

## 训练

| 实验 | 数据 | epoch | 结果 |
|---|---|---:|---|
| `smoke_bc_m1` | 10 条本次 Mimic | 10 | 0/10，仅验证链路 |
| `bc_rnn_m1_full` | 官方 1003 条旧数据 | 100/1120 | 0/10，旧数据不匹配 |
| `bc_rnn_m1_3p0` | 本次 200 条 Mimic | 500 | **4/10，40%** |

最佳模型：

```text
IsaacSim_19/19_SMMG/training_logs/IsaacContrib-Stack-Cube-Franka-IK-Rel/bc_rnn_m1_3p0/20261027124906/models/model_epoch_500.pth
```

---

## 自动录制

脚本：

```text
work/lab19/play_record.py
```

输出：

```text
work/lab19/videos/stack_0000.mp4
```

用法：

```bash
./isaaclab.bat -p E:/programee/IsaacSim_learning/work/lab19/play_record.py \
  --task IsaacContrib-Stack-Cube-Franka-IK-Rel \
  --checkpoint E:/programee/IsaacSim_learning/IsaacSim_19/19_SMMG/training_logs/IsaacContrib-Stack-Cube-Franka-IK-Rel/bc_rnn_m1_3p0/20261027124906/models/model_epoch_500.pth \
  --num_rollouts 1 \
  --horizon 800 \
  --video_dir E:/programee/IsaacSim_learning/work/lab19/videos \
  --device cuda:0
```

---

## 说明

- `play.py` 默认不渲染视频，low-dim policy 甚至不会创建可见窗口。
- 自动录制使用 Isaac Lab 的 `VideoRecorderCfg` + `visualizer:kit`。
- Windows 需要 `moviepy<2`，并保留 Isaac Sim 需要的 Pillow 12.x。
