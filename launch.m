%% Static Variables
%PYENV_PATH = 'C:\ProgramData\Anaconda3\envs\spike_sorting\python.exe';
PYENV_PATH = '/home/ubuntu/anaconda3/envs/spike_sorting/bin/python';


%% Pipeline ENV Configuration
% load python modules
pe = pyenv();
if pe.Status == "NotLoaded"
    pyenv('Version', PYENV_PATH);
end
caller = py.importlib.import_module('py_modules.caller');
py.importlib.reload(caller);


%% Pipeline Input
% -------------------------------
% -------------------------------
% User input -- Edit this section
% -------------------------------
% -------------------------------

% brain region specific params
% can add a new brain region by adding the key and value for each param
% can add new parameters -- any that are taken by create_input_json --
% by adding a new dictionary with entries for each region and setting the 
% according to the new dictionary in the loop to that created json files.
refPerMS_dict = containers.Map();
refPerMS_dict('default') = 2.0;
refPerMS_dict('cortex') = 2.0;
refPerMS_dict('medulla') = 1.5;
refPerMS_dict('thalamus') = 1.0;

% threhold values appropriate for KS2, KS2.5
ksTh_dict = containers.Map();
ksTh_dict('default') = '[10,4]';
ksTh_dict('cortex') = '[10,4]';
ksTh_dict('medulla') = '[10,4]';
ksTh_dict('thalamus') = '[10,4]';
% threhold values appropriate for KS3.0
% ksTh_dict = containers.Map();
% ksTh_dict('default') = '[9,9]';
% ksTh_dict('cortex') = '[9,9]';
% ksTh_dict('medulla') = '[9,9]';
% ksTh_dict('thalamus') = '[9,9]';

% -----------
% External tool/module path
% -----------
ecephys_directory = '/home/ubuntu/neuropixel/ecephys_spike_sorting/ecephys_spike_sorting';
KS2ver = '3.0';
kilosort_repository = strcat('/home/ubuntu/neuropixel/Kilosort-', KS2ver);
npy_matlab_repository = '/home/ubuntu/neuropixel/npy-matlab';
catGTPath = '/home/ubuntu/neuropixel/CatGT-linux';
tPrime_path = '/home/ubuntu/neuropixel/TPrime-linux';
cWaves_path = '/home/ubuntu/neuropixel/C_Waves-linux';
kilosort_output_tmp = '/home/ubuntu/neuropixel/data_for_ecephys/kilosort_datatemp';

% -----------
% Input data
% -----------
% path_sep = '\';
path_sep = '/';
% root_data_dir = 'C:\SFTP_Root\data_for_ecephys';
root_data_dir = '/home/ubuntu/neuropixel/data_for_ecephys';
data_dir = strcat(root_data_dir, path_sep, 'subject1_session1');

% Name for log file for this pipeline run. Log file will be saved in the
% output destination directory catGT_dest
% If this file exists, new run data is appended to it
logName = 'SC024_log.csv';

% Raw data directory = npx_directory
% run_specs = name, gate, trigger and probes to process
% npx_directory = 'D:\ecephys_fork\test_data\SC_10trial';
npx_directory = data_dir;

% Each run_spec is a list of 4 strings:
%   undecorated run name (no g/t specifier, the run field in CatGT)
%   gate index, as a string (e.g. '0')
%   triggers to process/concatenate, as a string e.g. '0,400', '0,0 for a single file
%           can replace first limit with 'start', last with 'end'; 'start,end'
%           will concatenate all trials in the probe folder
%   probes to process, as a string, e.g. '0', '0,3', '0:3'
%   brain regions, list of strings, one per probe, to set region specific params
%           these strings must match a key in the param dictionaries above.

% run_specs = {                                    
%     {'SC024_092319_NP1.0_Midbrain', '0', '0,9', '0,1', ["cortex" "cortex"]}
% };
run_specs = {                                    
    {'SC011_021919', '0', '0,0', '0,1,2', {'cortex' 'thalamus' 'default'}}
};

