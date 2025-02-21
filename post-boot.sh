wget https://developer.download.nvidia.com/compute/cuda/12.2.2/local_installers/cuda_12.2.2_535.104.05_linux.runchmod +x cuda_12.8.0_570.86.10_linux.run
EXPERIMENT_USER=$(ls /users | grep -v geni)
sudo chown $EXPERIMENT_USER:$(id -gn) /mydata
sudo mkdir -p /mydata/tmp
sudo chown $EXPERIMENT_USER:$(id -gn) /mydata/tmp
./cuda_12.8.0_570.86.10_linux.run --silent --toolkit --toolkitpath=/mydata/toolkit --tmpdir=/mydata/tmp
