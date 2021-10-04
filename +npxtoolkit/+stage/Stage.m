classdef Stage < handle
    %Stage Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        stage_info
        current_job
        job_queue
    end
    
    methods
        function obj = Stage(stage_info)
            obj.stage_info = stage_info;
            obj.job_queue = {};
        end

        function obj = add_job(job)
            obj.job_queue{end+1} = job;
        end

        function par_execute(obj)
            % TODO - jobs can run in parallel
            for job = obj.job_queue
                curr = job{:};
                curr.execute();
            end
        end
    end
end

