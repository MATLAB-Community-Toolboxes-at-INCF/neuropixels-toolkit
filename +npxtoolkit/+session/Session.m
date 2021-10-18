classdef Session < handle
    %Session Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        SessionInfo
        Pipelines
    end
    
    methods
        function obj = Session(sessionInfo)
            obj.SessionInfo = sessionInfo
            obj.Pipelines = [];
        end
        
        function obj = addPipeline(obj, pipeline)
            obj.Pipelines = [obj.Pipelines, pipeline];
        end

        function parExecute(obj)
            % sessions can run in parallel
            for curr = obj.Pipelines
                disp(strcat("Current Pipeline: ", curr.PipelineInfo))
                curr.execute();
            end
        end
    end

    methods(Static)
        function config = loadJson(fpath)
            fid = fopen(fpath); 
            raw = fread(fid,inf); 
            config = char(raw'); 
            fclose(fid);
            config = jsondecode(config);
        end
    end
end

