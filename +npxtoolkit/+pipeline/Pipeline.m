classdef Pipeline < matlab.mixin.Heterogeneous & handle
    %Pipeline Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Info
        PipelineConfig
        CurrentStage
        Stages
        StageVal = ["CatGT", "KiloSort", "TPrime"]
    end
    
    methods
        function obj = Pipeline(pipelineInfo, pipelineConfig)
            obj.Info = pipelineInfo;
            obj.PipelineConfig = pipelineConfig;
            obj.CurrentStage = -1;
            obj.Stages = [];
        end

        function obj = addStage(obj, stage)
            stage.CommonConfigForTask = obj.PipelineConfig;
            obj.Stages = [obj.Stages, stage];
        end
        
        function obj = autoAssemble(obj, json)
            import npxtoolkit.stage.Stage
            import npxtoolkit.config.TaskConfig
            import npxtoolkit.tasks.CatGT
            import npxtoolkit.tasks.KiloSort
            import npxtoolkit.tasks.TPrime
            for stageName = obj.StageVal
                stage = Stage(stageName);
                obj.addStage(stage);
                probeList = obj.parseProbeStr(obj.PipelineConfig.Data.probes);
                brainRegions = obj.PipelineConfig.Data.brainRegions;
                for i = 1:length(probeList)
                    probe = probeList{i};
                    brainRegion = brainRegions{i};
                    if stageName == "CatGT"
                        config = TaskConfig(json.CatGT);
                        task = CatGT(strcat('CatGT probe', probe), probe, i, config);
                    elseif stageName == "KiloSort"
                        config = TaskConfig(json.KiloSort);
                        task = KiloSort(strcat('KiloSort probe ', probe), probe, brainRegion, config);
                    elseif stageName == "TPrime"
                        config = TaskConfig(json.TPrime);
                        task = TPrime(strcat('TPrime probe ', probe), probe, config);
                    end
                    stage.addTask(task);
                end
            end
        end

        function execute(obj)
            % stages have to run in sequence, because of result dependency
            for curr = obj.Stages
                obj.CurrentStage = curr;
                disp(strcat("Current Stage: ", curr.Info))
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
