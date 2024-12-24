# Setup Instructions for Simulated Dataset

For more information, please refer to the [NeuralEnsemble / ephy_testing_data](https://gin.g-node.org/NeuralEnsemble/ephy_testing_data) repository.

- **Download the dataset**: 
    - Path: `mearec/mearec_test_10s.h5`

---

# Setup Instructions for KiloSort3

## 1. Install KiloSort3

For detailed installation instructions, refer to the [KiloSort GitHub page](https://github.com/MouseLand/Kilosort) and the release tag **v3.0.2**.

### **System Requirements**:
- **Supported OS**: Linux and Windows (64-bit)
- **Minimum GPU Requirements**: At least 8GB of GPU RAM is required to run the software.

### Installation on Linux

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

### Installation on Windows

Follow these steps to install KiloSort3 on a Windows system:

1. Decide where you will put Kilosort3. One possibility: `[userpath filesep 'tools']`.
2. Download Kilosort at `https://github.com/MouseLand/Kilosort/archive/refs/tags/v.3.0.2`
3. Add the Kilosort directories to the path
4. Call `mexGPUall` to build all the CUDA files. Right now, this requires either Visual Studio 2019 or Visual Studio 2022 version 17.9.x (not the latest Visual Studio 2022 17.10.x). Unfortunately, unless you already have one of these older versions of Visual Studio installed, one will need to pay to install that version. (See [this issue](https://www.mathworks.com/matlabcentral/answers/2158705-mexcuda-can-t-find-visual-studio-2022-but-mex-can) and [this documentation](https://www.mathworks.com/help/parallel-computing/run-mex-functions-containing-cuda-code.html).

The following code can do this:

```Matlab
% Step 1: Decide where to put Kilosort
localpath = [userpath filesep 'tools'];
if ~isfolder(localpath)
    mkdir(localpath);
end

% Step 2: Download Kilosort3
vers = 'v.3.0.2';
filename = [localpath filesep vers '.zip'];
remoteFilename = ['https://github.com/MouseLand/Kilosort/archive/refs/tags/' vers '.zip'];
websave(filename, remoteFilename);
currentwd = pwd;
try
    cd(localpath);
    unzippedFiles = unzip(filename);
    cd(currentwd);
catch
    cd(currentwd);
end;
kilosortParentDir = fileparts(unzippedFiles{1});

% Step 3: add the paths
addpath(genpath(kilosortParentDir));

% Step 4: Compile the GPU mex files
cd([kilosortParentDir filesep 'CUDA']);
mexGPUall
```


