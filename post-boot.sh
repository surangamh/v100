wget https://developer.download.nvidia.com/compute/cuda/12.2.2/local_installers/cuda_12.2.2_535.104.05_linux.runchmod +x cuda_12.8.0_570.86.10_linux.run
EXPERIMENT_USER=$(ls /users | grep -v geni)
echo "Experiment User: $EXPERIMENT_USER"
GROUP: $(id -gn $EXPERIMENT_USER)
echo "Group: $GROUP"
sudo chown -v $EXPERIMENT_USER:octfpga-PG0 /mydata
sudo mkdir -p /mydata/tmp
sudo chown $EXPERIMENT_USER:octfpga-PG0 /mydata/tmp
./cuda_12.8.0_570.86.10_linux.run --silent --toolkit --toolkitpath=/mydata/toolkit --tmpdir=/mydata/tmp
