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
CUDA_URL="wget https://developer.download.nvidia.com/compute/cuda/12.8.0/local_installers/cuda_12.8.0_570.86.10_linux.run"
CUDA_INSTALLER="cuda_12.8.0_570.86.10_linux.run"

sudo -u $EXPERIMENT_USER bash -c "cd ~ && wget $CUDA_URL"

# Verify download success
if [ ! -f "/users/$EXPERIMENT_USER/$CUDA_INSTALLER" ]; then
    echo "Error: CUDA download failed!"
    exit 1
fi

# Make the installer executable
sudo -u $EXPERIMENT_USER chmod +x "/users/$EXPERIMENT_USER/$CUDA_INSTALLER"

sudo -u $EXPERIMENT_USER bash -c "cd ~ && ./$CUDA_INSTALLER --silent --toolkit --toolkitpath=/mydata/toolkit --tmpdir=/mydata/tmp"

