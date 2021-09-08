classdef CatGT < pipeline.TaskBase
    %CatGT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        task_input
        task_result
    end
    
    methods
        function obj = CatGT(task_input)
            obj.task_input = task_input;
        end
        
        function execute(obj)
            obj.task_result = strcat(obj.task_input, ' task result');
        end
    end
end

