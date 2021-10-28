classdef TaskConfig < npxtoolkit.config.Config
    %TaskConfig Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Configs
    end

    methods
        function obj = TaskConfig(configs)
            obj.Configs = configs;
        end
    end
end