classdef Pipeline < matlab.mixin.Heterogeneous & handle
    %Pipeline Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        PipelineInfo
        CurrentStage
        Stages
    end
    
    methods(Sealed)
        function obj = Pipeline(pipelineInfo)
            obj.PipelineInfo = pipelineInfo;
            obj.CurrentStage = -1;
            obj.Stages = [];
        end

        function obj = addStage(obj, stage)
            obj.Stages = [obj.Stages, stage];
        end
        
        function execute(obj)
            % stages have to run in sequence, because of result dependency
            for curr = obj.Stages
                obj.CurrentStage = curr;
                disp(strcat("Current Stage: ", curr.StageInfo))
                curr.parExecute();
            end
        end
    end
end
