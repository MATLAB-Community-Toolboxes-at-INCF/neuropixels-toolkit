addpath(genpath(fullfile('../src')));

data_file_path = '/home/jovyan/spikeinterface_datasets/ephy_testing_data/mearec/mearec_test_10s.h5'
folder = 'spikeSort_output'
fpath = fullfile(pwd, folder)
kilosortPath = '/opt/Kilosort-3.0'

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
% kilosort3_master(fpath, kilosortPath); 
try
    set(groot,'defaultFigureVisible', 'off');

    disp('prepare for kilosort execution');
    % prepare for kilosort execution
    addpath(genpath(kilosortPath));

    disp('add npy-matlab functions (copied in the output folder)');
    % add npy-matlab functions (copied in the output folder)
    addpath(genpath(fpath));

    disp('Load channel map file');
    % Load channel map file
    load(fullfile(fpath, 'chanMap.mat'));

    disp('Load the configuration file, it builds the structure of options (ops)');
    % Load the configuration file, it builds the structure of options (ops)
    load(fullfile(fpath, 'ops.mat'));

    disp('preprocess data to create temp_wh.dat');
    % preprocess data to create temp_wh.dat
    rez = preprocessDataSub(ops);

    disp('run data registration')
    % run data registration
    if isfield(ops, 'do_correction')
        do_correction = ops.do_correction;
    else
        do_correction = 1;
    end

    if do_correction
        fprintf("Drift correction ENABLED\n");
    else
        fprintf("Drift correction DISABLED\n");
    end

    disp('Aligns or corrects drifts in the recording')
    rez = datashift2(rez, do_correction); % last input is for shifting data

    [rez, st3, tF] = extract_spikes(rez);

    rez = template_learning(rez, tF, st3);

    [rez, st3, tF] = trackAndSort(rez);

    rez = final_clustering(rez, tF, st3);

    % final merges
    rez = find_merges(rez, 1);

    % output to phy
    fprintf('Saving results to Phy\n')
    rezToPhy2(rez, fpath);

catch
    fprintf('----------------------------------------');
    fprintf(lasterr());
    % quit(1);
end