# Isaac Sim 6.1 学习教程

> 从 URDF 资产导入、机器人组装、仓库场景搭建，到 Isaac Lab 模仿学习数据采集与训练。  
> 一套可复现的 **Isaac Sim 6.1 + Isaac Lab 3.0** 实战教程。

---

## 版本基线

| 项目 | 版本 |
|---|---|
| Isaac Sim | **6.1.0.0** |
| Isaac Lab | **3.0.0**（pip 包 17.0.1） |
| PyTorch | 2.11.0+cu128 |
| OS | Windows 11 |

> 官方文档认准 `/6.1.0/`：<https://docs.isaacsim.omniverse.nvidia.com/6.1.0/>

---

## 快速入口

- [课程地图](docs/README.md)
- [导航目录](docs/SUMMARY.md)
- [入门教程收尾](docs/99_course_closeout.md)
- [环境搭建](docs/shared/README.md)
- [6.1 版本陷阱](docs/shared/version_traps.md)
- [Lab16 总览](docs/lab16/README.md)
- [Lab16 踩坑记录](docs/lab16/07_pitfalls.md)
- [Lab19 总览](docs/lab19/README.md)
- [Lab19 踩坑记录](docs/lab19/04_pitfalls.md)

---

## 仓库结构

| 目录 | 职责 |
|---|---|
| `docs/` | 教程正文与配图，GitBook 直接渲染这一层 |
| `work/` | 教程产出的 USD / URDF 资产与脚本 |
| `.gitbook.yaml` | GitBook 构建配置（`root: ./docs`） |

---

## 教程完成度

- 入门基础（环境 / 基础操作 / 版本陷阱）：**完成**
- Lab16（USD for Robotics）：**完成**
- Lab19（SMMG / 模仿学习）：**M1-M3 完成**
- Lab18（Isaac ROS）、MEGA SIL：**暂不覆盖**

---

## 关于原始课程资料

本仓库只收录教程正文与自建资产。NVIDIA 官方 Lab 原始材料（课程工程、样例资产、官方视频）
不在本仓库分发，请以官方渠道为准：

- Isaac Sim 文档：<https://docs.isaacsim.omniverse.nvidia.com/6.1.0/>
- Isaac Lab 文档：<https://isaac-sim.github.io/IsaacLab/>
- NVIDIA 学习与培训：<https://www.nvidia.com/en-us/learn/>

---

## 贡献

教程仍在迭代。发现错误、有补充或想增加新的 Lab，欢迎提 Issue 或 Pull Request。
