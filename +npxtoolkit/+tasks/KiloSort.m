classdef KiloSort < npxtoolkit.tasks.TaskBase
    %KiloSort Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        TaskInfo
        Input
        Output
    end
    
    methods
        function obj = KiloSort(taskInfo, input)
            obj.TaskInfo = taskInfo;
            obj.Input = input;
        end
        
        function execute(obj)
            disp(strcat("Running task: ", obj.TaskInfo))
        end
    end
end

