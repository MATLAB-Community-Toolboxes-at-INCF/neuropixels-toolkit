classdef Pipeline < matlab.mixin.Heterogeneous & handle
    %Pipeline Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Info
        PipelineConfigs
        CurrentStage
        Stages
        StageVal = ["CatGT", "KiloSort", "TPrime"]
        L
    end
    
    methods
        function obj = Pipeline(pipelineInfo, config_path, logger)
            import npxtoolkit.internal.config.PipelineConfig
            import npxtoolkit.internal.thirdparty.logging.log4m
            obj.Info = pipelineInfo;
            obj.PipelineConfigs = PipelineConfig(config_path);
            obj.CurrentStage = -1;
            obj.Stages = [];
            obj.L = log4m.getLogger("npx.log");
        end

        function obj = addStage(obj, stage)
            obj.Stages = [obj.Stages, stage];
        end
        
        function obj = autoAssemble(obj)
            import npxtoolkit.stage.Stage
            import npxtoolkit.tasks.CatGT
            import npxtoolkit.tasks.KiloSort
            import npxtoolkit.tasks.TPrime
            obj.L.info("Pipeline.m", "Auto-assembling a pipeline based on the config file...");
            for stageName = obj.StageVal
                stage = Stage(stageName);
                obj.addStage(stage);
                probeList = obj.parseProbeStr(obj.PipelineConfigs.Data.probes);
                brainRegions = obj.PipelineConfigs.Data.brainRegions;
                for i = 1:length(probeList)
                    probe = probeList{i};
                    brainRegion = brainRegions{i};
                    if stageName == "CatGT"
                        obj.L.info("Pipeline.m", "Adding CatGT for probe " + probe);
                        task = CatGT("CatGT probe" + probe, probe, i, obj.PipelineConfigs);
                    elseif stageName == "KiloSort"
                        obj.L.info("Pipeline.m", "Adding KiloSort for probe " + probe);
                        task = KiloSort("KiloSort probe " + probe, probe, brainRegion, obj.PipelineConfigs);
                    elseif stageName == "TPrime"
                        obj.L.info("Pipeline.m", "Adding TPrime for probe " + probe);
                        task = TPrime("TPrime probe " + probe, probe, obj.PipelineConfigs);
                    end
                    stage.addTask(task);
                end
            end
        end

        function execute(obj)
            % stages have to run in sequence, because of result dependency
            for curr = obj.Stages
                obj.CurrentStage = curr;
                obj.L.info("Pipeline.m - " + obj.Info, "Executing Stage: " + curr.Info);
                curr.parExecute();
            end
        end
    end
    
    methods(Static)
        function probeList = parseProbeStr(probeStr)
            strList = split(probeStr, ',');
            probeList = {};
            for i=1:length(strList)
                substr = strList{i};
                if contains(substr, ':')
                    subsplit = split(substr, ':');
                    for i=str2num(subsplit{1}):str2num(subsplit{2})
                        probeList{end+1} = int2str(i);
                    end
                else
                    probeList{end+1} = substr;
                end
            end
        end
    end
end
