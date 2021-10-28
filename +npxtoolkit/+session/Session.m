classdef Session < handle
    %Session Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Info
        Pipelines
    end
    
    methods
        function obj = Session(sessionInfo)
            obj.Info = sessionInfo;
            obj.Pipelines = [];
        end
        
        function obj = addPipeline(obj, pipeline)
            obj.Pipelines = [obj.Pipelines, pipeline];
        end

        function parExecute(obj)
            % sessions can run in parallel
            for curr = obj.Pipelines
                disp(strcat("Current Pipeline: ", curr.Info));
                curr.execute();
            end
        end
    end
end

