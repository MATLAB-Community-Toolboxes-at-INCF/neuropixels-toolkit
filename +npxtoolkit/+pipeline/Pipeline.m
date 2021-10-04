classdef Pipeline < handle
    %Pipeline Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        pipeline_info
        sessions
    end
    
    methods
        function obj = Pipeline(pipeline_info)
            obj.pipeline_info = pipeline_info
            obj.sessions = {};
        end
        
        function obj = add_session(session)

        end

        function par_execute(obj)
            % sessions can run in parallel
            for session = obj.sessions
                curr = session{:};
                curr.execute();
            end
        end
    end
end

