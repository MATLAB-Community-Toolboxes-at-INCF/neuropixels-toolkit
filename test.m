import npxtoolkit.session.Config
import npxtoolkit.session.Session
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

%% Processing Session Configuration
json = Session.loadJson("configs/test_config.json");
config = Config();
config.loadFromJson(json);

%% Processing Session
% define session
session = Session('Session Info');
% init session by pipelines, stages and jobs
% TODO - session can be auto-assembled by RunSpec

% Pipeline
pipeline0 = Pipeline('Pipeline Info');

% CatGT stage
stageCatgt = Stage('CatGT');
% task 0
taskCatgt0 = CatGT('CatGT probe 0', 'input probe 0');
stageCatgt.addTask(taskCatgt0);
% task 1
taskCatgt1 = CatGT('CatGT probe 1', 'input probe 1');
stageCatgt.addTask(taskCatgt1);
% append stage to pipeline
pipeline0.addStage(stageCatgt);

% KiloSort stage
stageKilo = Stage('KiloSort');
% task 0
taskKilo0 = KiloSort('KiloSort probe 0', 'input probe 0');
stageKilo.addTask(taskKilo0);
% task 1
taskKilo1 = KiloSort('KiloSort probe 1', 'input probe 1');
stageKilo.addTask(taskKilo1);
% append stage to pipeline
pipeline0.addStage(stageKilo);

session.addPipeline(pipeline0);
%% Execution
session.parExecute();
