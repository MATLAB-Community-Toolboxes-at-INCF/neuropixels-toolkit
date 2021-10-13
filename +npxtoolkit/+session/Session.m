classdef Session < handle
    %Session Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        sessionInfo
        pipelines
    end
    
    methods
        function obj = Session(sessionInfo)
            obj.sessionInfo = sessionInfo
            obj.pipelines = {};
        end
        
        function obj = addPipeline(obj, pipeline)
            obj.pipelines{end+1} = pipeline;
        end

        function parExecute(obj)
            % sessions can run in parallel
            for pipeline = obj.pipelines
                curr = pipeline{:};
                disp(strcat("Current Pipeline: ", curr.pipelineInfo))
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

