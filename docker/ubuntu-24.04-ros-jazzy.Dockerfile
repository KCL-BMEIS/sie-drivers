# this image's WORKDIR is /workspace
FROM nvcr.io/nvidia/pytorch:24.07-py3

ARG USER_ID
ARG GROUP_ID
ARG USER

# Create non-root user, see https://code.visualstudio.com/remote/advancedcontainers/add-nonroot-user#_creating-a-nonroot-user
RUN groupadd --gid $GROUP_ID $USER \
    && useradd --uid $USER_ID --gid $GROUP_ID -m $USER \
    # Add sudo support
    && apt-get update \
    && apt-get install -y sudo \
    && echo $USER ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USER \
    && chmod 0440 /etc/sudoers.d/$USER

# Update image
RUN apt-get update && apt-get upgrade -y

# Install ROS 2 Jazzy, see e.g. https://docs.ros.org/en/jazzy/Installation/Ubuntu-Install-Debians.html
ARG DEBIAN_FRONTEND=noninteractive
ENV ROS_DISTRO=jazzy
RUN apt-get install software-properties-common -y && \
    add-apt-repository universe &&\
    apt-get update && apt-get install curl -y && \
    curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" | tee /etc/apt/sources.list.d/ros2.list > /dev/null && \
    apt-get update && apt-get upgrade -y && \
    apt-get install ros-${ROS_DISTRO}-ros-base -y && \
    apt-get install ros-dev-tools -y && \
    rosdep init

# Install AW-UE150 camera driver
RUN mkdir -p sie-drivers/src && \
    cd sie-drivers && \
    vcs import src --input https://raw.githubusercontent.com/KCL-BMEIS/sie-drivers/refs/heads/main/repos.yaml

# Change user and permission
USER $USER
RUN chmod -R 777 sie-drivers

# Compile drivers
RUN cd sie-drivers && \
    rosdep update && \
    rosdep install \
        --from-paths src \
        -i -r -y --rosdistro=${ROS_DISTRO} && \
    source /opt/ros/${ROS_DISTRO}/setup.bash && \
    colcon build --cmake-args -DCMAKE_BUILD_TYPE Release --symlink-install
