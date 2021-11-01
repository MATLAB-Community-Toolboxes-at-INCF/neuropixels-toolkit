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
json = Config.parseJson("configs/test_config.json");


%% Auto-assemble
% probeList = Pipeline.parseProbeStr(config.Probes);


% %% ===========================================
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

% % KiloSort stage
% stageKilo = Stage('KiloSort');
% pipeline1.addStage(stageKilo);
% % KiloSort task 1
% configKilo1 = TaskConfig(json.KiloSort);
% taskKilo1 = KiloSort('KiloSort probe 0', configKilo1);
% stageKilo.addTask(taskKilo1);

% % TPrime stage
% stageTPrime = Stage('TPrime');
% pipeline1.addStage(stageTPrime);
% % TPrime task 1
% configTPrime1 = TaskConfig(json.TPrime);
% taskTPrime1 = TPrime('TPrime probe 0', configTPrime1);
% stageTPrime.addTask(taskTPrime1);

% % append pipeline to session
% session.addPipeline(pipeline1);

% %% Execution
% session.Pipelines(1).Stages(1).TaskQueue(1).execute();
% % session.parExecute();


%% ===========================================
%% Single task test
pipelineConfig = PipelineConfig(json.pipeline);


% config = TaskConfig(json.CatGT);
% task = CatGT('CatGT probe 0', config);
% config = TaskConfig(json.KiloSort);
% task = KiloSort('KiloSort probe 0', config);
config = TaskConfig(json.TPrime);
task = TPrime('TPrime probe 0', config);


task.CommonConfig = pipelineConfig;
task.execute();