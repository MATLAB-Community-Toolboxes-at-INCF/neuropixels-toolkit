import npxtoolkit.session.Session
import npxtoolkit.pipeline.Pipeline
import npxtoolkit.stage.Stage
import npxtoolkit.config.Config
import npxtoolkit.config.PipelineConfig
import npxtoolkit.config.TaskConfig
import npxtoolkit.tasks.CatGT
import npxtoolkit.tasks.KiloSort
import npxtoolkit.tasks.TPrime

%% Future ENV Var 
PYENV_PATH = '/home/ubuntu/anaconda3/envs/spike_sorting/bin/python';
% load python modules
pe = pyenv();
if pe.Status == "NotLoaded"
    pyenv('Version', PYENV_PATH);
end
caller = py.importlib.import_module('py_modules.caller');
py.importlib.reload(caller);


%% Processing Session
% define session
session = Session('Session Info');
% init session by pipelines, stages and jobs


%% Configuration
% json = Pipeline.loadJson("configs/test_config.json");
% config = Config();
% config.loadFromJson(json);
json = Config.parseJson("configs/test_config.json");


% % TODO - pipeline can be auto-assembled from pipeline config
% % The idea is to replace the following Stage/Task creation with pipeline0.assebleFromConfig();
% % Then directly session.addPipeline(pipeline0); session.parExecute();
% %% Manually assemble pipeline
% %% Pipeline 1
% pipelineConfig1 = PipelineConfig(json.pipeline);
% pipeline1 = Pipeline('Pipeline0 Info', pipelineConfig1);

% % CatGT stage
% stageCatgt = Stage('CatGT');
% % append stage to pipeline, in order to pass Pipeline/CommonConfig to tasks
% pipeline1.addStage(stageCatgt);
% % CatGT task 1
% configCatgt1 = TaskConfig(json.CatGT);
% taskCatgt1 = CatGT('CatGT probe 0', configCatgt1);
% stageCatgt.addTask(taskCatgt1);
% % CatGT task 2
% configCatgt2 = TaskConfig(json.CatGT);
% taskCatgt2 = CatGT('CatGT probe 1', configCatgt2);
% stageCatgt.addTask(taskCatgt2);

% % KiloSort stage
% stageKilo = Stage('KiloSort');
% pipeline1.addStage(stageKilo);
% % KiloSort task 1
% configKilo1 = TaskConfig(json.KiloSort);
% taskKilo1 = KiloSort('KiloSort probe 0', configKilo1);
% stageKilo.addTask(taskKilo1);
% % KiloSort task 2
% configKilo2 = TaskConfig(json.KiloSort);
% taskKilo2 = KiloSort('KiloSort probe 1', configKilo2);
% stageKilo.addTask(taskKilo2);

% % TPrime stage
% stageTPrime = Stage('TPrime');
% pipeline1.addStage(stageTPrime);
% % TPrime task 1
% configTPrime1 = TaskConfig(json.TPrime);
% taskTPrime1 = TPrime('TPrime probe 0', configTPrime1);
% stageTPrime.addTask(taskTPrime1);
% % TPrime task 2
% configTPrime2 = TaskConfig(json.TPrime);
% taskTPrime2 = TPrime('TPrime probe 1', configTPrime2);
% stageTPrime.addTask(taskTPrime2);

% % append pipeline to session
% session.addPipeline(pipeline1);

% %% Pipeline 2 - There can be multiple pipelines in the same session
% % Pipeline configs can be different, but here just using the same config
% pipelineConfig1 = PipelineConfig(json.pipeline);
% pipeline2 = Pipeline('Pipeline2 Info', pipelineConfig1);
% session.addPipeline(pipeline2);

% %% Execution
% disp(session.Pipelines(1).Stages(3).Info);
% disp(session.Pipelines(1).Stages(3).TaskQueue(2).Info);
% disp(session.Pipelines(1).Stages(3).TaskQueue(2).CommonConfig);
% disp(session.Pipelines(1).Stages(3).TaskQueue(2).CustomConfig);
% % session.parExecute();


%% Auto-assemble
% probeList = Pipeline.parseProbeStr(config.Probes);


%% ===========================================
%% Manually assemble pipeline
%% Pipeline 1
pipelineConfig1 = PipelineConfig(json.pipeline);
pipeline1 = Pipeline('Pipeline0 Info', pipelineConfig1);

% CatGT stage
stageCatgt = Stage('CatGT');
% append stage to pipeline, in order to pass Pipeline/CommonConfig to tasks
pipeline1.addStage(stageCatgt);
% CatGT task 1
configCatgt1 = TaskConfig(json.CatGT);
taskCatgt1 = CatGT('CatGT probe 0', configCatgt1);
stageCatgt.addTask(taskCatgt1);

% KiloSort stage
stageKilo = Stage('KiloSort');
pipeline1.addStage(stageKilo);
% KiloSort task 1
configKilo1 = TaskConfig(json.KiloSort);
taskKilo1 = KiloSort('KiloSort probe 0', configKilo1);
stageKilo.addTask(taskKilo1);

% TPrime stage
stageTPrime = Stage('TPrime');
pipeline1.addStage(stageTPrime);
% TPrime task 1
configTPrime1 = TaskConfig(json.TPrime);
taskTPrime1 = TPrime('TPrime probe 0', configTPrime1);
stageTPrime.addTask(taskTPrime1);

% append pipeline to session
session.addPipeline(pipeline1);

%% Execution
session.Pipelines(1).Stages(1).TaskQueue(1).execute();
% session.parExecute();
