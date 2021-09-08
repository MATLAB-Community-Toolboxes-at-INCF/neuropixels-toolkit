classdef KiloSort < pipeline.TaskBase
    %KiloSort Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        task_input
        task_result
    end
    
    methods
        function obj = execute(obj)
            obj.task_result = strcat(obj.task_input, ' KiloSort result');
        end
    end
end

