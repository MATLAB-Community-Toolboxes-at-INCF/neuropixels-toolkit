classdef Kilosort3Sorter
    % A class to prepare and configure data for spike sorting using Kilosort3.
    
    properties
        sorter_output_folder   % Path to the output folder for Kilosort3 input files
        kilosort_params        % Default parameters for Kilosort3
        kilosort3_params       % Additional Kilosort3-specific parameters
        binary_file_path       % Path to the binary recording file
    end
    
    methods
        function obj = Kilosort3Sorter()
            % Constructor to initialize the Kilosort3Sorter class
            obj.sorter_output_folder = ''; % Folder path will be set later
            obj.kilosort3_params = struct( ...
                'trange', [0, Inf], ...
                'spkTh', -6, ...              % detect_threshold
                'Th', [9, 9], ...             % projection threshold
                'ThPre', 8, ...
                'whiteningRange', 32, ...
                'CAR', true, ...
                'minFR', 0.2, ...
                'minfr_goodchannels', 0.2, ...
                'nblocks', 5, ...
                'sig', 20, ...
                'fshigh', 300, ...
                'sigmaMask', 30, ...
                'lam', 20.0, ...
                'nPCs', 3, ...
                'ntbuff', 64, ...
                'nfilt_factor', 4, ...
                'do_correction', true, ...
                'NT', [], ...
                'AUCsplit', 0.8, ...
                'nt0', 61, ...               % wave_length
                'skip_kilosort_preprocessing', false, ...
                'scaleproc', 200.0, ...
                'save_rez_to_mat', false);
        end
        
        function obj = initialize_folder(obj, output_folder)
            % Initializes the output folder for Kilosort3.
            if nargin < 2
                output_folder = fullfile(pwd,'kilosort3_input'); % Default folder name
            end
            obj.sorter_output_folder = output_folder;
            if ~exist(obj.sorter_output_folder, 'dir')
                mkdir(obj.sorter_output_folder);
            end
            obj.binary_file_path = fullfile(obj.sorter_output_folder, 'recording.dat');
        end
        
        function set_params_to_folder(obj, recording)
            % Saves the default parameters and channel map to the output folder.
            params = obj.default_params(recording);
            ops = obj.check_params(params);
            
            % Save to .mat files
            save(fullfile(obj.sorter_output_folder, 'ops.mat'), 'ops');
            chan_map = obj.channel_map(recording);
            save(fullfile(obj.sorter_output_folder, 'chanMap.mat'), "-struct", "chan_map");
        end
        
        function params = check_params(~, params)
            % Validates and processes Kilosort3 parameters.
            if isempty(params.NT)
                params.NT = 64 * 1024 + params.ntbuff;
            else
                params.NT = floor(params.NT / 32) * 32;
            end
            
            if mod(params.nt0, 2) == 0
                params.nt0 = params.nt0 + 1;
            end
            if params.nt0 > 81
                params.nt0 = 81;
            end
            
            % Convert all integer parameters to float
            param_fields = fieldnames(params);
            for i = 1:length(param_fields)
                if isnumeric(params.(param_fields{i}))
                    params.(param_fields{i}) = double(params.(param_fields{i}));
                end
            end
        end
        
        function params = default_params(obj, recording)
            % Generates the default parameter dictionary based on the recording.
            params = obj.kilosort3_params;
            params.NchanTOT = double(recording.nchan);
            params.Nchan = double(recording.nchan);
            params.datatype = 'dat';
            params.fbinary = obj.binary_file_path;
            params.fproc = fullfile(obj.sorter_output_folder, 'temp_wh.dat');
            params.root = obj.sorter_output_folder;
            params.chanMap = fullfile(obj.sorter_output_folder, 'chanMap.mat');
            params.fs = recording.get_signal_sampling_rate();
            params.Th = double(params.Th);
            params.reorder = 1.0;
            params.nskip = 25.0;
            params.GPU = 1.0;
            params.nSkipCov = 25.0;
            params.scaleproc = 200.0;
            params.useRAM = 0.0;
        end
        
        function chan_map = channel_map(obj, recording)
            % Creates the channel map dictionary for Kilosort3.
            chan_map = struct();
            chan_map.Nchannels = int32(recording.nchan);
            chan_map.connected = true(recording.nchan, 1);
            chan_map.chanMap0ind = int32(0:recording.nchan-1);
            chan_map.chanMap = int32(1:recording.nchan);
            chan_map.fs = recording.get_signal_sampling_rate();
            [xcoords, ycoords, kcoords] = recording.get_channel_locations();
            chan_map.xcoords = double(xcoords);
            chan_map.ycoords = double(ycoords);
            chan_map.kcoords = double(kcoords);
        end
        
        function setup_recording(obj, recording)
            % Prepares the recording by saving it to a binary file.
            try
                fid = fopen(obj.binary_file_path, 'w');
                % Get the traces from the recording
                traces = recording.get_traces();
                traces_int16 = int16(traces);
                fwrite(fid, traces_int16, 'int16');
                fclose(fid);
                disp(['Recording saved to ', obj.binary_file_path]);
            catch e
                disp(['Error: ', e.message]);
            end
        end
    end
end
