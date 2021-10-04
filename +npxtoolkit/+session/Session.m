classdef Session < handle
    %Session Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        session_info
        current_stage
        stages
    end
    
    methods
        function obj = Session(session_info)
            obj.session_info = session_info;
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
