# Day 1 速查卡：环境 + URDF/USD 基础（Lab 16 模块 1）

> 目标（30-60 分钟）：跑起 Isaac Sim GUI，理解 URDF/USD 的最基本概念，产出第一张截图。
> 教程入口：E:/programee/IsaacSim_learning/IsaacSim_16/16_usd_robo_lab_instructions/gtc25-16-usd-for-robotics/index.html

---

## 1. 打开环境（Git Bash）

`~/.bashrc` 已加好 conda 初始化，新开 Git Bash 直接：

```bash
conda activate isaacsim
isaacsim
```

跑 Isaac Lab 脚本时（`isaaclab` 已在 PATH）：

```bash
isaaclab -p E:/program/isaac_sim/IsaacLab/scripts/tools/record_demos.py --help
```

> `env.sh` 不是必需品，只是可选的“激活 + 目录快捷命令”脚本：
> `source /e/programee/IsaacSim_learning/work/env.sh`
> 备用 PowerShell：`. E:\programee\IsaacSim_learning\work\env.ps1`
> 已实测：`conda activate isaacsim` 后 python 3.12.14、isaacsim/isaaclab 均在 PATH。

- 首次启动要编译 shader，等 2-5 分钟，直到终端/日志出现 **“Isaac Sim Full App is loaded”** 再操作。
- 如果窗口先出来了但没看到这行字，继续等。

## 2. 读教程（只读模块 1 的三页）

用浏览器打开上面的 index.html，只看：

- URDF 概述（01_Anatomy-of-a-Robot-Asset-Structure/0102_URDF）
- USD 概述（0103_USD）
- 机器人结构回顾（0104_Review）

看点：
- URDF 用 **Link（连杆/刚体）** 和 **Joint（关节）** 描述机器人；
- USD 用 **Prim** 搭场景，机器人在 Isaac Sim 里是 **Articulation（刚体+关节树）**；
- 机器人资源推荐结构：`/UR/ur.usd` 组合 `configuration/ur_base.usd` + `ur_physics.usd` + `ur_sensors.usd`。

## 3. GUI 里动手

1. **File > New** 新建空场景。
2. 加地面：**Create > Physics > Ground Plane**（或 Create > Physics > Ground Plane）。
3. 加立方体：**Create > Shape > Cube**。
4. 在 Property 面板给它加 **Rigid Body** 和 **Collider**。
5. 点 **Play**，看立方体受重力下落。
6. **File > Open**，打开：
   `E:/programee/IsaacSim_learning/IsaacSim_16/16_USD_FOR_ROBOTICS/joint_types.usd`
7. 在 Stage 面板逐个点开 `/World` 下的关节，对照本文末尾“答案参考”。

## 4. 本机 joint_types.usd 实际内容（答案参考，别偷看，先自己找）

文件默认 Prim = `/World`，upAxis=Z，共 14 个关节 prim：

| Stage 路径 | USD 类型 | 含义 |
|---|---|---|
| /World/Piston/PrismaticJoint | PhysicsPrismaticJoint | 直线（移动）关节 |
| /World/Lever/RevoluteJoint | PhysicsRevoluteJoint | 带限制旋转关节 |
| /World/Spherical/SphericalJoint | PhysicsSphericalJoint | 球关节（3 旋转） |
| /World/Distance/DistanceJoint | PhysicsDistanceJoint | 拉绳式距离关节 |
| /World/D6/D6Joint | PhysicsJoint | 六自由度可配置关节 |
| /World/Gear/Gear_A/RevoluteJoint | PhysicsRevoluteJoint | 齿轮 A |
| /World/Gear/Gear_B/RevoluteJoint | PhysicsRevoluteJoint | 齿轮 B |
| /World/Gear/GearJoint | PhysxPhysicsGearJoint | 齿轮耦合（A 转带动 B） |
| /World/RackAndPinion/RackAndPinionJoint | PhysxPhysicsRackAndPinionJoint | 旋转↔平移转换 |
| /World/RackAndPinion/Gear/RevoluteJoint | PhysicsRevoluteJoint | 齿轮齿条里的齿轮 |
| /World/RackAndPinion/Rack/PrismaticJoint | PhysicsPrismaticJoint | 齿轮齿条里的齿条 |
| /World/Fixed/FixedJoint | PhysicsFixedJoint | 固定关节 |
| /World/Mimic/RevoluteJoint | PhysicsRevoluteJoint | 主动关节 |
| /World/Mimic/Lower_Arm/RevoluteJoint | PhysicsRevoluteJoint | 随动（Mimic）关节 |

## 5. 发给我的内容

1. 一张截图：Stage 面板 + 视口（能看到 joint_types.usd 的 Stage 树）。
2. 三个问题的答案（写进 docs/notes/lab16_m1.md，用模板）：
   - URDF 的 Link / Joint 对应 USD 里的什么？
   - Layer / Reference 解决什么问题？
   - joint_types.usd 里你看到了哪些关节类型？

