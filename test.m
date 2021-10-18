import npxtoolkit.session.Session
import npxtoolkit.pipeline.Config
import npxtoolkit.pipeline.Pipeline
import npxtoolkit.stage.Stage
import npxtoolkit.tasks.CatGT
import npxtoolkit.tasks.KiloSort

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

%% Processing Pipeline Configuration
json = Pipeline.loadJson("configs/test_config.json");
config = Config();
config.loadFromJson(json);

%% Pipeline
pipeline0 = Pipeline('Pipeline0 Info', config);
% TODO - pipeline can be auto-assembled by pipeline config

% CatGT stage
stageCatgt = Stage('CatGT');
% task 0
taskCatgt0 = CatGT('CatGT probe 0', config);
stageCatgt.addTask(taskCatgt0);
% task 1
taskCatgt1 = CatGT('CatGT probe 1', config);
stageCatgt.addTask(taskCatgt1);
% append stage to pipeline
pipeline0.addStage(stageCatgt);

% KiloSort stage
stageKilo = Stage('KiloSort');
% task 0
taskKilo0 = KiloSort('KiloSort probe 0', config);
stageKilo.addTask(taskKilo0);
% task 1
taskKilo1 = KiloSort('KiloSort probe 1', config);
stageKilo.addTask(taskKilo1);
% append stage to pipeline
pipeline0.addStage(stageKilo);

session.addPipeline(pipeline0);

% There can be multiple pipelines in the same session
pipeline1 = Pipeline('Pipeline1 Info', config);
session.addPipeline(pipeline1);
%% Execution
session.parExecute();
