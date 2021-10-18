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
        end
    end
end

