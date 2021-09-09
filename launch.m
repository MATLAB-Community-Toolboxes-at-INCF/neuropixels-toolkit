import pipeline.Pipeline
import pipeline.Utils
import pipeline.stages.CatGT
import pipeline.stages.KiloSort

% load config file
config = Utils.load_json('config.json');

% set pipeline input
pipeline = Pipeline('123', config);

% assemble pipeline by modules
cat_gt = CatGT;
kilo_sort = KiloSort;
pipeline.assemble_pipeline({cat_gt, kilo_sort});

% run pipeline
pipeline.execute();
disp(pipeline.pipeline_result);