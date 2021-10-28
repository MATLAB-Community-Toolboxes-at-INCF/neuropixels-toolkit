classdef Pipeline < matlab.mixin.Heterogeneous & handle
    %Pipeline Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Info
        PipelineConfig
        CurrentStage
        Stages
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
