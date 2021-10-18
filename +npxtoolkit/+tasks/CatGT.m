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
            runFolderName = strcat(config.RunName, '_g', config.GateIdx);
            probFolderName = strcat(runFolderName, '_imec', '0'); % TODO-probe #
            probFolder = fullfile(config.NpxDir, runFolderName, probFolderName);
            probList = cell(py.py_modules.caller.ParseProbeStr(config.Probes)); % TODO-reduce python 
            trigs = cell(py.py_modules.caller.ParseTrigStr(config.Triggers, probList{1}, config.GateIdx, probFolder)); % TODO-reduce python
            firstTrig = string(int64(trigs{1}));
            lastTrig = string(int64(trigs{2}));
            triggerStr = strcat(firstTrig, ',', lastTrig);
            disp(triggerStr);
        end
    end
end

