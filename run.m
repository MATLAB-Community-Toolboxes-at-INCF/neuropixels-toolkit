import pipeline.Pipeline
import pipeline.Task
pipeline = Pipeline(123);
task = Task('123');
task.execute();
disp(task);
disp(task.task_result);
pipeline.assemble_pipeline([task, task, task])
pipeline.run();
disp(pipeline);
disp(pipeline.pipeline_result);