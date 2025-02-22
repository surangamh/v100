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

    # Define CUDA download URL and filename
    CUDA_URL="https://developer.download.nvidia.com/compute/cuda/12.8.0/local_installers/cuda_12.8.0_570.86.10_linux.run"
    CUDA_INSTALLER="cuda_12.8.0_570.86.10_linux.run"
    CUDA_INSTALL_CMD="./$CUDA_INSTALLER --silent --toolkit --toolkitpath=/mydata/toolkit --tmpdir=/mydata/tmp"

    sudo -u $EXPERIMENT_USER bash -c "cd /mydata && wget $CUDA_URL && chmod +x ./$CUDA_INSTALLER && $CUDA_INSTALL_CMD"

    # Verify download success
    #if [ ! -f "/users/$EXPERIMENT_USER/$CUDA_INSTALLER" ]; then
    #    echo "Error: CUDA download failed!"
    #    exit 1
    #fi

    # Make the installer executable
    #sudo -u $EXPERIMENT_USER chmod +x "/users/$EXPERIMENT_USER/$CUDA_INSTALLER"

    #sudo -u $EXPERIMENT_USER bash -c "cd ~ && ./$CUDA_INSTALLER --silent --toolkit --toolkitpath=/mydata/toolkit --tmpdir=/mydata/tmp"

    sudo apt update
    sudo apt install nvidia-utils-535 -y

    # Install CUDA samples
    #sudo -u $EXPERIMENT_USER git clone https://github.com/NVIDIA/cuda-samples.git /mydata/cuda-samples
    #sudo -u $EXPERIMENT_USER bash -c 'echo "export PATH=/mydata/toolkit/bin:\$PATH" >> ~/.bashrc'
    #sudo -u $EXPERIMENT_USER bash -c 'echo "export LD_LIBRARY_PATH=/mydata/toolkit/lib64:\$LD_LIBRARY_PATH" >> ~/.bashrc'
    #sudo -u $EXPERIMENT_USER bash -c 'echo "export CUDAToolkit_ROOT=/mydata/toolkit" >> ~/.bashrc'

    #sudo -u $EXPERIMENT_USER bash -c 'source ~/.bashrc'

    #Install GCC

    #sudo add-apt-repository ppa:ubuntu-toolchain-r/test -y
    #sudo apt update
    #sudo apt install gcc-11 g++-11 -y

    #sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-11 100
    #sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-11 100

    #Install dependencies

    #sudo apt-get install freeglut3-dev mesa-common-dev -y
    #sudo apt-get install libopenmpi-dev -y
    #sudo apt-get install libegl1-mesa-dev -y 
    #sudo apt-get install libfreeimage-dev -y
    #sudo apt-get install libvulkan-dev -y
    #sudo apt-get install libglfw3-dev -y
    #sudo apt-get install libpthread-stubs0-dev -y
    #sudo apt-get install libglfw3-dev

    #Build samples

    #sudo -u $EXPERIMENT_USER mkdir /mydata/cuda-samples/build && cd /mydata/cuda-samples/build && cmake .. && make -j$(nproc)
    touch "$BOOTFLAG"
    echo "Boot flag created at $BOOTFLAG"
else
    echo "Boot flag exists, skipping startup script."
fi







