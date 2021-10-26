classdef KiloSort < npxtoolkit.tasks.TaskBase
    %KiloSort Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Info
        Config
        Output
    end
    
    methods
        function obj = KiloSort(taskInfo, taskConfig)
            obj.Info = taskInfo;
            obj.Config = taskConfig;
        end
        
        function execute(obj)
            disp(strcat("Running task: ", obj.Info));
            config = obj.Config;

            prb = '0'; % TODO - probe number, pass from task init

            runFolderName = strcat(config.RunName, '_g', config.GateIdx);
            catGTResultFolderName = strcat('catgt_', runFolderName);
            probFolderName = strcat(runFolderName, '_imec', prb);
            

            moduleInputJson = fullfile(config.JsonDir, strcat(runFolderName, '-input.json'));
            disp(moduleInputJson);
        end
    end
end

