# !/bin/bash

# --- Conda on/off (ROS-safe) ---------------------------------
# Save original PATH the first time conda is enabled
conda_on() {
  if [ -z "$_ORIGINAL_PATH_BEFORE_CONDA" ]; then
    export _ORIGINAL_PATH_BEFORE_CONDA="$PATH"
  fi
  source /home/$USER/anaconda3/etc/profile.d/conda.sh
  export PATH="/home/$USER/anaconda3/bin:$PATH"
}

# Restore PATH and deactivate conda
conda_off() {
  if [ -n "$_ORIGINAL_PATH_BEFORE_CONDA" ]; then
    export PATH="$_ORIGINAL_PATH_BEFORE_CONDA"
    unset _ORIGINAL_PATH_BEFORE_CONDA
  fi
  conda deactivate 2>/dev/null || true
}

