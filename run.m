import pipeline.Pipeline
import pipeline.modules.CatGT
import pipeline.modules.KiloSort
% set pipeline input
pipeline = Pipeline('123');

% assemble pipeline by modules
cat_gt = CatGT;
kilo_sort = KiloSort;
pipeline.assemble_pipeline({cat_gt, kilo_sort});

% run pipeline
pipeline.run();
disp(pipeline.pipeline_result);