classdef (Abstract) TaskBase < handle
    %JOBBASE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Abstract)
        taskInfo
        input
        output
    end
    
    methods (Abstract)
        execute(obj)
    end
end

