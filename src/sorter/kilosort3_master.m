function kilosort3_master(fpath, kilosortPath)
    % Main script to execute the spike sorting pipeline with default or user-provided arguments.
    %
    % - fpath: Path to the folder for Kilosort3 output.
    % - kilosortPath: Path to the Kilosort3 toolbox.

    % Default argument values
    if nargin < 1 || isempty(fpath)
        fpath = './kilosort3_output';
    end
    if nargin < 2 || isempty(kilosortPath)
        kilosortPath = '/opt/Kilosort-3.0';
    end
    
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
    % quit(0);
end

