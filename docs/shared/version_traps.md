# 6.1 版本陷阱与跨 Lab 经验

> 本文记录 Isaac Sim 4.5 资料在 6.1 上复现时最容易踩的坑。  
> Lab 相关细节见 `lab16/07_pitfalls.md` 和 `lab19/04_pitfalls.md`。

---

## 1. 文档版本

- 认准 `https://docs.isaacsim.omniverse.nvidia.com/6.1.0/`
- 不要用 `/latest/`，会跳到 6.2.0
- 本教程基线：Isaac Sim 6.1.0.0 + Isaac Lab 3.0.0

---

## 2. NewtonMimicAPI vs PhysxMimicJointAPI

6.1 的 URDF Importer 主要写：

```text
NewtonMimicAPI
```

4.5 的导入器会写：

```text
PhysxMimicJointAPI
```

如果使用 **PhysX 后端**，只写 NewtonMimic 的 mimic 关节不会形成约束，Play 后会塌。

处理原则：

- PhysX 项目：显式补 `PhysxMimicJointAPI:rotX`
- 不要同时保留 `NewtonMimicAPI` 和 `PhysxMimicJointAPI`
- 保存前删除 NewtonMimic，避免 Save segfault

---

## 3. Physx_Loop 不是 2F-140 的通用解

6.1 官方 Tutorial 10 的 **Physx_Loop** 主要面向 **2F-85**：

- 把 inner knuckle 排除出 articulation
- 只给 inner finger 加柔性 Drive

2F-140 的黑色支架就是 `inner_knuckle`，不能这样排除。  
2F-140 最终使用 **5 关节 PhysxMimic**：

| 关节 | gearing |
|---|---:|
| left_inner_knuckle | +1 |
| right_inner_knuckle | +1 |
| right_outer_knuckle | +1 |
| left_inner_finger | -1 |
| right_inner_finger | -1 |

- Natural Frequency `2500`
- Damping Ratio `0.005`
- mimic 关节 **无 Drive**
- 全部 `excludeFromArticulation = False`

---

## 4. URDF multiplier 不能直接抄

URDF 里写的是：

```text
inner_knuckle: -1
inner_finger: +1
```

但导入成 USD 后 joint frame/axis 可能翻转，PhysxMimic 实际要写：

```text
inner_knuckle: +1
inner_finger: -1
```

**以官方完成版资产 / 实际 joint frame 为准，不要只看 URDF。**

---

## 5. Physics Variant 必须显式选

导入后的机器人可能有：

- `mujoco`
- `physics`
- `physx`
- `none`

做 PhysX 仿真时，根 prim 的 **Variants > Physics** 必须是 `physx`。  
否则可能出现：

- 关节树为空
- Drive 不生效
- Play 软塌
- 夹爪没有约束

---

## 6. 旧 4.5 资产

Lab16 的仓库/夹爪资料是 4.5 的，静态 USD 可以在 6.1 打开；但要注意：

- 远程资产 URL 可能慢/失败
- 旧资产的 PhysX 配置不一定适配 6.1
- 旧资产的关节/夹爪拓扑要用 6.1 的方式重新验证

---

## 7. 视觉正确 ≠ 物理正确

Lab16 M5 的真实教训：

- 机器人看起来在蓝色架子上
- 但底座碰撞体和支架顶面重叠了 3.7cm
- GUI Play 后整机被接触冲量弹飞

必须检查：

- `base` 包围盒
- 支架顶面 Z
- `base_fixed_joint.localPos0`

最终高度：`Z = 1.21913`，底座与支架约 5mm 间隙。

---

## 8. 排查顺序

遇到“Play 后不对”时，按这个顺序：

1. Physics Variant 是否 `physx`
2. 关节是否在 articulation 里
3. Drive 是否存在
4. Mimic 是否存在且 gearing 正确
5. 是否有碰撞体互相插入
6. 是否有 `Invalid PhysX transform` / bounding box 超限
7. 最后才怀疑 IK / 控制器

---

## 9. 相关文档

- [Lab16 排错记录](../lab16/07_pitfalls.md)
- [Lab16 2F-140 夹爪](../lab16/03_robotiq_gripper.md)
- [Lab16 组装](../lab16/04_ur10e_gripper_assembly.md)
- [Lab16 仓库场景](../lab16/05_warehouse_scene.md)
