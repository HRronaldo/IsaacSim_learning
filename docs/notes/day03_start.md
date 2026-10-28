# Day 3 速查卡：导入 Robotiq 2F-140 夹爪（Lab 16 模块 2b）

> 目标：把夹爪 URDF 转成 USD，播放时夹爪不塌陷，并对照预期关节参数。
> 教程页：`.../02_Import-robots-using-Importer/0202_Import-2F-140.html`
> 注意：教程里写的文件名是 `2F-140.urdf`，本机真实文件名是 `robotiq_2f_140.urdf`。

---

## 1. 操作步骤

1. File > New
2. File > Import
3. 选择文件：
   `<ISAAC_16_ROOT>/16_USD_FOR_ROBOTICS/robotiq/robotiq_2f_140_gripper_visualization/2f_140/urdf/robotiq_2f_140.urdf`
4. 导入设置：
   - USD 输出目录：`work/lab16/robotiq_2f_140`
   - `finger_joint` 的 Natural Frequency 设 **300**
   - 其余目标（Mimic）关节的 Natural Frequency 设 **2500**
   - 滚动到列表最底部，确保没有漏掉任何关节
5. 点 Import
6. 打开 `work/lab16/robotiq_2f_140/robotiq_2f_140.usd`；点 Play，确认夹爪保持在原位、不塌陷

## 2. 答案键：这个 URDF 里到底有什么（我已预分析）

- 机器人名：`robotiq_arg2f_140_model`；共 **11 个 link、10 个 joint**
- **1 个主动关节**：`finger_joint`（revolute，0 ~ 0.7 rad ≈ 0 ~ 40.107°，effort 1000）
- **5 个随动/Mimic 关节**（跟随 finger_joint）：

| 关节名 | Mimic 关系 | 限位（rad） |
|---|---|---|
| left_inner_knuckle_joint | finger_joint × -1 | -0.8757 ~ 0.8757 |
| left_inner_finger_joint | finger_joint × +1 | -0.8757 ~ 0.8757 |
| right_outer_knuckle_joint | finger_joint × -1 | -0.725 ~ 0.725 |
| right_inner_knuckle_joint | finger_joint × -1 | -0.8757 ~ 0.8757 |
| right_inner_finger_joint | finger_joint × +1 | -0.8757 ~ 0.8757 |

- 其余 4 个为 fixed：left_outer_finger_joint、left_inner_finger_pad_joint、right_outer_finger_joint、right_inner_finger_pad_joint
- 根 prim 名通常是 `/robotiq_arg2f_140_model`；指垫 link：left/right_inner_finger_pad

## 3. 与教程“预期关节参数表”的对应关系

教程表里的 Finger Joint：Lower 0 / Upper 40.107 / Stiffness 37.51957 / Damping 0.00125 / Max Force 1000。
- 40.107 是 0.7 rad 换算成角度；Max Force 1000 与 URDF 的 effort 一致；
- Stiffness/Damping 是 Importer 由 Natural Frequency=300 自动算出来的，不用手填。

## 4. 自检清单

- [ ] 打开 USD 后 Stage 里有 robotiq_arg2f_base_link + 左右手指/指节
- [ ] Play 后夹爪不塌陷、不抖动
- [ ] 选中 finger_joint，Property > Joint 里 Lower/Upper/Gearing/Max Force 与上表一致
- [ ] 截图存 `docs/assets/raw/day03_gripper_*.png`

## 5. 常见问题

- 夹爪塌陷：说明 Mimic 关节 Natural Frequency 没设 2500，重新导入并滚到底部检查所有关节。
- 关节参数不对：对照教程底部的“预期关节参数表”逐个核对。

