# ============================================================
# Optional convenience script for the Isaac Sim project (Git Bash)
#
# NOT required. Minimal workflow:
#     conda activate isaacsim
#     isaacsim
#     isaaclab -p <script.py>
#
# This script only activates the env and adds directory shortcuts.
# Usage:
#   source /e/programee/IsaacSim_learning/work/env.sh
# ============================================================

# Fallback: make conda available even in non-interactive shells.
if ! command -v conda >/dev/null 2>&1; then
  if [ -f "/d/tools/anaconda3/etc/profile.d/conda.sh" ]; then
    . "/d/tools/anaconda3/etc/profile.d/conda.sh"
  fi
fi

conda activate isaacsim

workdir() { cd "E:/programee/IsaacSim_learning/work" || return; }
lab16()   { cd "E:/programee/IsaacSim_learning/work/lab16" || return; }
lab19()   { cd "E:/programee/IsaacSim_learning/work/lab19" || return; }

echo "[OK] isaacsim activated"
echo "python   -> $(command -v python)"
echo "isaacsim -> $(command -v isaacsim)"
echo "isaaclab -> $(command -v isaaclab)"
