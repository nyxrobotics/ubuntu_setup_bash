# Setup isaac sim
- Reference: [Installation using Isaac Sim Pip Package](https://isaac-sim.github.io/IsaacLab/main/source/setup/installation/pip_installation.html)

# Prepare
- Disable conda autostart (base): `conda config --set auto_activate_base false`

# Setup
- conda create -n env_isaaclab python=3.10 -y
- pip install torch==2.7.0 torchvision==0.22....url https://download.pytorch.org/whl/cu128
- pip install "isaacsim[all,extscache]==5.0.0.0" --extra-index-url https://pypi.nvidia.com

# Remove
- conda activate base
- conda remove --name env_isaaclab --all -y
