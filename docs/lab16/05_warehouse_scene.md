# Lab16 M5：仓库训练场景

> 目标：把 UR10e + 2F-140 放进仓库场景，固定基座，验证夹爪开合和整机物理稳定性。

---

## 1. 场景组成

`work/lab16/warehouse.usda`：

- `small_warehouse_digital_twin`
- `sortbot_housing`
- `robot`（引用 `ur10_with_gripper.usda`）
- `PhysicsScene`

机器人最终位置：

```text
translate = (-3.9823936, -4.7185181, 1.21913)
```

`base_fixed_joint.localPos0` 同步：

```text
(-3.9823935, -4.7185183, 1.21913)
```

---

## 2. 关键修复：底座与支架不能重叠

一开始机器人放在 `Z=1.17693`，视觉上“在架子上”，但：

```text
机器人 base 底板 min Z = 1.1769
sortbot_housing 顶面 max Z = 1.2141
重叠 = 3.7 cm
```

GUI Play 后整机被接触冲量弹飞。夹爪本身正常，所以这不是夹爪问题。

最终：

```text
Z = 1.21913
base 底板 min Z ≈ 1.2191
支架顶面 max Z = 1.2141
间隙 ≈ 5 mm
```

> 改机器人高度时，必须同时修改：
> 1. 机器人 `xformOp:translate`
> 2. `base_fixed_joint.localPos0`

---

## 3. 夹爪设置

`Stage > robot > robotiq_2f_140 > Physics > finger_joint`：

| 参数 | 值 |
|---|---:|
| Target Position | `40` 闭合 / `0` 张开 |
| Stiffness | `37.5195656` |
| Damping | `0.001250652` |
| Max Force | `1000` |

夹爪拓扑见 [03 2F-140 夹爪](03_robotiq_gripper.md)。

---

## 4. 验证步骤

1. 打开 `warehouse.usda`
2. 确认机器人底座落在蓝色架子上
3. Play
4. 观察 60 秒：
   - 机器人不飞
   - 夹爪不爆
   - 黑色支架不掉
5. 改 `finger_joint Target`：
   - `0`：张开
   - `40`：闭合
6. 再跑 60 秒

---

## 5. 验收结果

- GUI Play：稳定，机器人留在蓝色架子上
- 夹爪：0/40 开合正常
- headless：3600 步（60s）
  - `finger_joint = 0.7 rad`
  - 最大关节角 `0.7002 rad`
  - 世界位置 Z ≈ `1.2191`
  - 无 `Invalid PhysX transform`

---

## 6. 踩坑

| 现象 | 根因 | 解决 |
|---|---|---|
| Play 后整机飞走 | 底座与支架碰撞体重叠 3.7cm | 抬到 `1.21913`，同步 `base_fixed_joint` |
| 夹爪黑色支架掉 | 用了 2F-85 的 Physx_Loop | 改 5 关节 PhysxMimic，见 03 |
| 夹爪闭合时爆 | gearing 符号反 + 5000 Hz | `+1/+1/+1/-1/-1`，2500 Hz / 0.005 |

完整记录见 [07 踩坑记录](07_pitfalls.md)。

---

## 7. 下一步

- [06 资产优化](06_asset_optimization.md)
- [Lab19 SMMG](../lab19/00_overview.md)
