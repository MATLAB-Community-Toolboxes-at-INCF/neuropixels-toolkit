classdef CatGT < src.stages.StageBase
    %CatGT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        stage_input
        stage_config
        stage_result
    end
    
    methods
        function obj = execute(obj)
            obj.stage_result = strcat(obj.stage_input, ' CatGT result');
        end
    end
end

