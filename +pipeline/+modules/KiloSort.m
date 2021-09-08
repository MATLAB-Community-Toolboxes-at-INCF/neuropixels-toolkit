classdef KiloSort < pipeline.StageBase
    %KiloSort Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        stage_input
        stage_config
        stage_result
    end
    
    methods
        function obj = execute(obj)
            obj.stage_result = strcat(obj.stage_input, ' KiloSort result');
        end
    end
end

