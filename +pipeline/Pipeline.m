classdef Pipeline < pipeline.PipelineBase
    %Pipeline Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        pipeline_input
        tasks
        pipeline_result
    end
    
    methods
        function obj = Pipeline(pipeline_input)
            obj.pipeline_input = pipeline_input;
        end
        
        function assemble_pipeline(obj, task_list)
            obj.tasks = task_list;
        end
        
        function run(obj)
            obj.pipeline_result = 'pipeline result';
        end
    end
end

