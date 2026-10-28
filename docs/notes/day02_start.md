# Day 2 速查卡：导入 UR10e（官方 Isaac Sim 6.1 版）

> 目标：把 UR10e 的 URDF 转成 USD，并让 6 个关节稳定地跟随目标位置。
> 官方教程：
> - Import URDF：https://docs.isaacsim.omniverse.nvidia.com/6.1.0/importer_exporter/import_urdf.html
> - Tutorial 6 Setup a Manipulator：https://docs.isaacsim.omniverse.nvidia.com/6.1.0/robot_setup_tutorials/tutorial_import_assemble_manipulator.html
> - Tutorial 11 Tuning Joint Drive Gains：https://docs.isaacsim.omniverse.nvidia.com/6.1.0/robot_setup_tutorials/joint_tuning.html

---

## 0. 为什么不用原始 `urdf/ur10.urdf`

原始 URDF 里写的是相对路径 `meshes/ur10/...`，导入器会按 **URDF 所在目录**（`urdf/`）去拼，变成 `urdf/meshes/...`，但真实网格在上一级 `meshes/`。

我已生成修复版（14 个网格全部存在）：

`work/lab16/ur10/ur10.urdf`

**请导入这个修复版。**

---

## 1. 导入设置（6.1 的 Import options）

| 选项 | 填什么 | 说明 |
|---|---|---|
| **USD Output** | `work/lab16/ur10` | 点 Select File / 文件夹图标选择 |
| **ROS Package List** | 留空 | 修复版用绝对路径，不需要 package:// |
| **Collision From Visuals** | 不勾 | URDF 自带 collision 网格 |
| **Allow Self-Collision** | 先不勾 | 第一遍避免自碰撞抖动；需要时再开 |
| **Robot Type** | **Manipulator** | 官方 Tutorial 6 的设置 |
| **Base Type** | **Fixed** | 把机器人固定到世界；官方 Tutorial 6 的设置 |
| **Add Reference to Stage** | 不勾 | 新建 stage |
| **Merge Mesh** | 不勾 | 官方 Tutorial 12 专门讲资产优化，先保留原始结构 |
| **Debug Mode** | 不勾 | |

点 **Import**。

---

## 2. 导入后：把 Physics Variant 设为 physx

6.1 的资产是**多物理后端结构**，导入后可能没有自动选中物理变体。

1. 在 Stage 选中机器人根 prim（`/ur` 或 `/ur10`）。
2. 右侧 Property 面板找 **Variants**。
3. 把 **Physics** 变体设为 **`physx`**（官方 Tutorial 6 明确要求）。

> 如果没有 Variants 或没有 Physics，跳过；有些简单资产没有这个变体。

---

## 3. 调增益：6.1 用 Gain Tuner，不再有 Natural Frequency

官方明确说明：**6.1 的 URDF 导入器默认把每个关节的 Stiffness / Damping 设为 0**。所以：

- 直接 Play，机器人会**软塌/散架**，这是正常的，不是导入失败。
- 必须用 **Gain Tuner** 调，教程里的 “Natural Frequency 300” 现在在这里。

### 操作

1. **Tools > Robotics > Asset Editors > Gain Tuner**
2. 在 **Robot** 下拉里选中机器人（如果列表为空，说明根 prim 没有 Robot Schema；URDF 导入的资产通常自动有）
3. 会看到 6 个关节的 Stiffness / Damping 都是 0
4. 选中全部 6 个关节，设置：
   - **Natural Frequency = 300**
   - **Damping Ratio = 1.0**
5. 用 **Test Gains / Snap to Limits** 验证；如果 shoulder/elbow 失败，把它们的 **Max Force** 改成 `inf`（Property > Joint > Advanced > Maximum Force，或在 Gain Tuner 的 Advanced Actuator Parameters 里）
6. 保存

### 官方 UR10 参考增益（Tutorial 11）

| Joint | Stiffness | Damping |
|---|---|---|
| shoulder_pan_joint | 500000 | 50 |
| shoulder_lift_joint | 500000 | 50 |
| elbow_joint | 50000 | 50 |
| wrist_1_joint | 500 | 0.5 |
| wrist_2_joint | 500 | 0.5 |
| wrist_3_joint | 50 | 0.0 |

> 先试 Natural Frequency 300 / Damping Ratio 1.0；效果不理想再用这张表。

---

## 4. 验证

1. 点 **Play**：机器人应该保持姿态，不塌。
2. **Tools > Physics > Physics Inspector**，选机器人，点 **refresh**。
3. 拖 **Drive Target**，手臂应稳定跟随。
4. 截图存 `docs/assets/raw/day02_ur10_*.png`。

---

## 5. 答案键：这个 URDF 里有什么（预分析）

- 机器人名：`ur10`；共 **13 个 link、12 个 joint**
- **6 个可动关节（revolute）**：

| 关节名 | 限位（rad） | Effort |
|---|---|---|
| shoulder_pan_joint | -2π ~ +2π | 330 |
| shoulder_lift_joint | -2π ~ +2π | 330 |
| elbow_joint | -π ~ +π | 150 |
| wrist_1_joint | -2π ~ +2π | 56 |
| wrist_2_joint | -2π ~ +2π | 56 |
| wrist_3_joint | -2π ~ +2π | 56 |

- 其余 6 个是 fixed：`base_joint`、`base_link-base_link_inertia`、`wrist_3_link-ft_frame`、`base_link-base_fixed_joint`、`wrist_3-flange`、`flange-tool0`
- 装夹爪时用 `/ur10/wrist_3_link`（或 `tool0`）的 Transform

---

## 6. 常见问题

| 现象 | 原因 | 解决 |
|---|---|---|
| Play 后机器人软塌 | 6.1 导入器默认 gains=0 | 用 Gain Tuner 设 300 Hz / 1.0 |
| Gain Tuner 里看不到机器人 | 根 prim 没有 Robot Schema | 用 URDF 重新导入（会自动加）；或手动加 `IsaacRobotAPI` |
| 机器人不动 | Physics Variant 没选 physx | 选中根 prim，Variants > Physics = physx |
| 看不到网格 | 用了原始 URDF 的相对路径 | 改用 `work/lab16/ur10/ur10.urdf` |
| 输出目录没文件 | USD Output 选成了文件 | 选文件夹 `work/lab16/ur10` |
| 底部 DomeLight texture 报错 | 在线 HDRI 加载失败 | 忽略，不影响物理 |

---

## 7. 英文顺手记

- **Import options** = 导入选项
- **USD Output** = USD 输出目录
- **Robot Type: Manipulator** = 机器人类型：机械臂
- **Base Type: Fixed** = 基座类型：固定
- **Physics Variant** = 物理变体（physx / mujoco）
- **Gain Tuner** = 增益调节器
- **Natural Frequency** = 固有频率
- **Damping Ratio** = 阻尼比
- **Stiffness / Damping** = 刚度 / 阻尼
- **Max Force** = 最大力
- **Snap to Limits** = 到限位测试

