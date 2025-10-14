BOOTFLAG="/local/bootflag"

# Check if the boot flag exists
if [ ! -f "$BOOTFLAG" ]; then
    echo "Running startup script..."
    
    EXPERIMENT_USER=$(ls /users | grep -v geni)

    # Ensure EXPERIMENT_USER is found
    if [ -z "$EXPERIMENT_USER" ]; then
        echo "Error: No valid experiment user found!"
        exit 1
    fi

    echo "Experiment User: $EXPERIMENT_USER"

    sudo chown -v $EXPERIMENT_USER:octfpga-PG0 /mydata
    sudo mkdir -p /mydata/tmp
    sudo chown $EXPERIMENT_USER:octfpga-PG0 /mydata/tmp

    # Directories
    DATA_DIR="/mydata"
    TMP_DIR="$DATA_DIR/tmp"
    TOOLKIT_DIR="$DATA_DIR/toolkit"

    # NVIDIA driver version and CUDA installer
    NVIDIA_DRIVER="580"
    CUDA_VERSION="12.8.0"
    CUDA_RUN="cuda_12.8.0_570.86.10_linux.run"
    CUDA_URL="https://developer.download.nvidia.com/compute/cuda/12.8.0/local_installers/$CUDA_RUN"

    # Step 1: Create directories with proper ownership
    sudo mkdir -p "$DATA_DIR" "$TMP_DIR" "$TOOLKIT_DIR"
    sudo chown -v $EXPERIMENT_USER:octfpga-PG0 "$DATA_DIR" "$TMP_DIR" "$TOOLKIT_DIR"

    # Step 2: Install recommended NVIDIA driver via apt
    echo "Installing NVIDIA driver $NVIDIA_DRIVER..."
    sudo apt update
    sudo apt install -y nvidia-driver-$NVIDIA_DRIVER

    # Step 3: Download CUDA installer if not already downloaded
    if [ ! -f "$DATA_DIR/$CUDA_RUN" ]; then
        sudo -u $EXPERIMENT_USER wget -P "$DATA_DIR" "$CUDA_URL"
        sudo chmod +x "$DATA_DIR/$CUDA_RUN"
    fi

    # Step 4: Install CUDA toolkit (without overwriting driver)
    echo "Installing CUDA $CUDA_VERSION toolkit..."
    sudo -u $EXPERIMENT_USER bash -c "$DATA_DIR/$CUDA_RUN --silent --toolkit --toolkitpath=$TOOLKIT_DIR --tmpdir=$TMP_DIR"

     
    #Build samples

    #sudo -u $EXPERIMENT_USER mkdir /mydata/cuda-samples/build && cd /mydata/cuda-samples/build && cmake .. && make -j$(nproc)
    touch "$BOOTFLAG"
    echo "Boot flag created at $BOOTFLAG"
else
    echo "Boot flag exists, skipping startup script."
fi







