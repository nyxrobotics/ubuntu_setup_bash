# Setup isaac sim
- Reference: [Installation using Isaac Sim Pip Package](https://isaac-sim.github.io/IsaacLab/main/source/setup/installation/pip_installation.html)

# Install anaconda
```bash
mkdir -p ~/lib/anaconda; cd ~/lib/anaconda
wget -O anaconda.sh https://repo.anaconda.com/archive/Anaconda3-2024.06-1-Linux-x86_64.sh
bash anaconda.sh
export PATH="/home/$USER/anaconda3/bin:$PATH"
```
- Do you accept the license terms? [yes|no] >>> `yes`
- Press ENTER to confirm the location >>> ENTER
- You can undo this by running `conda init --reverse $SHELL`? [yes|no] >>> `no`

# Disable Conda base startup
```conda config --set auto_activate_base false #Disable conda autostart (base)```

# Setup
```bash
mkdir -p ~/lib/isaaclab; cd ~/lib/isaaclab
conda create -n env_isaaclab python=3.11 -y;conda activate env_isaaclab
pip install torch==2.7.0 torchvision==0.22.0 --index-url https://download.pytorch.org/whl/cu128
pip install "isaacsim[all,extscache]==5.0.0" --extra-index-url https://pypi.nvidia.com
```
# isaac lab
```bash
git clone git@github.com:isaac-sim/IsaacLab.git
```

# Remove env_isaaclab
```bash
conda activate base
conda remove --name env_isaaclab --all -y
```