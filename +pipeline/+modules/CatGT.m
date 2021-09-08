classdef CatGT < pipeline.TaskBase
    %CatGT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        task_input
        task_config
        task_result
    end
    
    methods
        function obj = execute(obj)
            obj.task_result = strcat(obj.task_input, ' CatGT result');
        end
    end
end

