#!/bin/bash

source `catkin locate --shell-verbs`
catkin source
roscd
cd ../src
ignores="./eband_local_planner/.travis.rosinstall, ./moveit/moveit.rosinstall"
ignore_files=${ignores//,/ }
files=`find . -type f -regextype posix-egrep -regex "\./.+\.rosinstall" | sort`
pre_n=0
n=`echo ${files} | wc -w`

contains() {
    [[ $1 =~ (^|[[:space:]])$2($|[[:space:]]) ]] && true || false
}

while [ `comm -3 <(echo ${files}) <(echo ${ignore_files[@]} | sort) | wc -w` -ne 0 -a ${n} -ne ${pre_n} ]
do
    for f in ${files}
    do
        if `contains "${ignore_files}" ${f}` || [[ ${f} =~ ".github/" ]]; then
            echo ignore ${f}
        else
            vcs import --skip-existing --recursive --debug < ${f}
            ignore_files+=(${f})
        fi
    done
    files=`find . -type f -regextype posix-egrep -regex "\./.+\.rosinstall" | sort`
    pre_n=${n}
    n=`echo ${files} | wc -w`
done
