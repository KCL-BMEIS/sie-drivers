# this image's WORKDIR is /workspace, also see https://docs.nvidia.com/deeplearning/frameworks/pytorch-release-notes/rel-24-12.html
FROM nvcr.io/nvidia/pytorch:24.12-py3

# Update lists and upgrade packages
RUN apt update && apt upgrade -y

# Install ROS 2 Jazzy, see e.g. https://docs.ros.org/en/jazzy/Installation/Ubuntu-Install-Debians.html
ARG DEBIAN_FRONTEND=noninteractive
ENV ROS_DISTRO=jazzy
RUN apt install software-properties-common -y && \
    add-apt-repository universe && \
    apt update && apt install curl -y && \
    curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" | tee /etc/apt/sources.list.d/ros2.list > /dev/null && \
    apt update && apt upgrade -y && \
    apt install ros-${ROS_DISTRO}-ros-base -y && \
    apt install ros-dev-tools -y && \
    rosdep init

# Clone drivers and not distributed dependencies
RUN mkdir -p mock-or-drivers/src && \
    cd mock-or-drivers && \
    vcs import src --input https://raw.githubusercontent.com/KCL-BMEIS/mock-or-drivers/refs/heads/main/repos.yaml

# Install distributed dependencies and compile drivers
RUN cd mock-or-drivers && \
    rosdep update && \
    rosdep install \
        --from-paths src \
        -i -r -y --rosdistro=${ROS_DISTRO} && \
    source /opt/ros/${ROS_DISTRO}/setup.bash && \
    colcon build --cmake-args -DCMAKE_BUILD_TYPE=Release --symlink-install
