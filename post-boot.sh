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
sudo apt install nvidia-utils-535

# Install CUDA samples
sudo -u $EXPERIMENT_USER git clone https://github.com/NVIDIA/cuda-samples.git /mydata/cuda-samples
sudo -u $EXPERIMENT_USER mkdir /mydata/cuda-samples/build && cd /mydata/cuda-samples/build

sudo -u $EXPERIMENT_USER bash -c 'echo "export PATH=/mydata/toolkit/bin:\$PATH" >> ~/.bashrc'
sudo -u $EXPERIMENT_USER bash -c 'echo "export LD_LIBRARY_PATH=/mydata/toolkit/lib64:\$LD_LIBRARY_PATH" >> ~/.bashrc'
sudo -u $EXPERIMENT_USER bash -c 'echo "export CUDAToolkit_ROOT=/mydata/toolkit" >> ~/.bashrc'

sudo -u $EXPERIMENT_USER bash -c 'source ~/.bashrc'


