FROM nvidia/cudagl:9.0-base-ubuntu16.04

# Run a full upgrade and install utilities for development.
RUN apt-get update && apt-get upgrade -y && apt-get install -y \
    mesa-utils \
    vim \
    nano \
    build-essential gdb \
    cmake cmake-curses-gui \
    git \
    ssh \
 && rm -rf /var/lib/apt/lists/*

# Register the ROS package sources.
ENV UBUNTU_RELEASE=xenial
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $UBUNTU_RELEASE main" > /etc/apt/sources.list.d/ros-latest.list'
RUN apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654

# Install ROS and Baxter dependencies
RUN apt-get update && apt-get install -y \
    ros-kinetic-desktop-full \
    python-wstool \
    python-rosdep \
    ros-kinetic-effort-controllers \
    gazebo7 \
    ros-kinetic-qt-build \
    ros-kinetic-gazebo-ros-control \
    ros-kinetic-gazebo-ros-pkgs \
    ros-kinetic-ros-control \
    ros-kinetic-control-toolbox \
    ros-kinetic-realtime-tools \
    ros-kinetic-ros-controllers \
    ros-kinetic-xacro \
    ros-kinetic-tf-conversions \
    ros-kinetic-kdl-parser \
    libignition-math2-dev \
    python-rospkg \
    python-catkin-pkg \
    ros-kinetic-joystick-drivers \
    python-argparse \
    python-rosinstall \
    python-rosinstall-generator \
    build-essential \
    ros-kinetic-genpy \
 && rm -rf /var/lib/apt/lists/*

# Upgrade Gazebo 7.
RUN sh -c 'echo "deb http://packages.osrfoundation.org/gazebo/ubuntu-stable `lsb_release -cs` main" > /etc/apt/sources.list.d/gazebo-stable.list'
RUN wget https://packages.osrfoundation.org/gazebo.key -O - | apt-key add -
RUN apt-get update && apt-get install -y \
    gazebo7 \
 && rm -rf /var/lib/apt/lists/*

# Initialize rosdep
RUN rosdep init

# Only for nvidia-docker 1.0
LABEL com.nvidia.volumes.needed="nvidia_driver"
# ENV PATH /usr/local/nvidia/bin:${PATH}
# ENV LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia/lib64:${LD_LIBRARY_PATH}

# nvidia-container-runtime (nvidia-docker2)
ENV NVIDIA_VISIBLE_DEVICES \
   ${NVIDIA_VISIBLE_DEVICES:-all}
ENV NVIDIA_DRIVER_CAPABILITIES \
   ${NVIDIA_DRIVER_CAPABILITIES:+$NVIDIA_DRIVER_CAPABILITIES,}graphics

# Some QT-Apps/Gazebo don't show controls without this
ENV QT_X11_NO_MITSHM 1

# Create users and groups.
ARG ROS_USER_ID=1000
ARG ROS_GROUP_ID=1000

RUN addgroup --gid $ROS_GROUP_ID ros \
 && useradd --gid $ROS_GROUP_ID --uid $ROS_USER_ID -ms /bin/bash -p "$(openssl passwd -1 ros)" -G root,sudo ros \
 && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers \
 && mkdir -p /workspace \
 && ln -s /workspace /home/workspace \
 && chown -R ros:ros /home/ros /workspace

# Source the ROS configuration.
RUN echo "source /opt/ros/kinetic/setup.bash" >> /home/ros/.bashrc

# Setup Baxter workspace and install SDK
USER ros
RUN rosdep update

# Create and setup Baxter workspace
RUN mkdir -p /home/ros/ros_ws/src
WORKDIR /home/ros/ros_ws/src

# Initialize wstool and get Baxter packages
RUN wstool init . \
    && wstool merge https://raw.github.com/RethinkRobotics/baxter/master/baxter_sdk.rosinstall \
    && echo "y" | wstool merge https://raw.githubusercontent.com/RethinkRobotics/baxter_simulator/kinetic-devel/baxter_simulator.rosinstall \
    && wstool update

# Build the workspace
WORKDIR /home/ros/ros_ws
RUN /bin/bash -c "source /opt/ros/kinetic/setup.bash && catkin_make && catkin_make install"

# Add workspace to bashrc
RUN echo "source /home/ros/ros_ws/devel/setup.bash" >> /home/ros/.bashrc

# If the script is started from a Catkin workspace,
# source its configuration as well.
RUN echo "test -f devel/setup.bash && echo \"Found Catkin workspace.\" && source devel/setup.bash" >> /home/ros/.bashrc

WORKDIR /home/ros/ros_ws
