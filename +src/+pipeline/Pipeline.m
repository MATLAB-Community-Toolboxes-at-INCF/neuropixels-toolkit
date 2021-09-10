classdef Pipeline < handle
    %Pipeline Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        pipeline_input
        stages
        pipeline_config
        pipeline_result
    end
    
    methods
        function obj = Pipeline(pipeline_input, pipeline_config)
            obj.pipeline_input = pipeline_input;
            obj.pipeline_config = pipeline_config;
        end
        
        function assemble_pipeline(obj, stage_list)
            obj.stages = stage_list;
        end
        
        function execute(obj)
            % empty pointer to save prev stage
            prev = -1;
            % set first stage input
            obj.stages{1}.stage_input = obj.pipeline_input;
            % loop through each stage
            for stage = obj.stages
                % get curr stage
                curr = stage{:};
                % get curr stage config by it's class name
                raw_class_name = split(class(curr), '.');
                curr.stage_config = obj.pipeline_config.(raw_class_name{end});
                % set curr stage input using prev stage result
                if prev ~= -1
                    curr.stage_input = prev.stage_result;
                end
                % execute curr stage 
                curr.execute();
                disp(curr); % debug
                disp(curr.stage_config); % debug
                % set prev stage pointer to curr stage
                prev = curr;
            end
            obj.pipeline_result = prev.stage_result;
        end
    end
end

