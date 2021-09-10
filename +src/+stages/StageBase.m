classdef (Abstract) StageBase < handle
    %TaskBase is an abstract class for a pipeline task
    %   Detailed explanation goes here
    
    properties(Abstract)
        stage_input
        stage_config
        stage_result
    end
    
    methods(Abstract)
        stage_result = execute(obj)
    end
end

