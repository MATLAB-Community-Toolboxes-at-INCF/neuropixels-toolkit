classdef PipelineConfig < npxtoolkit.config.Config
    %PipelineConfig Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Tools
        Data
    end

    methods
        function obj = PipelineConfig(configs)
            obj.Tools = configs.tools;
            obj.Data = configs.data;
        end
    end
end