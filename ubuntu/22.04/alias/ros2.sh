# !/bin/bash

## ROS2 Humble paths
source /opt/ros/humble/local_setup.sh
export ROS_DISTRO=humble
export RMW_IMPLEMENTATION=rmw_fastrtps_cpp
export ROS_AUTOMATIC_DISCOVERY_RANGE=LOCALHOST
export ROS_DOMAIN_ID=0

## Macro
alias killr='ps aux | grep ros | grep -v grep | awk '\''{ print "kill -9", $2 }'\'' | sh && killall -9 roscore && killall -9 rosmaster && killall -9 rosout && killall -9 rviz'
alias killg="killall gzclient; killall gzserver; killall rosmaster; ps aux | grep ros | grep -v grep | awk '{ print \"kill -9\", \$2 }' | sh;ps aux | grep gazebo | grep -v grep | awk '{ print \"kill -9\", \$2 }' | sh"
alias killb="ps aux | grep blender | grep -v grep | awk '{ print \"kill -9\", \$2 }' | sh"
alias yamlfix="yamlfixer -r -1 ."  # pip install yamlfixer-opt-nc
alias xmlfix="find . -maxdepth 10 -type f \( -name '*.xml' -o -name '*.launch' \) -print0 | xargs -0 -I {} sh -c 'xmllint --format \"{}\" --output \"{}\"'"
alias xacrofix="find . -maxdepth 10 -type f \( -name '*.xacro' -o -name '*.gazebo' \) -print0 | xargs -0 -I {} sh -c 'xmllint --format \"{}\" --output \"{}\"'"
alias hooks_disable="git config --global core.hooksPath no-hooks"
alias hooks_enable="git config --global --unset core.hooksPath"
alias catkin="colcon"

function colcon_source() {
    # Search for 'install/setup.bash' by moving up the directory hierarchy from the current directory
    source /usr/bin/ros_local_setup.bash
    source /opt/ros/humble/setup.bash
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

    # Calculate parallel workers
    local num_procs=$(nproc)
    local mem_free_gb=$(awk '/MemAvailable/ {print $2 / 1024 / 1024}' /proc/meminfo)
    local max_workers=$(awk -v procs=$num_procs -v mem=$mem_free_gb 'BEGIN {
        workers = (procs / 2.0) < (mem / 2.0) ? (procs / 2.0) : (mem / 2.0);
        print workers < 1 ? 1 : int(workers);
    }')

    # Run colcon build in the workspace root
    echo "Running colcon build in workspace root with $max_workers parallel workers..."
    colcon build --symlink-install --continue-on-error --parallel-workers $max_workers

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

    unset AMENT_PREFIX_PATH
    unset CMAKE_PREFIX_PATH
    echo "Colcon workspace cleaned."

    # Return to the original directory
    cd "$current_dir"
}

