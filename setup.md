## Setup Instructions for Simulated Dataset

For more information, please refer to the [NeuralEnsemble / ephy_testing_data](https://gin.g-node.org/NeuralEnsemble/ephy_testing_data) repository.

- **Download the dataset**: 
    - Path: `mearec/mearec_test_10s.h5`

---

## Setup Instructions for KiloSort3

### 1. Install KiloSort3

For detailed installation instructions, refer to the [KiloSort GitHub page](https://github.com/MouseLand/Kilosort) and the release tag **v3.0.2**.

### **System Requirements**:
- **Supported OS**: Linux and Windows (64-bit)
- **Minimum GPU Requirements**: At least 8GB of GPU RAM is required to run the software.

### 2. Installation on Linux

Follow these steps to install KiloSort3 on a Linux system:

```sh
# Install KiloSort3
cd /opt \
    && sudo curl -LJO https://github.com/MouseLand/Kilosort/archive/refs/tags/v3.0.2.zip \
    && sudo unzip v3.0.2.zip \
    && sudo mv /opt/Kilosort-3.0.2 /opt/Kilosort-3 \
    && sudo rm -rf /opt/v3.0.2.zip \
    && sudo matlab -nodesktop -nosplash -r "cd('/opt/Kilosort-3/CUDA'); mexGPUall; addpath(genpath('/opt/Kilosort-3')); savepath; exit;" \
    && sudo chown -R jovyan:jovyan /opt/Kilosort-3
```

