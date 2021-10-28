classdef CatGT < npxtoolkit.tasks.TaskBase
    %CatGT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Info
        Config
        Output
    end
    
    methods
        function obj = CatGT(taskInfo, taskConfig)
            obj.Info = taskInfo;
            obj.Config = taskConfig;
        end
        
        function execute(obj)
            disp(strcat("Running task: ", obj.Info));
            config = obj.Config;

            prb = '0'; % TODO - probe number, pass from task init
            taskIdx = 1; % TODO - first task in taskQueue

            runFolderName = strcat(config.RunName, '_g', config.GateIdx);
            probFolderName = strcat(runFolderName, '_imec', prb);
            probFolder = fullfile(config.NpxDir, runFolderName, probFolderName);
            triggerList = obj.parseTriggerStr(config.Triggers, prb, config.GateIdx, probFolder);
            firstTrig = string(triggerList{1});
            lastTrig = string(triggerList{2});
            triggerStr = strcat(firstTrig, ',', lastTrig);
            
            disp(strcat('Creating json file for CatGT on probe: ', prb));
            catGTInputJson = fullfile(config.JsonDir, strcat(config.RunName, prb, '_CatGT', '-input.json'));
            disp(catGTInputJson);
            catGTOutputJson = fullfile(config.JsonDir, strcat(config.RunName, prb, '_CatGT', '-output.json'));
            
            % build extract string for SYNC channel for this probe
            syncExtract = strcat(' -SY=', prb, ',-1,6,500');

            % if this is the first probe proceessed, process the ni stream with it
            if taskIdx == 1 && config.NiPresent
                catGTStreamString = '-ap -ni';
                extractString = strcat(syncExtract, ' ', config.NiExtractStr);
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
                    'ecephys_directory', config.EcephysDir,...
                    'kilosort_repository', config.KilosortRepo,...
                    'KS2ver', config.KSver,...
                    'npy_matlab_repository', config.NpyMatlabRepo,...
                    'catGTPath', config.CatGTPath,...
                    'tPrime_path', config.TPrimePath,...
                    'cWaves_path', config.CWavesPath,...
                    'kilosort_output_tmp', config.KilosortOutputTmp,...
                    'npx_directory', config.NpxDir,...
                    'continuous_file', continuousFile,...
                    'kilosort_output_directory', config.CatGTDest,...
                    'spikeGLX_data', config.SpikeGLXData,...
                    'input_meta_path', inputMetaFullpath,...
                    'catGT_run_name', config.RunName,...
                    'gate_string', config.GateIdx,...
                    'trigger_string', triggerStr,...
                    'probe_string', prb,...
                    'catGT_stream_string', catGTStreamString,...
                    'catGT_car_mode', config.CarMode,...
                    'catGT_loccar_min_um', config.LoccarMin,...
                    'catGT_loccar_max_um', config.LoccarMax,...
                    'catGT_cmd_string', strcat(config.CatGTCmdStr, ' ', extractString),...
                    'extracted_data_directory', config.CatGTDest...
                )...
            );

            if config.RunCatGT
                % TODO - reduce python
                params = strcat("-W ignore -m ecephys_spike_sorting.modules.catGT_helper",...
                                " --input_json ", catGTInputJson,...
                                " --output_json ", catGTOutputJson);
                py.py_modules.caller.call_python(params);
            end
            % TODO - specify output dir
        end
    end

    methods (Static)
        function trailRange = getTrailRange(prb, gate, prbFolder)
            tFiles = dir(fullfile(prbFolder,'*.bin'));
            minIndex =  intmax;
            maxIndex = 0;
            searchStr = strcat('_g', gate, '_t');
            % for tName in tFiles:
            %     if (fnmatch.fnmatch(tName,'*.bin')):
            %         gPos = tName.find(searchStr)
            %         tStart = gPos + len(searchStr)
            %         tEnd = tName.find('.', tStart)
                    
            %         if gPos > 0 and tEnd > 0:
            %             try:
            %                 tInd = int(tName[tStart:tEnd])                    
            %             except ValueError:
            %                 print(tName[tStart:tEnd])
            %                 print('Error parsing trials for probe folder: ' + prb_folder + '\n')
            %                 return -1, -1
            %         else:
            %             print('Error parsing trials for probe folder: ' + prb_folder + '\n')
            %             return -1, -1
                    
            %         if tInd > maxIndex:
            %             maxIndex = tInd
            %         if tInd < minIndex:
            %             minIndex = tInd
                        
            % return minIndex, maxIndex
            trailRange = [0,0];
        end

        function triggerList = parseTriggerStr(triggerStr, prb, gate, prbFolder)
            strList = split(triggerStr, ',');
            firstTrigStr = strList{1};
            lastTrigStr = strList{2};
            
            if contains(lastTrigStr, 'end') || contains(firstTrigStr, 'start')
                % TODO - npxtoolkit.tasks.CatGT.getTrailRange()
                minInd = 0;
                maxInd = 0;
            end

            if contains(firstTrigStr, 'start')
                firstTrig = minInd;
            else
                firstTrig = str2num(firstTrigStr);
            end
            
            if contains(lastTrigStr, 'end')
                lastTrig = maxInd;
            else
                lastTrig = str2num(lastTrigStr);
            end

            triggerList = {firstTrig, lastTrig};
        end
    end
end

