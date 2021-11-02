classdef Session < handle
    %Session Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Info
        Pipelines
        L
    end
    
    methods
        function obj = Session(sessionInfo, logger)
            obj.Info = sessionInfo;
            obj.Pipelines = [];
            obj.L = logger;
        end
        
        function obj = addPipeline(obj, pipeline)
            obj.Pipelines = [obj.Pipelines, pipeline];
        end

        function parExecute(obj)
            % sessions can run in parallel
            for curr = obj.Pipelines
                obj.L.info("Session.m", strcat("Excuting Pipeline: ", curr.Info, "..."));
                curr.execute();
            end
        end
    end
end

