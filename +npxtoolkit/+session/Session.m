classdef Session < handle
    %Session Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        sessionInfo
        currentStage
        stages
    end
    
    methods
        function obj = Session(sessionInfo)
            obj.sessionInfo = sessionInfo;
            obj.currentStage = -1;
            obj.stages = {};
        end

        function obj = add_stage(stage)
            obj.stages{end+1} = stage;
        end
        
        function execute(obj)
            % stages have to run in sequence, because of result dependency
            for stage = obj.stages
                curr = stage{:};
                obj.currentStage = curr;
                disp(obj.currentStage.stageInfo);
                curr.execute();
            end
        end
    end
end
