# Lab16 踩坑记录

> 这不是流水账，而是按“现象 → 根因 → 修复 → 验证 → 预防”整理的可检索排错表。  
> 新问题继续往下加，不要删历史记录。

---

## 1. URDF 网格路径错误

- **模块**：M2
- **现象**：URDF 导入后看不到网格，或网格丢失
- **根因**：URDF 里的 `meshes/...` 是相对路径，导入器按 URDF 所在目录解析，找错了一层
- **修复**：生成修复版 URDF，把 mesh 路径改成正确相对/绝对路径
- **验证**：导入后 14 个网格全部存在
- **预防**：导入前先检查 URDF 里所有 `<mesh filename=...>`

---

## 2. `base_link` 不是刚体

- **模块**：M4
- **现象**：`base_fixed_joint` 报 `no bodies defined` 或固定无效
- **根因**：`base_link` 只是 Xform；真正的刚体是 `base_link_inertia`
- **修复**：`base_fixed_joint.body1 = base_link_inertia`，body0 为空（world）
- **验证**：Play 后机器人基座不动
- **预防**：固定机器人前先看 Property 里有没有 `PhysicsRigidBodyAPI`

---

## 3. `tool0` 不是刚体，夹爪固定无效

- **模块**：M4
- **现象**：`gripper_fixed_joint` 不生效，夹爪和手腕脱开
- **根因**：`tool0` 只是 frame，不是 rigid body
- **修复**：`gripper_fixed_joint.body1 = wrist_3_link`
- **验证**：夹爪跟随手腕运动
- **预防**：Fixed Joint 的两端必须都是刚体

---

## 4. 6.1 的 NewtonMimicAPI 不等于 PhysxMimic

- **模块**：M3
- **现象**：2F-140 导入后 Play 夹爪塌陷
- **根因**：6.1 Importer 写 `NewtonMimicAPI`；PhysX 后端不认
- **修复**：显式补 `PhysxMimicJointAPI:rotX`
- **验证**：mimic 关节跟随 `finger_joint`
- **预防**：PhysX 项目不要只依赖 NewtonMimic

---

## 5. 2F-140 不能照搬 2F-85 的 Physx_Loop

- **模块**：M3
- **现象**：夹爪闭合时黑色支架掉落
- **根因**：Physx_Loop 把 `inner_knuckle` 排除出 articulation；2F-140 的黑色支架就是 inner knuckle
- **修复**：改用 5 关节 PhysxMimic，inner knuckle 全部保留
- **验证**：Target 0/40 开合，黑支架不掉
- **预防**：2F-85 和 2F-140 的闭链拓扑不能混用

---

## 6. URDF mimic multiplier 不能直接抄

- **模块**：M3
- **现象**：5 关节硬 Mimic 后夹爪乱甩/爆炸
- **根因**：导入后的 joint frame/axis 翻转，URDF 的 `-1/+1` 不能直接当 PhysxMimic gearing
- **修复**：用 `+1/+1/+1/-1/-1`
- **验证**：官方完成版资产对照 + 60s headless
- **预防**：以完成版/实际 joint frame 为准

---

## 7. 5000 Hz 对 2F-140 过高

- **模块**：M3
- **现象**：Play 后夹爪爆开，整机飞走
- **根因**：mimic 频率 5000 + 错误 gearing，闭链过约束
- **修复**：Natural Frequency `2500`，Damping Ratio `0.005`
- **验证**：最大关节角 `0.7002 rad`，无爆炸
- **预防**：先低频率，再逐步加；mimic 关节不要加 Drive

---

## 8. Save 时 Isaac Sim segfault

- **模块**：M3
- **现象**：保存夹爪资产时 Isaac Sim 崩溃
- **根因**：同一个关节同时有 `NewtonMimicAPI` 和 `PhysxMimicJointAPI`
- **修复**：删除 `NewtonMimicAPI`，用 `stage.Save()` 保存
- **验证**：保存不再崩溃
- **预防**：一个关节只保留一种 mimic schema