% ------------------
% Output destination
% ------------------
% Set to an existing directory; all output will be written here.
% Output will be in the standard SpikeGLX directory structure:
% run_folder/probe_folder/*.bin
catGT_dest = data_dir;

% ------------
% CatGT params
% ------------
run_CatGT = false;   % set to false to sort/process previously processed data.


% CAR mode for CatGT. Must be equal to 'None', 'gbldmx', 'gblcar' or 'loccar'
car_mode = 'gblcar';
% inner and outer radii, in um for local comman average reference, if used
loccar_min = 40;
loccar_max = 160;

% CatGT commands for bandpass filtering, artifact correction, and zero filling
% Note 1: directory naming in this script requires -prb_fld and -out_prb_fld
% Note 2: this command line includes specification of edge extraction
% see CatGT readme for details
% these parameters will be used for all runs
% -aphipass retired: catGT_cmd_string = '-prb_fld -out_prb_fld -aphipass=300 -gfix=0.4,0.10,0.02 -tshift';
% -tshift will be called automatically
catGT_cmd_string = '-prb_fld -out_prb_fld -gfix=0.4,0.10,0.02 ';

% missing nibq.meta error: ni_present = true;
ni_present = true;
ni_extract_string = ' -XA=0,1,3,500 -iXA=1,3,3,0  -XD=-1,1,50 -XD=-1,2,1.7 -XD=-1,3,5 -iXD=-1,3,5';



% ----------------------
% KS2 or KS25 parameters
% ----------------------
% parameters that will be constant for all recordings
% Template ekmplate radius and whitening, which are specified in um, will be 
% translated into sites using the probe geometry.
ks_remDup = 0;
ks_saveRez = 1;
ks_copy_fproc = 0;
ks_templateRadius_um = 163;
ks_whiteningRadius_um = 163;
ks_minfr_goodchannels = 0.1;


% ----------------------
% C_Waves snr radius, um
% ----------------------
c_Waves_snr_um = 160;

% ----------------------
% psth_events parameters
% ----------------------
% extract param string for psth events -- copy the CatGT params used to extract
% events that should be exported with the phy output for PSTH plots
% If not using, remove psth_events from the list of modules
event_ex_param_str = 'XD=-1,1,50';

% -----------------
% TPrime parameters
% -----------------
runTPrime = true;   % set to false if not using TPrime
sync_period = 1.0;   % true for SYNC wave generated by imec basestation
toStream_sync_params = 'SY=0,-1,6,500';  % copy from the CatGT command line, no spaces
niStream_sync_params = 'XA=0,1,3,500';   % copy from the CatGT comman line, set to None if no Aux data, no spaces

% ---------------
% Modules List
% ---------------
% List of modules to run per probe; CatGT and TPrime are called once for each run.
modules = {
    'kilosort_helper'...
    'kilosort_postprocessing'...
    'noise_templates'...
    'mean_waveforms'...
    'quality_metrics'...
};
%modules = {...
%    'kilosort_helper'...
%    'kilosort_postprocessing'...
%    'noise_templates'...
%    'psth_events'...
%    'mean_waveforms'...
%    'quality_metrics'...
%};

% json_directory = 'D:\ecephys_fork\json_files';
json_directory = '/home/ubuntu/neuropixel/neuropixels-toolkit/configs';

% -----------------------
% -----------------------
% End of user input
% -----------------------
% -----------------------

logFullPath = fullfile(catGT_dest, logName);
if isfile(logFullPath)
    % create the log file, write header
    py.py_modules.caller.writeHeader(logFullPath);
end

for curr = run_specs
    spec = curr{:};
    
    session_id = spec{1};
    gate_index = spec{2};
    concat_trigger = spec{3};
    probes = spec{4};
    brain_regions = spec{5};
    
    % Make list of probes from the probe string
    prob_list = cell(py.py_modules.caller.ParseProbeStr(probes));
    
    % build path to the first probe folder; look into that folder
    % to determine the range of trials if the user specified t limits as
    % start and end
    run_folder_name = strcat(session_id,'_g', gate_index);
    prb0_fld_name = strcat(run_folder_name, '_imec', prob_list{1});
    prb0_fld = fullfile(npx_directory, run_folder_name, prb0_fld_name);
    trigs = cell(py.py_modules.caller.ParseTrigStr(concat_trigger, prob_list{1}, gate_index, prb0_fld));
    first_trig = string(int64(trigs{1}));
    last_trig = string(int64(trigs{2}));
    trigger_str = strcat(first_trig, ',', last_trig);
    
    % loop over all probes to build json files of input parameters
    % initalize lists for input and output json files
    catGT_input_json = cell(length(run_specs),1);
    catGT_output_json = cell(length(run_specs),1);
    module_input_json = cell(length(run_specs),1);
    module_output_json = cell(length(run_specs),1);
    session_ids = cell(length(run_specs),1);
    data_directory = cell(length(run_specs),1);
    
    for i=1:length(prob_list)
        prb = string(prob_list{i});
        % create CatGT command for this probe
        disp(strcat('Creating json file for CatGT on probe: ', prb));
        % Run CatGT
        catGT_input_json{i} = fullfile(json_directory, strcat(session_id, prb, '_CatGT', '-input.json'));
        catGT_output_json{i} = fullfile(json_directory, strcat(session_id, prb, '_CatGT', '-output.json'));

        % build extract string for SYNC channel for this probe
        sync_extract = strcat(' -SY=', prb, ',-1,6,500');

        % if this is the first probe proceessed, process the ni stream with it
        if i == 1 && ni_present
            catGT_stream_string = '-ap -ni';
            extract_string = strcat(sync_extract, ' ', ni_extract_string);
        else
            catGT_stream_string = '-ap';
            extract_string = sync_extract;
        end
    
        % build name of first trial to be concatenated/processed;
        % allows reaidng of the metadata
        run_str = strcat(spec{1}, '_g', spec{2}); 
        run_folder = run_str;
        prb_folder = strcat(run_str, '_imec', prb);
        input_data_directory = fullfile(npx_directory, run_folder, prb_folder);
        fileName = strcat(run_str, '_t', first_trig, '.imec', prb, '.ap.bin');
        continuous_file = fullfile(input_data_directory, fileName);
        metaName = strcat(run_str, '_t', first_trig, '.imec', prb, '.ap.meta');
        input_meta_fullpath = fullfile(input_data_directory, metaName);

        disp(input_meta_fullpath);

        info = py.py_modules.caller.createInputJson(...
            pyargs(...
                'output_file', catGT_input_json{i},...
                'ecephys_directory', ecephys_directory,...
                'kilosort_repository', kilosort_repository,...
                'KS2ver', KS2ver,...
                'npy_matlab_repository', npy_matlab_repository,...
                'catGTPath', catGTPath,...
                'tPrime_path', tPrime_path,...
                'cWaves_path', cWaves_path,...
                'kilosort_output_tmp', kilosort_output_tmp,...
                'npx_directory', npx_directory,...
                'continuous_file', continuous_file,...
                'kilosort_output_directory', catGT_dest,...
                'spikeGLX_data', true,...
                'input_meta_path', input_meta_fullpath,...
                'catGT_run_name', spec{1},...
                'gate_string', spec{2},...
                'trigger_string', trigger_str,...
                'probe_string', prb,...
                'catGT_stream_string', catGT_stream_string,...
                'catGT_car_mode', car_mode,...
                'catGT_loccar_min_um', loccar_min,...
                'catGT_loccar_max_um', loccar_max,...
                'catGT_cmd_string', strcat(catGT_cmd_string, ' ', extract_string),...
                'extracted_data_directory', catGT_dest...
            )...
        );
                
    % create json files for the other modules
    session_ids{i} = strcat(spec{1},'_imec', prb);

    module_input_json{i} = fullfile(json_directory, strcat(session_ids{i}, '-input.json'));

    % location of the binary created by CatGT, using -out_prb_fld
    run_str = strcat(spec{1}, '_g', spec{2});
    run_folder = strcat('catgt_', run_str);
    prb_folder = strcat(run_str, '_imec', prb);
    data_directory{i} = fullfile(catGT_dest, run_folder, prb_folder);
    fileName = strcat(run_str, '_tcat.imec', prb, '.ap.bin');
    continuous_file = fullfile(data_directory{i}, fileName);

    outputName = strcat('imec', prb, '_ks2');

    % kilosort_postprocessing and noise_templates moduules alter the files
    % that are input to phy. If using these modules, keep a copy of the
    % original phy output
    if any(strcmp('kilosort_postprocessing', modules)) || any(strcmp('noise_templates', modules))
        ks_make_copy = true;
    else
        ks_make_copy = false;
    end

    kilosort_output_dir = fullfile(data_directory{i}, outputName);
    
    disp(data_directory{i});
    disp(continuous_file);

    % get region specific parameters
    ks_Th = ksTh_dict(spec{5}{i});
    refPerMS = refPerMS_dict(spec{5}{i});
    disp(strcat('ks_Th: ', ks_Th, ' ,refPerMS: ', string(refPerMS)));

    info = py.py_modules.caller.createInputJson(...
        pyargs(...
            'output_file', module_input_json{i},...
            'ecephys_directory', ecephys_directory,...
            'kilosort_repository', kilosort_repository,...
            'KS2ver', KS2ver,...
            'npy_matlab_repository', npy_matlab_repository,...
            'catGTPath', catGTPath,...
            'tPrime_path', tPrime_path,...
            'cWaves_path', cWaves_path,...
            'kilosort_output_tmp', kilosort_output_tmp,...
            'npx_directory', npx_directory,...
            'continuous_file', continuous_file,...
            'spikeGLX_data', true,...
            'input_meta_path', input_meta_fullpath,...
            'kilosort_output_directory', kilosort_output_dir,...
            'noise_template_use_rf', false,...
            'catGT_run_name', session_ids{i},...
            'gate_string', spec{2},...
            'probe_string', prb,...
            'ks_remDup', ks_remDup,...                   
            'ks_finalSplits', 1,...
            'ks_labelGood', 1,...
            'ks_saveRez', ks_saveRez,...
            'ks_copy_fproc', ks_copy_fproc,...
            'ks_minfr_goodchannels', ks_minfr_goodchannels,...                  
            'ks_whiteningRadius_um', ks_whiteningRadius_um,...
            'ks_Th', ks_Th,...
            'ks_CSBseed', 1,...
            'ks_LTseed', 1,...
            'ks_templateRadius_um', ks_templateRadius_um,...
            'extracted_data_directory', catGT_dest,...
            'event_ex_param_str',  event_ex_param_str,...
            'c_Waves_snr_um', c_Waves_snr_um,...                   
            'qm_isi_thresh', (refPerMS/1000)...
        )...
    );

    % copy json file to data directory as record of the input parameters 
    end
    
    % loop over probes for processing.
    for i=1:length(prob_list)
        prb = prob_list{i};
        py.py_modules.caller.runOne(...
            session_ids{i},...
            json_directory,...
            data_directory{i},...
            run_CatGT,...
            catGT_input_json{i},...
            catGT_output_json{i},...
            modules,...
            module_input_json{i},...
            logFullPath...
        );
    end
end

