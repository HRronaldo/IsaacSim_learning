# Lab19 M3：BC-RNN 模仿学习训练

> 目标：用生成数据训练 BC-RNN 策略，并在仿真中回放，完成方块堆叠。

---

## 1. 算法

RoboMimic 的 **BC-RNN**：

- 输入：观察（EEF 位姿、夹爪状态、方块位姿等）
- 模型：LSTM + GMM 输出
- 训练：行为克隆（Behavior Cloning）
- 输出：动作序列（delta pose + 夹爪开合）

---

## 2. 安装 robomimic

如果 Isaac Lab 环境里没有：

```powershell
python -m pip install --no-deps "robomimic @ git+https://github.com/ARISE-Initiative/robomimic.git@v0.4.0"
python -m pip install termcolor imageio-ffmpeg
```

Windows 上必须加 `--no-deps`；否则会尝试构建 `egl_probe`，报 `CMake must be installed`。  
训练/回放不需要 `egl_probe`；但 `termcolor` / `imageio-ffmpeg` 需要补。

验证：

```powershell
python -c "import robomimic; print(robomimic.__version__)"
```

> 如果 git 拉取慢，可以先用官方预训练 checkpoint 做回放，再补训练。

---

## 3. 训练

Linux：

```bash
./isaaclab.sh -p scripts/imitation_learning/robomimic/train.py \
  --task IsaacContrib-Stack-Cube-Franka-IK-Rel \
  --algo bc \
  --dataset /home/ubuntu/Desktop/DLI/19_SMMG/datasets/generated_dataset.hdf5 \
  --log_dir /home/ubuntu/Desktop/DLI/19_SMMG/training_logs
```

Windows：

```powershell
isaaclab.bat -p scripts/imitation_learning/robomimic/train.py `
  --task IsaacContrib-Stack-Cube-Franka-IK-Rel `
  --algo bc `
  --dataset <ISAAC_19_ROOT>/19_SMMG/datasets/generated_dataset.hdf5 `
  --log_dir <ISAAC_19_ROOT>/19_SMMG/training_logs
```

默认每 100 epoch 保存一次 checkpoint。

实际路径格式：

```text
training_logs/<task>/<name>/<timestamp>/models/model_epoch_N.pth
```

例如这次 smoke run：

```text
training_logs/IsaacContrib-Stack-Cube-Franka-IK-Rel/smoke_bc_m1/20261026160620/models/model_epoch_10.pth
```

---

## 4. 回放

```powershell
isaaclab.bat -p scripts/imitation_learning/robomimic/play.py `
  --task IsaacContrib-Stack-Cube-Franka-IK-Rel `
  --num_rollouts 10 `
  --checkpoint <ISAAC_19_ROOT>/19_SMMG/training_logs/.../model_epoch_1200.pth `
  --seed 100
```

如果训练太慢，可以先用官方 checkpoint；但注意：  
官方模型来自旧 Lab19/4.5 数据，在 Isaac Lab 3.0 上可能 **0% success**，这不代表训练链路坏了。  
正式验收应以 **3.0 自己训练的 checkpoint** 为准。

### 录制回放视频

`play.py` **不会自动保存视频**，它只打印 trial 结果。  
需要录屏的话：

1. 先启动 `play.py`，用 `--num_rollouts 1`（默认 seed 101 时 trial 0 通常成功）
2. 在 Isaac Sim 窗口按 `Win + Alt + R` 开始 Windows Game Bar 录制
3. 等这一轮结束后再按一次停止
4. 视频默认在：

```text
C:\Users\<用户名>\Videos\Captures
```

也可以用 NVIDIA App / OBS 录制同一个 Isaac Sim 窗口。

### 自动录制（已实现）

本项目提供了：

```text
work/lab19/play_record.py
```

它使用 Isaac Lab 的 `VideoRecorderCfg` + `visualizer:kit`，自动写 mp4。

```bash
./isaaclab.bat -p work/lab19/play_record.py \
  --task IsaacContrib-Stack-Cube-Franka-IK-Rel \
  --checkpoint <ISAAC_19_ROOT>/19_SMMG/training_logs/IsaacContrib-Stack-Cube-Franka-IK-Rel/bc_rnn_m1_3p0/20261027124906/models/model_epoch_500.pth \
  --num_rollouts 1 \
  --horizon 800 \
  --video_dir work/lab19/videos \
  --device cuda:0
```

输出：

```text
work/lab19/videos/stack_0000.mp4
```

本次录制的成功样例：

[查看自动录制视频](assets/stack_0000.mp4)

Windows 上需要 `moviepy<2`，并保留 Isaac Sim 需要的 Pillow 12.x。  
本机实测：`moviepy 1.0.3` + `decorator 5.3.1` + `Pillow 12.3.0` 可以导入并录制，虽然 pip 会提示 moviepy 的 decorator 版本元数据冲突。

```text
IsaacSim_19\19_SMMG\checkpoints\model_epoch_1200.pth
IsaacSim_19\19_SMMG\checkpoints\model_epoch_2000.pth
```

---

## 5. 验收

- [x] 训练脚本能启动
- [x] 有 checkpoint 生成（`bc_rnn_m1_3p0/20261027124906/models/model_epoch_500.pth`）
- [x] 能 `play.py` 回放
- [x] 机器人能成功堆叠 3 个方块（4/10 = 40%）
- [x] 自动录制 `work/lab19/videos/stack_0000.mp4`
- [x] 记录成功率和失败模式（40% baseline）

---

## 6. 下一步

- [04 Lab19 踩坑记录](04_pitfalls.md)
- [Lab16 总结](../lab16/README.md)

