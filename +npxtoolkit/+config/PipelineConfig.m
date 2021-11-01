classdef PipelineConfig < npxtoolkit.config.Config
    %PipelineConfig Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Tools
        Data
    end

    methods
        function obj = PipelineConfig(configs)
            configs.tools.kilosortRepo = strcat(configs.tools.kilosortRepo, configs.tools.KSver);
            obj.Tools = configs.tools;
            configs.data.npxDir = fullfile(configs.data.rootDataDir, configs.data.dataDir);
            configs.data.catGTDest = configs.data.npxDir;
            configs.data.spikeGLXData = str2num(configs.data.spikeGLXData);
            obj.Data = configs.data;
        end
    end
end