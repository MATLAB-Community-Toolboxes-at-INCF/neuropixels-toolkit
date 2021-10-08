classdef KiloSort < npxtoolkit.tasks.TaskBase
    %KiloSort Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        taskInfo
        input
        output
    end
    
    methods
        function obj = KiloSort(taskInfo, input)
            obj.taskInfo = taskInfo;
            obj.input = input;
        end
        
        function execute(obj)
            disp(strcat("Running task: ", obj.taskInfo))
        end
    end
end

