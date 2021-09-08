import pipeline.Pipeline
import pipeline.modules.CatGT
import pipeline.modules.KiloSort
pipeline = Pipeline(123);

cat_gt = CatGT('123');
kilo_sort = KiloSort('123');

pipeline.assemble_pipeline([cat_gt, kilo_sort])
pipeline.run();
disp(pipeline);
disp(pipeline.pipeline_result);