# update_rosdep: Updates rosdep and installs dependencies
function rosdep_update() {
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
function rosinstall_update() {
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

# update_vcs_repos: Updates .repos files and imports repositories
function vcs_update() {
    # Save the current directory
    local current_dir=$(pwd)

    # Move to the workspace root
    colcon_cd

    cd src

    # Ignore certain files during update
    ignore_pattern="(\./eband_local_planner/.*\.repos|\./moveit/.*\.repos|\./robotis/.*\.repos)"
    
    # Get all .repos files
    files=$(find . -type f -regextype posix-egrep -regex "\./.+\.repos" | sort)
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
        files=$(find . -type f -regextype posix-egrep -regex "\./.+\.repos" | sort)
        pre_n=${n}
        n=$(echo ${files} | wc -w)
    done

    # Return to the original directory
    cd "$current_dir"
}

# ROSパッケージ複製後のリネーム用（from/to は小文字で渡す）
# 使い方: ros_rename <from_lower> <to_lower>
# 例: ros_rename my_robot other_robot
function ros_rename() {
  set -euo pipefail

  if [ "$#" -ne 2 ]; then
    echo "usage: ros_rename <from_lower> <to_lower>" >&2
    return 2
  fi

  local from="$1"
  local to="$2"

  # 引数チェック（小文字のみ）
  if [[ ! "$from" =~ ^[a-z]+$ ]] || [[ ! "$to" =~ ^[a-z]+$ ]]; then
    echo "error: from/to は小文字の[a-z]+で指定してください" >&2
    return 2
  fi

  # 表記ゆれ（小文字 / 先頭のみ大文字 / 全部大文字）を維持して置換
  local from_cap="${from^}"  to_cap="${to^}"
  local from_up="${from^^}"  to_up="${to^^}"

  echo "Rename/Replace:"
  echo "  '$from' -> '$to'"
  echo "  '$from_cap' -> '$to_cap'"
  echo "  '$from_up' -> '$to_up'"
  echo "  (skip: .git/ .github/)"
  echo

  # 1) ファイル中身の置換（.git/.github配下は除外、テキストっぽいファイルだけ）
  #    -I: バイナリ扱いのファイルはスキップ
  #    -l: マッチしたファイル名だけ出す
  #    findで候補を集め、grepでマッチしたものだけperlでin-place置換
  while IFS= read -r -d '' f; do
    # perlで安全に（\Q...\E でメタ文字エスケープ）
    perl -0777 -i -pe \
      "s/\\Q$from_up\\E/$to_up/g; s/\\Q$from_cap\\E/$to_cap/g; s/\\Q$from\\E/$to/g" \
      -- "$f"
  done < <(
    find . \
      \( -type d -name .git -o -type d -name .github \) -prune -o \
      -type f -print0 \
    | xargs -0 grep -I -l -Z -e "$from" -e "$from_cap" -e "$from_up" 2>/dev/null
  )

  # 2) ファイル名/ディレクトリ名の置換（深い方から：-depth）
  #    .git/.github配下は除外
  while IFS= read -r -d '' p; do
    local base dir newbase newpath
    dir="$(dirname -- "$p")"
    base="$(basename -- "$p")"

    newbase="$base"
    newbase="${newbase//${from_up}/${to_up}}"
    newbase="${newbase//${from_cap}/${to_cap}}"
    newbase="${newbase//${from}/${to}}"

    if [[ "$newbase" != "$base" ]]; then
      newpath="$dir/$newbase"
      if [[ -e "$newpath" ]]; then
        echo "error: rename conflict: '$p' -> '$newpath' (already exists)" >&2
        return 1
      fi
      mv -- "$p" "$newpath"
    fi
  done < <(
    find . -depth \
      \( -type d -name .git -o -type d -name .github \) -prune -o \
      -print0
  )

  echo "done."
}
# 使い方: ros_rename_all <from_lower> <to_lower>
# 例: ros_rename_all ankle_r_yaw right_hip_yaw
#
# from/to: 小文字/数字/_/- を想定（ROSっぽい命名）
# 置換: snake/kebab/UPPER/Cap1 + PascalCase + camelCase を網羅
# 対象: ファイル中身 + ファイル名/ディレクトリ名
# 除外: .git / .github 配下
function ros_rename_all() {
  set -euo pipefail

  if [ "$#" -ne 2 ]; then
    echo "usage: ros_rename_all <from_lower> <to_lower>" >&2
    return 2
  fi

  local from="$1"
  local to="$2"

  if [[ ! "$from" =~ ^[a-z0-9_-]+$ ]] || [[ ! "$to" =~ ^[a-z0-9_-]+$ ]]; then
    echo "error: from/to は小文字の[a-z0-9_-]+で指定してください" >&2
    return 2
  fi

  # 置換表生成（Bashの^^/^を使わずPerlで）
  local map
  map="$(perl -e '
use strict; use warnings;

my ($from, $to) = @ARGV;

sub snake  { my $s=shift; $s =~ s/-/_/g; return $s; }
sub kebab  { my $s=shift; $s =~ s/_/-/g; return $s; }
sub up     { my $s=shift; $s =~ tr/a-z/A-Z/; return $s; }
sub cap1   { my $s=shift; $s =~ s/^([a-z])/\U$1/; return $s; }

sub pascal {
  my $s = snake(shift);
  my @p = grep { length($_) } split /_+/, $s;
  for (@p) { s/^([a-z])/\U$1/; }
  return join("", @p);
}

sub camel {
  my $p = pascal(shift);
  $p =~ s/^([A-Z])/\L$1/;
  return $p;
}

my $fs = snake($from);
my $ts = snake($to);

my $fk = kebab($from);
my $tk = kebab($to);

my $fu_s = up($fs);
my $tu_s = up($ts);

my $fu_k = up($fk);
my $tu_k = up($tk);

my $fc_s = cap1($fs);
my $tc_s = cap1($ts);

my $fc_k = cap1($fk);
my $tc_k = cap1($tk);

my $fp  = pascal($from);
my $tp  = pascal($to);

my $fcm = camel($from);
my $tcm = camel($to);

# 長い/具体的→短い の順
my @pairs = (
  $fp,   $tp,
  $fcm,  $tcm,
  $fu_s, $tu_s,
  $fu_k, $tu_k,
  $fc_s, $tc_s,
  $fc_k, $tc_k,
  $fk,   $tk,
  $fs,   $ts,
);

for (my $i=0; $i<@pairs; $i+=2) {
  next if !defined($pairs[$i]) || $pairs[$i] eq "";
  print $pairs[$i], "\t", $pairs[$i+1], "\n";
}
' -- "$from" "$to")"

  echo "Replace patterns (skip: .git/ .github/):"
  echo "$map" | awk -F'\t' '{printf "  %s -> %s\n",$1,$2}'
  echo

  # --- 1) file contents replace ---
  # まず候補ファイルを全部走査して置換（バイナリはPerl側で触っても大抵無害だが、念のためgrepで絞る）
  # ※ここが重要：RR_MAP="$map" を付けて Perl に置換表を渡す
  while IFS= read -r -d '' f; do
    RR_MAP="$map" perl -0777 -i -pe '
      use strict; use warnings;

      my $map = $ENV{RR_MAP} // "";
      my @pairs;
      for my $ln (split /\n/, $map){
        next if $ln eq "";
        my ($a,$b)=split(/\t/,$ln,2);
        next if !defined($a) || $a eq "";
        push @pairs, [$a,$b];
      }

      for my $p (@pairs){
        my ($a,$b)=@$p;
        my $q = quotemeta($a);
        s/$q/$b/g;
      }
    ' -- "$f"
  done < <(
    find . \
      \( -type d -name .git -o -type d -name .github \) -prune -o \
      -type f -print0 \
    | xargs -0 grep -I -l -Z -e "${from//-/_}" -e "${from//_/-}" 2>/dev/null
  )

  # --- 2) rename files/dirs (depth-first) ---
  while IFS= read -r -d '' p; do
    local dir base newbase newpath
    dir="$(dirname -- "$p")"
    base="$(basename -- "$p")"

    newbase="$(RR_MAP="$map" perl -e '
      use strict; use warnings;
      my $s = shift @ARGV;
      my $map = $ENV{RR_MAP} // "";
      for my $ln (split /\n/, $map){
        next if $ln eq "";
        my ($a,$b)=split(/\t/,$ln,2);
        next if !defined($a) || $a eq "";
        my $q = quotemeta($a);
        $s =~ s/$q/$b/g;
      }
      print $s;
    ' -- "$base")"

    if [[ "$newbase" != "$base" ]]; then
      newpath="$dir/$newbase"
      if [[ -e "$newpath" ]]; then
        echo "error: rename conflict: '$p' -> '$newpath' (already exists)" >&2
        return 1
      fi
      mv -- "$p" "$newpath"
    fi
  done < <(
    find . -depth \
      \( -type d -name .git -o -type d -name .github \) -prune -o \
      -print0
  )

  echo "done."
}

