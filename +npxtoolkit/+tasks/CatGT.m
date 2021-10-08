classdef CatGT < npxtoolkit.tasks.TaskBase
    %CatGT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        taskInfo
        input
        output
    end
    
    methods
        function obj = CatGT(taskInfo, input)
            obj.taskInfo = taskInfo;
            obj.input = input;
        end
        
        function execute(obj)
            disp(obj.taskInfo);
        end
    end
end

