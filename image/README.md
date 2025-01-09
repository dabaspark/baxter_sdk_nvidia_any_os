# Using Pre-built Baxter SDK Docker Image

The pre-built image `dabaspark/kinetic-baxter:nvidia` is available on Docker Hub for immediate use.

## Quick Usage

1. Pull the image:
   ```bash
   docker pull dabaspark/kinetic-baxter:nvidia
   ```

2. Run with the provided script:
   ```bash
   chmod +x image.sh
   ./image.sh
   ```

## Manual Run

If you prefer to run without the script:
```bash
docker run -it \
    --name baxter \
    --gpus all \
    --env="DISPLAY" \
    --env="QT_X11_NO_MITSHM=1" \
    --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    dabaspark/kinetic-baxter:nvidia
```

## Default Configuration
- Username: `ros`
- Password: `ros`
- Workspace: `/home/ros/ros_ws`
- Pre-installed: Baxter SDK, simulator, and all dependencies

For detailed instructions, GPU setup, workspace management, and troubleshooting, please refer to the [main README](../README.md).
