% Set the path to the Python executable
% pyversion('~/.conda/envs/mat-spike-sort/bin/python'); % Linux/Mac example

% Verify the Python configuration
pyversion

% matlab startup for linux use of h5py
setenv('HDF5_DISABLE_VERSION_CHECK', '1')
py.sys.setdlopenflags(int32(10));  % this is equivalent to the above

% Run getting_started.py script 
pyrunfile("getting_started.py")