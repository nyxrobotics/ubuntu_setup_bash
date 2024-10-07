#!/bin/bash

# The content to add to .bashrc
content=$(cat << 'EOF'

## Macro
alias killr='ps aux | grep ros | grep -v grep | awk '\''{ print "kill -9", $2 }'\'' | sh && killall -9 roscore && killall -9 rosmaster && killall -9 rosout && killall -9 rviz'
alias killg="killall gzclient; killall gzserver; killall rosmaster; ps aux | grep ros | grep -v grep | awk '{ print \"kill -9\", \$2 }' | sh;ps aux | grep gazebo | grep -v grep | awk '{ print \"kill -9\", \$2 }' | sh"
alias killb="ps aux | grep blender | grep -v grep | awk '{ print \"kill -9\", \$2 }' | sh"
alias yamlfix="yamlfixer --recurse -1 ."
alias xmlfix="find . -maxdepth 3 -type f -name \"*.xml\" -o -name \"*.launch\" | xargs -I '{}' xmllint --format '{}' -output '{}'"
alias hooks_disable="git config --global core.hooksPath no-hooks"
alias hooks_enable="git config --global --unset core.hooksPath"
alias catkin="colcon"

function colcon_source() {
    # Search for 'install/setup.bash' by moving up the directory hierarchy from the current directory
    local dir=$(pwd)
    while [ "$dir" != "/" ]; do
        if [ -f "$dir/install/setup.bash" ]; then
            echo "Sourcing $dir/install/setup.bash"
            source "$dir/install/setup.bash"
            return 0
        fi
        dir=$(dirname "$dir")
    done

    echo "Error: Could not find install/setup.bash in any parent directory."
    return 1
}

# colcon_cd: Move to the workspace root directory by finding the 'src' directory
function colcon_cd() {
    local dir=$(pwd)
    
    while [ "$dir" != "/" ]; do
        # If 'src' directory is found, move to its parent (the workspace root)
        if [ -d "$dir/src" ]; then
            cd "$dir"
            echo "Moved to workspace root: $dir"
            return 0
        fi
        dir=$(dirname "$dir")
    done

    echo "Error: Could not find the workspace root."
    return 1
}

# colcon_build: Move to the workspace root and run colcon build
function colcon_build() {
    # Save the current directory
    local current_dir=$(pwd)

    # Move to the workspace root
    colcon_cd

    # Run colcon build in the workspace root
    echo "Running colcon build in workspace root..."
    colcon build

    # Return to the original directory
    cd "$current_dir"
}

# colcon_clean: Cleans up build, install, and log directories for colcon workspaces
function colcon_clean() {
    # Save the current directory
    local current_dir=$(pwd)

    # Move to the workspace root
    colcon_cd

    # Clean up the workspace
    echo "Cleaning colcon workspace..."
    if [ -d "build" ]; then
        rm -rf build
        echo "Removed build/ directory"
    else
        echo "No build/ directory found"
    fi

    if [ -d "install" ]; then
        rm -rf install
        echo "Removed install/ directory"
    else
        echo "No install/ directory found"
    fi

    if [ -d "log" ]; then
        rm -rf log
        echo "Removed log/ directory"
    else
        echo "No log/ directory found"
    fi

    echo "Colcon workspace cleaned."

    # Return to the original directory
    cd "$current_dir"
}

# update_rosdep: Updates rosdep and installs dependencies
function update_rosdep() {
    # Save the current directory
    local current_dir=$(pwd)

    # Move to the workspace root
    colcon_cd

    # Check if rosdep is initialized by looking for the sources list file
    if [ ! -f /etc/ros/rosdep/sources.list.d/20-default.list ]; then
        echo "rosdep is not initialized. Running 'sudo rosdep init'..."
        sudo rosdep init
    else
        echo "rosdep is already initialized. Skipping 'rosdep init'."
    fi

    # Update rosdep and install dependencies
    rosdep update
    rosdep install --from-paths src --ignore-src -r -y

    # Return to the original directory
    cd "$current_dir"
}

# update_rosinstall: Updates .rosinstall files and imports repositories
function update_rosinstall() {
    # Save the current directory
    local current_dir=$(pwd)

    # Move to the workspace root
    colcon_cd

    cd src

    # Ignore certain files during update
    ignore_pattern="(\./eband_local_planner/.*\.rosinstall|\./moveit/.*\.rosinstall|\./robotis/.*\.rosinstall)"
    
    # Get all .rosinstall files
    files=$(find . -type f -regextype posix-egrep -regex "\./.+\.rosinstall" | sort)
    pre_n=0
    n=$(echo ${files} | wc -w)

    while [ ${n} -ne ${pre_n} ]; do
        # Filter out the ignored files
        filtered_files=$(echo "${files}" | grep -Ev "${ignore_pattern}")
        
        # If no files are left after filtering, break the loop
        if [ -z "$filtered_files" ]; then
            break
        fi

        for f in ${filtered_files}; do
            echo "Processing ${f}"
            vcs import --skip-existing --recursive --debug < ${f}
        done
        
        # Update the file list and counts for the next iteration
        files=$(find . -type f -regextype posix-egrep -regex "\./.+\.rosinstall" | sort)
        pre_n=${n}
        n=$(echo ${files} | wc -w)
    done

    # Return to the original directory
    cd "$current_dir"
}

EOF
)

# Add the content to .bashrc if it's not already present
if ! grep -Fxq "## Macro" ~/.bashrc; then
    echo "$content" >> ~/.bashrc
    echo "The content has been added to ~/.bashrc."
else
    echo "The content is already present in ~/.bashrc."
fi
