classdef KiloSort < npxtoolkit.jobs.JobBase
    %KiloSort Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        jobInfo
        input
        output
    end
    
    methods
        function obj = KiloSort(jobInfo, input)
            obj.jobInfo = jobInfo;
            obj.input = input;
        end
        
        function execute(obj)
           disp(obj.jobInfo);
        end
    end
end

