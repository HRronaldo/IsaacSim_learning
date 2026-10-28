# lab16 工作目录说明

> 这里只放**资产**：输入 URDF、导入资产、组装文件、仓库场景、备份。  
> 教程与踩坑记录在 [docs/lab16](../../docs/lab16/00_overview.md)。

---

## 目录

```text
work/lab16/
├── inputs/
│   └── ur10/
│       └── ur10.urdf                 修复网格路径后的输入 URDF
├── ur10_1/                           UR10e 导入 + 组装
│   ├── ur10.usda
│   ├── ur10_with_gripper.usda       最终组装资产
│   ├── ur10_with_gripper_test.usda  夹爪隔离测试装配
│   ├── Textures/
│   └── payloads/
├── robotiq_2f_140/                   2F-140 夹爪资产
│   ├── robotiq_2f_140.usda           最终 5 关节 PhysxMimic
│   ├── robotiq_2f_140_fixed.usda     官方配置副本
│   ├── robotiq_2f_140_physx_loop_backup.usda
│   ├── robotiq_2f_140_mimic_attempt.usda
│   ├── Textures/
│   └── payloads/
├── warehouse.usda                    M5 仓库场景
├── warehouse_before_mimic_fix.usda   仓库回退点
└── backups/
    └── robotiq_2f_140_20261022/      早期夹爪备份
```

---

## 当前最终资产

- 组装：`ur10_1/ur10_with_gripper.usda`
- 夹爪：`robotiq_2f_140/robotiq_2f_140.usda`
- 场景：`warehouse.usda`
- 测试：`ur10_1/ur10_with_gripper_test.usda`

---

## 不要做的事

- 不要在 Isaac Sim 打开 `ur10_1/ur10.usda` 时移动 `ur10_1/`。
- 不要直接编辑 `payloads/` 原始层；调参/组装写在根层。
- 不要删除 `backups/` 和 `*_backup.usda`；它们是回退点。

---

## 相关文档

- [Lab16 总览](../../docs/lab16/00_overview.md)
- [2F-140 夹爪](../../docs/lab16/03_robotiq_gripper.md)
- [仓库场景](../../docs/lab16/05_warehouse_scene.md)
- [踩坑记录](../../docs/lab16/07_pitfalls.md)
