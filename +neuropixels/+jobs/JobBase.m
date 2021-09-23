classdef (Abstract) JobBase < handle
    %JOBBASE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Abstract)
        job_info
        input
        output
    end
    
    methods (Abstract)
        execute(obj)
    end
end

