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
        end
    end
end

