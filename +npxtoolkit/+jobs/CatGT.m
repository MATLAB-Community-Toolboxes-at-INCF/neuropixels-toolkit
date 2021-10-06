classdef CatGT < npxtoolkit.jobs.JobBase
    %CatGT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        job_info
        input
        output
    end
    
    methods
        function obj = CatGT(job_info, input)
            obj.job_info = job_info;
            obj.input = input;
        end
        
        function execute(obj)
            disp(obj.job_info);
        end
    end
end

