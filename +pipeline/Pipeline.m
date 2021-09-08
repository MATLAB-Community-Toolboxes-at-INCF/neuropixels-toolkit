classdef Pipeline < pipeline.PipelineBase
    %Pipeline Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        pipeline_input
        stages
        pipeline_config
        pipeline_result
    end
    
    methods
        function obj = Pipeline(pipeline_input)
            obj.pipeline_input = pipeline_input;
        end
        
        function assemble_pipeline(obj, stage_list)
            obj.stages = stage_list;
        end
        
        function execute(obj)
            prev = 0;
            obj.stages{1}.stage_input = obj.pipeline_input;
            for stage = obj.stages
                curr = stage{:};
                if prev ~= 0
                    curr.stage_input = prev.stage_result;
                end
                curr.execute();
                prev = curr;
            end
            obj.pipeline_result = prev.stage_result;
            
        end
    end
end

