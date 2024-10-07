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
function update_rosdep() {
    # Source the workspace
    colcon_source

    # Check if rosdep is initialized, if not initialize it
    if ! rosdep check >/dev/null 2>&1; then
        echo "rosdep is not initialized. Running 'sudo rosdep init'..."
        sudo rosdep init
    fi

    # Update rosdep and install dependencies
    rosdep update
    rosdep install --from-paths src --ignore-src -r -y
}
function update_rosinstall() {
    # Source the colcon workspace
    colcon_source

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
