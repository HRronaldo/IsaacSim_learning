# Lab19 M2：GR00T-Mimic 数据生成

> 目标：把 10 条人类演示标注成子任务，再用 GR00T-Mimic 扩展成大量合成演示。

---

## 1. 为什么要分两段

- **标注**：把完整演示切成“抓红块”“放到蓝块上”等子任务
- **生成**：Mimic 把子任务序列变换到新的物体/机器人初始条件，生成新轨迹

对象引用要一致：

- 抓红块：对象 = 红块
- 放到蓝块上：对象 = 蓝块

---

## 2. 自动标注

Linux：

```bash
./isaaclab.sh -p scripts/imitation_learning/isaaclab_mimic/annotate_demos.py \
  --input_file /home/ubuntu/Desktop/DLI/19_SMMG/datasets/dataset.hdf5 \
  --output_file /home/ubuntu/Desktop/DLI/19_SMMG/datasets/annotated_dataset.hdf5 \
  --task Isaac-Stack-Cube-Franka-IK-Rel-Mimic-v0 \
  --auto
```

Windows：

```powershell
isaaclab.bat -p scripts/imitation_learning/isaaclab_mimic/annotate_demos.py `
  --input_file E:\programee\IsaacSim_learning\IsaacSim_19\19_SMMG\datasets\dataset.hdf5 `
  --output_file E:\programee\IsaacSim_learning\IsaacSim_19\19_SMMG\datasets\annotated_dataset.hdf5 `
  --task Isaac-Stack-Cube-Franka-IK-Rel-Mimic-v0 `
  --auto
```

> 复杂任务去掉 `--auto`，用空格键手动标子任务。

---

## 3. 小规模生成

先 10 个环境 / 10 条 trial：

```powershell
isaaclab.bat -p scripts/imitation_learning/isaaclab_mimic/generate_dataset.py `
  --input_file E:\programee\IsaacSim_learning\IsaacSim_19\19_SMMG\datasets\annotated_dataset.hdf5 `
  --output_file E:\programee\IsaacSim_learning\IsaacSim_19\19_SMMG\datasets\generated_dataset_small.hdf5 `
  --num_envs 10 `
  --generation_num_trials 10
```

回放：

```powershell
isaaclab.bat -p scripts/tools/replay_demos.py `
  --task IsaacContrib-Stack-Cube-Franka-IK-Rel `
  --dataset_file E:\programee\IsaacSim_learning\IsaacSim_19\19_SMMG\datasets\generated_dataset_small.hdf5
```

---

## 4. 大规模生成

RTX 5080 16GB 不要直接上 `400`，先试 `50`：

```powershell
isaaclab.bat -p scripts/imitation_learning/isaaclab_mimic/generate_dataset.py `
  --input_file E:\programee\IsaacSim_learning\IsaacSim_19\19_SMMG\datasets\annotated_dataset.hdf5 `
  --output_file E:\programee\IsaacSim_learning\IsaacSim_19\19_SMMG\datasets\generated_dataset.hdf5 `
  --num_envs 50 `
  --generation_num_trials 200 `
  --headless
```

如果显存/速度不够：

- 降 `num_envs`
- 分批生成
- 直接用官方 `checkpoints/generated_dataset.hdf5`（约 1000 条）

---

## 5. 预生成数据

```text
IsaacSim_19\19_SMMG\checkpoints\generated_dataset.hdf5
```

复制到：

```text
IsaacSim_19\19_SMMG\datasets\generated_dataset.hdf5
```

### 数据来源与时间戳（本机实测）

| 数据 | 数量 | 路径 | 时间 |
|---|---:|---|---|
| 官方人类演示 | 10 demos / 3901 frames | `datasets/dataset.hdf5` | 2026-04-27（复制时间） |
| 官方原始 checkpoint | 10 demos / 3901 frames | `checkpoints/dataset.hdf5` | 2025-06-09 15:04:38 |
| 本次标注结果 | 10 demos / 2163 frames | `datasets/annotated_m1.hdf5` | 2026-10-26 15:47:00 |
| 本次 Mimic 小规模 | 10 successful demos / 2365 frames | `datasets/generated_m1_small.hdf5` | 2026-10-26 15:48:49 |
| 官方预生成 Mimic | **1003 demos / 241790 frames** | `checkpoints/generated_dataset.hdf5` | 2025-06-09 15:04:40 |

> 关键区别：**1003 条是官方预生成的，不是这次会话里生成的**。  
> 本次会话只生成了 10 条成功 demo（10/28 次尝试，35.7% 成功率）。  
> 训练 100/2000 epoch 使用的是官方 1003 条；10 条小数据只用于 smoke training。

---

## 6. 验证清单

- [ ] `annotate_demos.py` 成功生成 annotated HDF5
- [ ] 小规模生成 10 条成功
- [ ] 能回放生成数据
- [ ] 决定使用自己生成的数据或官方 1000 条数据

---

## 7. 下一步

- [03 BC-RNN 训练](03_bc_rnn.md)

