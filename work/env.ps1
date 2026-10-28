# ============================================================
# Isaac Sim / Isaac Lab environment setup (Windows PowerShell 5.1)
# Usage (note the leading dot):
#     . E:\programee\IsaacSim_learning\work\env.ps1
# After that, isaacsim / isaaclab / python point to the isaacsim env.
# NOTE: keep this file ASCII-only. PowerShell 5.1 reads .ps1 as ANSI.
# ============================================================

$IsaacSimEnv = "E:\anaconda_envs\isaacsim"
$IsaacLabDir = "E:\program\isaac_sim\IsaacLab"

# Point python / isaacsim at the isaacsim conda env (no conda activate needed).
$env:CONDA_PREFIX = $IsaacSimEnv
$env:CONDA_DEFAULT_ENV = "isaacsim"
$env:PATH = "$IsaacSimEnv;$IsaacSimEnv\Scripts;$IsaacSimEnv\Library\bin;$env:PATH"

# Auto-accept the Isaac Sim EULA on first run.
$env:OMNI_KIT_ACCEPT_EULA = "YES"

# Keep caches on E: to avoid filling C:.
$env:UV_CACHE_DIR = "E:\uv_cache"
$env:PIP_CACHE_DIR = "E:\pip_cache"

function isaacsim-gui { & "$IsaacSimEnv\Scripts\isaacsim.exe" @args }
function isaaclab { & "$IsaacLabDir\isaaclab.bat" @args }
function workdir { Set-Location "E:\programee\IsaacSim_learning\work" }
function lab16 { Set-Location "E:\programee\IsaacSim_learning\work\lab16" }
function lab19 { Set-Location "E:\programee\IsaacSim_learning\work\lab19" }

Write-Host "[OK] Isaac Sim environment variables set" -ForegroundColor Green
Write-Host ("[OK] python -> " + (Get-Command python).Source)
python --version
Write-Host "[TIP] GUI: isaacsim-gui    Isaac Lab: isaaclab -p <script>"
