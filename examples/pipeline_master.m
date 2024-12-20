function pipeline_master(data_file_path, folder, kilosortPath)
    % Main script to execute the spike sorting pipeline with default or user-provided arguments.
    %
    % Parameters:
    % - data_file_path: Path to the HDF5 file containing the recording data.
    % - folder: Folder for KiloSort input and output.
    % - kilosortPath: Path to the Kilosort3 toolbox.

    % Get the full path of the current script or function
    currentScriptPath = fileparts(mfilename('fullpath'));
    % Resolve the path to the 'src' folder relative to the current script's directory
    srcPath = fullfile(fileparts(currentScriptPath), 'src');
    if ~contains(path, srcPath)
        addpath(genpath(srcPath));
        fprintf('Added "%s" to the path.\n', srcPath);
    else
        fprintf('Folder "%s" is already in the path.\n', srcPath);
    end

    % Default argument values
    if nargin < 1 || isempty(data_file_path)
        data_file_path = '~/spikeinterface_datasets/ephy_testing_data/mearec/mearec_test_10s.h5';
    end
    if nargin < 2 || isempty(folder)
        folder = './spikeSort_outputs';
    end
    if nargin < 3 || isempty(kilosortPath)
        kilosortPath = '/opt/Kilosort-3.0';
    end
    fpath = fullfile(pwd, folder);

    % Create an instance of the MearecRecording class
    recording = MearecRecording();

    % Read the recording from the specified HDF5 file
    recording = recording.read_recording(data_file_path);

    % Display the recording data, number of channels, and sampling frequency
    fprintf('Number of Channels: %d\n', recording.nchan);
    fprintf('Sampling Rate: %.2f Hz\n', recording.get_signal_sampling_rate());

    % Create an instance of the Kilosort3Sorter class
    sorter = Kilosort3Sorter();

    % Initialize the folder for Kilosort3 inputs
    sorter = sorter.initialize_folder(folder);

    % Set the parameters and save them to the folder
    sorter.set_params_to_folder(recording);

    % Setup the recording by saving it to a binary file
    sorter.setup_recording(recording);

    % Run KiloSort3 
    kilosort3_master(fpath, kilosortPath); 
end