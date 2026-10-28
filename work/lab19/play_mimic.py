"""Launch Isaac Lab robomimic play.py with Mimic tasks registered."""

import runpy

import isaaclab_mimic.envs  # noqa: F401 -- register Mimic environments

runpy.run_path(
    r"E:\program\isaac_sim\IsaacLab\scripts\imitation_learning\robomimic\play.py",
    run_name="__main__",
)
