classdef (Abstract) PipelineBase < handle
    %PipelineBase is an abstract class for a pipeline
    %   Detailed explanation goes here
    
    properties(Abstract)
        pipeline_input
        tasks
        pipeline_result
    end
    
    methods(Abstract)
        tasks = assemble_pipeline(obj, task_list)
        pipeline_result = run(obj)
    end
end

