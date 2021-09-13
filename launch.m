import src.Utils
import src.pipeline.RunSpec
import src.pipeline.Pipeline
import src.stage.Stage
import src.jobs.CatGT
import src.jobs.KiloSort

%% Static Variables
PYENV_PATH = 'C:\ProgramData\Anaconda3\envs\spike_sorting\python.exe';


%% Pipeline ENV Configuration
% load python modules
pe = pyenv();
if pe.Status == "NotLoaded"
    pyenv('Version', PYENV_PATH);
end
caller = py.importlib.import_module('py_modules.caller');
py.importlib.reload(caller);


%% Pipeline Input Configuration
% Input Variables
% TODO - Set input params

% Manifest/Information object used to assemble a pipeline
run_spec = RunSpec();

% generate json config file for each job
% py.help('py_modules.caller.createInputJson');
% py.py_modules.caller.createInputJson();


%% Pipeline Assemble
% define pipeline
pipeline = Pipeline();
% assemble pipeline by stages and jobs
% TODO - pipeline can be auto-assembled by RunSpec
% CatGT stage
stage_catgt = Stage('CatGT');
% job 0
job_catgt_0 = CatGT('CatGT probe 0', 'input probe 0');
stage_catgt.job_queue{end+1} = job_catgt_0;
% job 1
job_catgt_1 = CatGT('CatGT probe 1', 'input probe 1');
stage_catgt.job_queue{end+1} = job_catgt_1;
% append stage to pipeline
pipeline.stages{end+1} = stage_catgt;

% KiloSort stage
stage_kilo = Stage('KiloSort');
% job 0
job_kilo_0 = KiloSort('KiloSort probe 0', 'input probe 0');
stage_kilo.job_queue{end+1} = job_kilo_0;
% job 1
job_kilo_1 = KiloSort('KiloSort probe 1', 'input probe 1');
stage_kilo.job_queue{end+1} = job_kilo_1;
% append stage to pipeline
pipeline.stages{end+1} = stage_kilo;


%% Pipeline Execution
pipeline.execute();

