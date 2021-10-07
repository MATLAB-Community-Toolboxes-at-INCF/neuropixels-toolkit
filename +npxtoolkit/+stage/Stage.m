classdef Stage < handle
    %Stage Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        stageInfo
        currentJob
        jobQueue
    end
    
    methods
        function obj = Stage(stageInfo)
            obj.stageInfo = stageInfo;
            obj.jobQueue = {};
        end

        function obj = add_job(job)
            obj.jobQueue{end+1} = job;
        end

        function par_execute(obj)
            % TODO - jobs can run in parallel
            for job = obj.jobQueue
                curr = job{:};
                curr.execute();
            end
        end
    end
end

