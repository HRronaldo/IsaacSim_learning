# 00 环境搭建：Isaac Sim 6.1 + Isaac Lab 3.0

> 目标：在一台 Windows 11 + RTX 5080 机器上，建立可复现的 Isaac Sim / Isaac Lab 学习环境。  
> 本文是后续 Lab16、Lab19 的共同前置。

---

## 1. 版本基线

| 项目 | 版本 |
|---|---|
| Isaac Sim | **6.1.0.0** |
| Isaac Lab | **3.0.0**（pip 包 17.0.1） |
| PyTorch | 2.11.0+cu128 |
| Python | 3.12.14 |
| OS | Windows 11 |
| GPU | NVIDIA RTX 5080 16GB |
| Shell | Git Bash（主）+ PowerShell（备用） |

> 官方文档认准 `/6.1.0/`：`https://docs.isaacsim.omniverse.nvidia.com/6.1.0/`  
> 不要用 `/latest/`，会跳到 6.2.0。

---

## 2. 目录约定

```text
<repo>/                         GitHub 仓库（公开部分）
├─ docs/                 教程与知识库（GitBook 渲染这一层）
└─ work/                 实际资产、URDF、USD、备份

以下为本地课程资料，体积大或涉及第三方版权，不随仓库分发：
├─ IsaacSim_16/          GTC Lab16 原始资料
├─ IsaacSim_18/          Isaac ROS（暂时跳过）
├─ IsaacSim_19/          SMMG（下一阶段）
└─ instructions_sil/     MEGA（ROS/SIL，暂时跳过）
```

> **占位符约定**（教程中出现的尖括号路径请按自己的实际位置替换）：
> - `<repo>` — 本仓库根目录，例如 `D:\code\IsaacSim_learning`
> - `<ISAAC_16_ROOT>` / `<ISAAC_19_ROOT>` — 分别指本地的 `IsaacSim_16/`、`IsaacSim_19/` 目录（NVIDIA 官方课程资料，不随仓库分发）
> - `<ISAACLAB_ROOT>` — Isaac Lab 安装目录，例如 `<你的安装位置>\IsaacLab`

---

## 3. 启动 Isaac Sim

Git Bash：

```bash
conda activate isaacsim
isaacsim
```

首次启动会编译 shader，等待终端/日志出现：

```text
Isaac Sim Full App is loaded
```

再开始操作。

可选的环境脚本：

```bash
source /e/programee/IsaacSim_learning/work/env.sh
```

PowerShell 备用：

```powershell
. .\work\env.ps1
```

> `env.sh` / `env.ps1` 不是必需品，只是激活环境 + 目录快捷命令。

---

## 4. 验证 CUDA 和 Isaac Lab

```bash
python -c "import torch; print(torch.__version__); print(torch.cuda.is_available())"
```

应看到：

- PyTorch `2.11.0+cu128`
- `True`

验证 Isaac Lab：

```bash
isaaclab.bat --help
```

如果 Isaac Lab 是通过 pip 安装的，入口可能是 `isaaclab`，不是 `isaaclab.bat`；先用 `where isaaclab` / `where isaaclab.bat` 确认。

---

## 5. Headless 冒烟测试

在 `work/` 下运行一个最小的 headless 脚本，确认：

- SimulationApp 能启动
- PhysX 扩展能加载
- GPU 被识别
- 不弹 GUI

参考脚本：

```python
from isaacsim import SimulationApp

app = SimulationApp({"headless": True})
print("SMOKE_APP_OK")
app.close()
```

运行：

```bash
python work/smoke_test.py
```

---

## 6. 常见问题

| 现象 | 原因 | 解决 |
|---|---|---|
| `conda` 命令找不到 | Git Bash 没初始化 conda | 在 `~/.bashrc` 加 `source /d/tools/anaconda3/etc/profile.d/conda.sh` |
| 启动很慢 | 首次编译 shader | 等 2-5 分钟，直到 `Isaac Sim Full App is loaded` |
| CUDA 不可用 | PyTorch 不是 cu128 版 | 检查 `torch.__version__` 是否含 `+cu128` |
| Isaac Lab 命令找不到 | pip 入口名不是 `isaaclab.bat` | `where isaaclab` / `where isaaclab.bat` |
| 在线 HDRI 报错 | 网络资源加载失败 | 不影响物理，可忽略 |

---

## 7. 验证清单

- [x] Isaac Sim 6.1.0.0 能启动
- [x] `torch.cuda.is_available() == True`
- [x] Isaac Lab 3.0.0 入口可用
- [x] headless 冒烟脚本打印 `SMOKE_APP_OK`
- [x] Git Bash 能 `conda activate isaacsim`

---

## 8. 下一步

- [01 Isaac Sim 基础](01_isaac_sim_basics.md)
- [Lab16 总览](../lab16/README.md)
