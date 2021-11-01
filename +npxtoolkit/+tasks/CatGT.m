classdef CatGT < npxtoolkit.tasks.TaskBase
    %CatGT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Info
        Probe
        Order
        CommonConfig
        CustomConfig
        Output
    end
    
    methods
        function obj = CatGT(taskInfo, probe, order, taskConfig)
            obj.Info = taskInfo;
            obj.Probe = probe;
            obj.Order = order;
            taskConfig.Configs.runCatGT = str2num(taskConfig.Configs.runCatGT);
            taskConfig.Configs.niPresent = str2num(taskConfig.Configs.niPresent);
            obj.CustomConfig = taskConfig;
        end
        
        function execute(obj)
            disp(strcat("Running task: ", obj.Info));
            names = [fieldnames(obj.CommonConfig.Tools); fieldnames(obj.CommonConfig.Data); fieldnames(obj.CustomConfig.Configs)];
            config = cell2struct([struct2cell(obj.CommonConfig.Tools); struct2cell(obj.CommonConfig.Data); struct2cell(obj.CustomConfig.Configs)], names, 1);

            prb = obj.Probe;
            taskIdx = obj.Order;

            runFolderName = strcat(config.runName, '_g', config.gateIdx);
            probFolderName = strcat(runFolderName, '_imec', prb);
            probFolder = fullfile(config.npxDir, runFolderName, probFolderName);
            triggerList = obj.parseTriggerStr(config.triggers, prb, config.gateIdx, probFolder);
            firstTrig = string(triggerList{1});
            lastTrig = string(triggerList{2});
            triggerStr = strcat(firstTrig, ',', lastTrig);
            
            disp(strcat('Creating json file for CatGT on probe: ', prb));
            catGTInputJson = fullfile(config.jsonDir, strcat(config.runName, prb, '_CatGT', '-input.json'));
            disp(catGTInputJson);
            catGTOutputJson = fullfile(config.jsonDir, strcat(config.runName, prb, '_CatGT', '-output.json'));
            
            % build extract string for SYNC channel for this probe
            syncExtract = strcat(' -SY=', prb, ',-1,6,500');

            % if this is the first probe proceessed, process the ni stream with it
            if taskIdx == 1 && config.niPresent
                catGTStreamString = '-ap -ni';
                extractString = strcat(syncExtract, ' ', config.niExtractStr);
            else
                catGTStreamString = '-ap';
                extractString = syncExtract;
            end

            inputDataDirectory = probFolder;
            fileName = strcat(runFolderName, '_t', firstTrig, '.imec', prb, '.ap.bin');
            continuousFile = fullfile(inputDataDirectory, fileName);
            metaName = strcat(runFolderName, '_t', firstTrig, '.imec', prb, '.ap.meta');
            inputMetaFullpath = fullfile(inputDataDirectory, metaName);

            info = py.py_modules.caller.createInputJson(...
                pyargs(...
                    'output_file', catGTInputJson,...
                    'ecephys_directory', config.ecephysDir,...
                    'kilosort_repository', config.kilosortRepo,...
                    'KS2ver', config.KSver,...
                    'npy_matlab_repository', config.npyMatlabRepo,...
                    'catGTPath', config.catGTPath,...
                    'tPrime_path', config.tPrimePath,...
                    'cWaves_path', config.cWavesPath,...
                    'kilosort_output_tmp', config.kilosortOutputTmp,...
                    'npx_directory', config.npxDir,...
                    'continuous_file', continuousFile,...
                    'kilosort_output_directory', config.catGTDest,...
                    'spikeGLX_data', config.spikeGLXData,...
                    'input_meta_path', inputMetaFullpath,...
                    'catGT_run_name', config.runName,...
                    'gate_string', config.gateIdx,...
                    'trigger_string', triggerStr,...
                    'probe_string', prb,...
                    'catGT_stream_string', catGTStreamString,...
                    'catGT_car_mode', config.carMode,...
                    'catGT_loccar_min_um', config.loccarMin,...
                    'catGT_loccar_max_um', config.loccarMax,...
                    'catGT_cmd_string', strcat(config.catGTCmdStr, ' ', extractString),...
                    'extracted_data_directory', config.catGTDest...
                )...
            );

            if config.runCatGT
                % TODO - reduce python
                params = strcat("-W ignore -m ecephys_spike_sorting.modules.catGT_helper",...
                                " --input_json ", catGTInputJson,...
                                " --output_json ", catGTOutputJson);
                py.py_modules.caller.call_python(params);
            end
        end
    end
end

