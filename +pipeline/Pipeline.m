classdef Pipeline < pipeline.PipelineBase
    %Pipeline Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        pipeline_input
        tasks
        pipeline_config
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
            for task_id = 1:length(obj.tasks)
                % take a task from the task list
                task = obj.tasks{task_id};
                % the first task takes input from pipeline input
                if task_id == 1
                    task.task_input = obj.pipeline_input;
                % the following tasks take input from the previous task
                else
                    last_task = obj.tasks{task_id-1};
                    task.task_input = last_task.task_result;
                end
                % execute task and save result in task.task_result
                task.execute()
                % save the last task's result as pipeline result
                if task_id == length(obj.tasks)
                    obj.pipeline_result = task.task_result;
                end
            end
        end
    end
end

