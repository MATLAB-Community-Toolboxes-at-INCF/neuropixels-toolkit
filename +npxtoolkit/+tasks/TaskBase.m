classdef (Abstract) TaskBase < matlab.mixin.Heterogeneous & handle
    %JOBBASE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Abstract)
        TaskInfo
        Input
        Output
    end
    
    methods (Abstract)
        execute(obj)
    end
end

