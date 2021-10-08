classdef Pipeline < handle
    %Pipeline Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        pipelineInfo
        currentStage
        stages
    end
    
    methods
        function obj = Pipeline(pipelineInfo)
            obj.pipelineInfo = pipelineInfo;
            obj.currentStage = -1;
            obj.stages = {};
        end

        function obj = addStage(obj, stage)
            obj.stages{end+1} = stage;
        end
        
        function execute(obj)
            % stages have to run in sequence, because of result dependency
            for stage = obj.stages
                curr = stage{:};
                obj.currentStage = curr;
                disp(strcat("Current Stage: ", curr.stageInfo))
                curr.parExecute();
            end
        end
    end
end
