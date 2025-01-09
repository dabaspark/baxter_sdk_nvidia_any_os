# RUN BAXTER SDK in any Operating System using Docker

Run Baxter SDK and simulation seamlessly on any modern operating system using Docker, with full GPU support and graphical capabilities.

## Overview

This repository provides a Docker-based solution for running Baxter SDK and simulation on any modern operating system, eliminating the need for virtual machines or older Ubuntu installations.

### Key Features

- Works on any Ubuntu version (including 24.04)
- Runs Baxter simulation with full graphics support (Gazebo and RViz)
- Supports NVIDIA GPU cards
- Seamless integration with host machine
- Full functionality equivalent to native installation

**Note:** The container runs Ubuntu 16.04 and ROS Kinetic internally to maintain compatibility with Baxter SDK.

## Requirements

- Docker installed on your system
- NVIDIA Container Toolkit installed
- X11 for display forwarding

## Quick Start

There are two ways to use this repository:

### Option 1: Using Pre-built Image (Recommended)

1. Clone the repository:
   ```bash
   git clone github.com/dabaspark/baxter_sdk_nvidia_any_os.git
   cd baxter_sdk_nvidia_any_os
   ```

2. Make the script executable:
   ```bash
   chmod +x image/image.sh
   ```

3. Run the container using the pre-built image:
   ```bash
   ./image/image.sh
   ```

This option is faster as it downloads the pre-built image directly from Docker Hub.

### Option 2: Building from Source

If you want to build the image yourself or make modifications:

1. Clone the repository:
   ```bash
   git clone github.com/dabaspark/baxter_sdk_nvidia_any_os.git
   cd baxter_sdk_nvidia_any_os
   ```

2. Make the script executable:
   ```bash
   chmod +x baxter.sh
   ```

3. Build and run the container:
   ```bash
   ./baxter.sh
   ```

This option takes longer as it builds the image from scratch but allows for customization.


### Workspace Integration

You'll be logged in as user `ros` (password: `ros`) with sudo privileges. The container starts in the Baxter workspace directory at `/home/ros/ros_ws`.

The container starts in the Baxter workspace directory at `/home/ros/ros_ws`. This workspace is pre-configured with:
- Baxter SDK
- Baxter Simulator
- All necessary dependencies

The workspace is already built and sourced in your `.bashrc`, so you can immediately:
- Run Baxter simulations
- Build additional packages
- Use ROS commands

To access your host machine files, you can use the `/workspace` directory which is linked to your current directory on the host.


### Additional Terminals

To open additional terminals in the running container:
```bash
docker exec -it baxter bash
```

**Note:** The script creates a container named `baxter`. Running `./baxter.sh` twice won't work, but you can open multiple terminals using `docker exec` as shown above.

## Technical Details

### Why This Solution?

ROS Kinetic is outdated, but Baxter SDK requires Kinetic and Gazebo 7. This repository provides a modern solution for running these legacy requirements on current systems.

### Problems Solved

This repository addresses several key issues:

1. **OS Compatibility**: Eliminates issues with deprecated Ubuntu 16.04 on modern hardware.
2. **Virtual Machine Limitations**: Avoids driver compatibility issues and performance overhead.
3. **NVIDIA Runtime Updates**: Uses modern `nvidia-container-toolkit` instead of deprecated `nvidia-docker2`.
4. **Graphics Support**: Properly configures OpenGL for visualization tools.
5. **Gazebo Version**: Uses updated Gazebo 7.x from official sources.
6. **X11 Authentication**: Fixes common display forwarding issues.
7. **ROS Message Handling**: Resolves "DeserializationError" issues with updated genpy.

### Container Architecture

The image is built on `nvidia/cudagl:9.0-base-ubuntu16.04` instead of the standard ROS image to ensure proper OpenGL support for visualization applications.

## Working with the Image

### Using Pre-built Image

The image is available as [`dabaspark/kinetic-baxter:nvidia`](https://hub.docker.com/r/dabaspark/kinetic-baxter).

### Building the Image

To build the image manually:
```bash
docker build -t dabaspark/kinetic-baxter:nvidia -f kinetic.Dockerfile .
```

### Custom User Configuration

You can customize the user ID and group ID during build:
```bash
docker build \
    --build-arg ROS_USER_ID=1000 \
    --build-arg ROS_GROUP_ID=1000 \
    -t dabaspark/kinetic-baxter:nvidia \
    -f kinetic.Dockerfile .
```

## Acknowledgments

This solution builds upon various community solutions and official documentation to create a seamless experience for running Baxter SDK on modern systems. Special thanks to the following:
- [Ubuntu install of ROS Kinetic](http://wiki.ros.org/kinetic/Installation/Ubuntu)
- [BAXTER SDK Installation](https://github.com/RethinkRobotics/sdk-docs/wiki/Installing-the-Research-SDK)
- [NVIDIA Container Toolkit](https://github.com/NVIDIA/nvidia-docker)
- [CUDA + OpenGL images from NVIDIA](https://hub.docker.com/r/nvidia/cudagl)
- [Install Gazebo using Ubuntu Packages](http://gazebosim.org/tutorials?cat=install&tut=install_ubuntu&ver=7.0)
- [nvidia/cudagl](https://hub.docker.com/r/nvidia/cudagl/tags?page=1&name=16.04) Docker image
- [sunsided repo](https://github.com/sunsided/ros-gazebo-gpu-docker) 
- [rovbo-maksim issue](https://github.com/ros/genpy/issues/138)

For any inquiries or support, please contact me: m.abdulwahab.daba@gmail.com
