classdef CatGT < npxtoolkit.tasks.TaskBase
    %CatGT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Info
        Probe
        Order
        Configs
        Output
        L
    end
    
    methods
        function obj = CatGT(taskInfo, probe, order, configs, logger)
            obj.Info = taskInfo;
            obj.Probe = probe;
            obj.Order = order;
            if class(configs.CatGT.runCatGT)=="char"
                configs.CatGT.runCatGT = str2num(configs.CatGT.runCatGT);
            end
            if class(configs.CatGT.niPresent)=="char"
                configs.CatGT.niPresent = str2num(configs.CatGT.niPresent);
            end
            obj.Configs = configs;
            obj.L = logger;
        end
        
        function execute(obj)
            obj.L.info("CatGT.m", strcat("Running task: ", obj.Info));
            names = [fieldnames(obj.Configs.Tools); fieldnames(obj.Configs.Data); fieldnames(obj.Configs.CatGT)];
            configs = cell2struct([struct2cell(obj.Configs.Tools); struct2cell(obj.Configs.Data); struct2cell(obj.Configs.CatGT)], names, 1);

            prb = obj.Probe;
            taskIdx = obj.Order;

            runFolderName = strcat(configs.runName, '_g', configs.gateIdx);
            probFolderName = strcat(runFolderName, '_imec', prb);
            probFolder = fullfile(configs.npxDir, runFolderName, probFolderName);
            triggerList = obj.parseTriggerStr(configs.triggers, prb, configs.gateIdx, probFolder);
            firstTrig = string(triggerList{1});
            lastTrig = string(triggerList{2});
            triggerStr = strcat(firstTrig, ',', lastTrig);
            
            obj.L.info(strcat("CatGT.m - ", obj.Info), strcat('Creating json file for CatGT on probe: ', prb));
            catGTInputJson = fullfile(configs.jsonDir, strcat(configs.runName, prb, '_CatGT', '-input.json'));
            catGTOutputJson = fullfile(configs.jsonDir, strcat(configs.runName, prb, '_CatGT', '-output.json'));
            
            % build extract string for SYNC channel for this probe
            syncExtract = strcat(' -SY=', prb, ',-1,6,500');

            % if this is the first probe proceessed, process the ni stream with it
            if taskIdx == 1 && configs.niPresent
                catGTStreamString = '-ap -ni';
                extractString = strcat(syncExtract, ' ', configs.niExtractStr);
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
                    'ecephys_directory', configs.ecephysDir,...
                    'kilosort_repository', configs.kilosortRepo,...
                    'KS2ver', configs.KSver,...
                    'npy_matlab_repository', configs.npyMatlabRepo,...
                    'catGTPath', configs.catGTPath,...
                    'tPrime_path', configs.tPrimePath,...
                    'cWaves_path', configs.cWavesPath,...
                    'kilosort_output_tmp', configs.kilosortOutputTmp,...
                    'npx_directory', configs.npxDir,...
                    'continuous_file', continuousFile,...
                    'kilosort_output_directory', configs.catGTDest,...
                    'spikeGLX_data', configs.spikeGLXData,...
                    'input_meta_path', inputMetaFullpath,...
                    'catGT_run_name', configs.runName,...
                    'gate_string', configs.gateIdx,...
                    'trigger_string', triggerStr,...
                    'probe_string', prb,...
                    'catGT_stream_string', catGTStreamString,...
                    'catGT_car_mode', configs.carMode,...
                    'catGT_loccar_min_um', configs.loccarMin,...
                    'catGT_loccar_max_um', configs.loccarMax,...
                    'catGT_cmd_string', strcat(configs.catGTCmdStr, ' ', extractString),...
                    'extracted_data_directory', configs.catGTDest...
                )...
            );

            if configs.runCatGT
                % TODO - reduce python
                params = strcat("-W ignore -m ecephys_spike_sorting.modules.catGT_helper",...
                                " --input_json ", catGTInputJson,...
                                " --output_json ", catGTOutputJson);
                obj.L.debug(strcat("CatGT.m - ", obj.Info), strcat("python ", params));
                py.py_modules.caller.call_python(params);
                obj.L.info(strcat("CatGT.m - ", obj.Info), "Done!");
            else
                obj.L.info(strcat("CatGT.m - ", obj.Info), "Skipped!");
            end
        end
    end
end

