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
        function obj = CatGT(taskInfo, probe, order, configs)
            import npxtoolkit.internal.thirdparty.logging.log4m
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
            obj.L = log4m.getLogger("npx.log");
        end
        
        function execute(obj)
            obj.L.info("CatGT.m", "Running task: " + obj.Info);
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
            
            obj.L.info("CatGT.m - " + obj.Info, "Creating json file for CatGT on probe: " + prb);
            catGTInputJson = fullfile(configs.jsonDir, strcat(configs.runName, prb, "_CatGT", "-input.json"));
            catGTOutputJson = fullfile(configs.jsonDir, strcat(configs.runName, prb, "_CatGT", "-output.json"));
            
            % build extract string for SYNC channel for this probe
            syncExtract = strcat(" -SY=", prb, ",-1,6,500");

            % if this is the first probe proceessed, process the ni stream with it
            if taskIdx == 1 && configs.niPresent
                catGTStreamString = "-ap -ni";
                extractString = strcat(syncExtract, ' ', configs.niExtractStr);
            else
                catGTStreamString = "-ap";
                extractString = syncExtract;
            end

            inputDataDirectory = probFolder;
            fileName = strcat(runFolderName, "_t", firstTrig, ".imec", prb, ".ap.bin");
            continuousFile = fullfile(inputDataDirectory, fileName);
            metaName = strcat(runFolderName, "_t", firstTrig, ".imec", prb, ".ap.meta");
            inputMetaFullpath = fullfile(inputDataDirectory, metaName);

            if configs.runCatGT
                obj.runCatGT(catGTInputJson, inputMetaFullpath, triggerStr, prb, catGTStreamString, extractString, configs);
            else
                obj.L.info("CatGT.m - " + obj.Info, "Skipped!");
            end
        end

        function runCatGT(obj, catGTInputJson, inputMetaFullpath, triggerStr, prb, catGTStreamString, extractString, configs)
            obj.L.info("CatGT.m - " + obj.Info, "ecephys spike sorting: CatGT helper module");

            catGTPath = configs.catGTPath;
            if ispc
                % # build windows command line
                catGTexe_fullpath = strrep(catGTPath, '/', '\\') + "/runit.bat";
            elseif isunix || ismac
                catGTexe_fullpath = strrep(catGTPath, '\\', '/') + "/runit.sh";
            else
                obj.L.info("CatGT.m - " + obj.Info, 'unknown system, cannot run CatGt');
            end
            
            % # common average referencing
            car_mode = configs.carMode;
            if car_mode == 'loccar'
                inner_site = configs.loccarMin;
                outer_site = configs.loccarMax;
                car_str = ' -loccar=' + num2str(inner_site) + ',' + num2str(outer_site);
            elseif car_mode == 'gbldmx'
                car_str = ' -gbldmx'; 
            elseif car_mode == 'gblcar'
                car_str = ' -gblcar';
            elseif car_mode == 'None' or car_mode == 'none':
                car_str = '';
            end

            cmd = catGTexe_fullpath + ...
                ' -dir='+configs.npxDir + ...
                ' -run='+configs.runName + ...
                ' -g='+configs.gateIdx + ...
                ' -t='+triggerStr + ...
                ' -prb='+prb + ...
                ' '+catGTStreamString + ...
                ' '+car_str + ...
                ' '+strcat(configs.catGTCmdStr, ' ', extractString) + ...
                ' -dest='+configs.catGTDest;
            obj.L.debug("CatGT.m - " + obj.Info, "CatGT command line:"+cmd);
            tic;
            system(cmd);
            toc;
        end

        function prb_title = ParseProbeStr(obj, probe_string)
            % # from a probe_string in a CatGT command line
            % # create a title for the log file which inludes all the 
            % # proceessed probes
            
            str_list = split(probe_string, ',');
            prb_title = '';
            for substr=str_list
                if contains(substr, ':')
                    % # split at colon
                    subsplit = split(substr, ':');
                    for i=str2num(subsplit(1)):str2num(subsplit(2))
                        prb_title = prb_title + "_" + num2str(i);
                    end
                else
                    % # just append this string
                    prb_title = prb_title + "_" + substr;
                end
            end
        end
    end
end

