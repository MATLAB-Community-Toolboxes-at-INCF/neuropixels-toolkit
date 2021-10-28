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
            obj.Tools.kilosortRepo = strcat(obj.Tools.kilosortRepo, obj.Tools.KSver);
            obj.Data = configs.data;
            obj.Data.npxDir = fullfile(obj.Data.rootDataDir, obj.Data.dataDir);
        end
    end
end