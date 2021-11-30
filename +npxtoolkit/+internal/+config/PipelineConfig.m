classdef PipelineConfig < npxtoolkit.internal.config.Config
    %PipelineConfig Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Tools
        Data
        CatGT
        KiloSort
        TPrime
    end

    methods
        function obj = PipelineConfig(config_fpath)
            configs = obj.parseJson(config_fpath);
            pipeline_config = configs.pipeline;
            pipeline_config.tools.kilosortRepo = strcat(pipeline_config.tools.kilosortRepo, pipeline_config.tools.KSver);
            obj.Tools = pipeline_config.tools;
            pipeline_config.data.npxDir = fullfile(pipeline_config.data.rootDataDir, pipeline_config.data.dataDir);
            pipeline_config.data.catGTDest = pipeline_config.data.npxDir;
            pipeline_config.data.spikeGLXData = str2num(pipeline_config.data.spikeGLXData);
            obj.Data = pipeline_config.data;
            obj.CatGT = configs.CatGT;
            obj.KiloSort = configs.KiloSort;
            obj.TPrime = configs.TPrime;
        end
    end
end