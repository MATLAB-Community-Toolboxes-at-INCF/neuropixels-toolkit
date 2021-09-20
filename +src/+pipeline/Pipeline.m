classdef Pipeline < handle
    %Pipeline Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        current_stage
        stages
    end
    
    methods
        function obj = Pipeline()
            obj.current_stage = -1;
            obj.stages = {};
        end
        
        function execute(obj)
            % stages have to run in sequence, because of result dependency
            for stage = obj.stages
                curr = stage{:};
                obj.current_stage = curr;
                disp(obj.current_stage.stage_info);
                curr.execute();
            end
        end
    end
end

