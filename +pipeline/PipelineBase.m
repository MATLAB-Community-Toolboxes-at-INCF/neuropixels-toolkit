classdef (Abstract) PipelineBase < handle
    %PipelineBase is an abstract class for a pipeline
    %   Detailed explanation goes here
    
    properties(Abstract)
        pipeline_input
        stages
        pipeline_config
        pipeline_result
    end
    
    methods(Abstract)
        stages = assemble_pipeline(obj, stage_list)
        pipeline_result = execute(obj)
    end
end