---

## 9. 机器人视觉在架子上，Play 却整机飞走

- **模块**：M5
- **现象**：夹爪正常，Play 后整机消失
- **根因**：机器人 base 底板与 `sortbot_housing` 顶面重叠 3.7cm
- **证据**：base min Z `1.1769`，stand max Z `1.2141`
- **修复**：机器人 Z 和 `base_fixed_joint.localPos0` 改为 `1.21913`
- **验证**：headless 3600 步 + GUI Play 稳定
- **预防**：改高度必须同步 Fixed Joint，并检查包围盒

---

## 10. Gain Tuner 字体/DPI

- **模块**：M2
- **现象**：Gain Tuner 字体过大/过小，界面拥挤
- **根因**：6.1 Gain Tuner 字体固定 14px，不跟随 DPI
- **修复**：改用 Property 面板逐关节调，或调整系统缩放
- **验证**：能正常编辑 6 个关节
- **预防**：不要依赖 Gain Tuner 的自适应布局

---

## 11. 远程 4.5 仓库资产加载慢/失败

- **模块**：M5
- **现象**：`small_warehouse_digital_twin` / `sortbot_housing` 加载慢或报 URL 错
- **根因**：4.5 远程资产 + 网络/缓存
- **修复**：确认网络；使用本地缓存；必要时下载到本地
- **验证**：Stage 树里两个资产都出现
- **预防**：长期项目尽量把远程资产本地化

---

## 12. 6.1 找不到 Mesh Merge Tool

- **模块**：M6
- **现象**：`Tools > Robotics > Asset Editors` 里只有 Gain Tuner、Robot Assembler、Robot Self-Collision Detector、Asset Transformer，没有 Mesh Merge Tool
- **根因**：6.1 移除了 `Mesh Merge Tool`，资产优化改到 **Scene Optimizer**
- **修复**：`Window > Utilities > Scene Optimizer` → `Merge Static Meshes`；或 Script Editor 执行 `SceneOptimizerOperation(operation="merge")`
- **验证**：`/Merged/left_wheel` 是 1 个 Mesh，含 `Periwinkle_Gray` / `Woodsmoke` 两个 GeomSubset
- **预防**：4.5 的 `Tools > Robotics > Asset Editors` 不能直接照搬

---

## 13. Add > Reference 里找不到 `/Collisions/wheel`

- **模块**：M6
- **现象**：`Add > Reference` 只显示文件选择器，找不到 `/Collisions/wheel`
- **根因**：`/Collisions/wheel` 不是文件，是 `Jetbot_physics.usd` 里面的 Prim Path
- **修复**：在文件选择器选 `Jetbot_physics.usd`，在 `Reference options > Prim Path` 填 `/Collisions/wheel`；如需内部引用，再把 Asset Path 清空
- **验证**：Collider 的 References 显示 `Prim Path = /Collisions/wheel`，且 Instanceable
- **预防**：Reference 先选文件，再选文件内 Prim Path

---

## 14. Collider 的 Transform 没有 Rotate

- **模块**：M6
- **现象**：Collider Xform 的 Transform 只有 Translate / Orient / Scale，没有 Rotate XYZ
- **根因**：6.1 的 Xform 默认用 `xformOp:orient` 四元数
- **修复**：Orient 填 `(0.5, 0.5, 0.5, 0.5)`，等价于旧教程的 `(90, 90, 0)`；或者添加 Rotate XYZ，但不要和 Orient 同时叠加
- **验证**：左右 Collider 的朝向与官方 `Jetbot_physics_final.usd` 一致
- **预防**：6.1 Transform 面板先看是 Orient 还是 Rotate

---

## 15. 相关文档

- [Lab16 总览](00_overview.md)
- [2F-140 夹爪](03_robotiq_gripper.md)
- [仓库场景](05_warehouse_scene.md)
- [6.1 版本陷阱](../shared/version_traps.md)
