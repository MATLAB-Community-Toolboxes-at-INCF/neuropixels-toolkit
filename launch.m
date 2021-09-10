import src.Utils
import src.pipeline.Pipeline
import src.stages.CatGT
import src.stages.KiloSort

%% Static Variables
PYENV_PATH = 'C:\ProgramData\Anaconda3\envs\spike_sorting\python.exe';

CONFIG_FROM_JSON_PATH = 'configs\config.json';
% CONFIG_FROM_JSON_PATH = ''; % will generate json by input variables

%% Input Variables


%% Pipeline Configuration
% load python modules
pe = pyenv();
if pe.Status == "NotLoaded"
    pyenv('Version', PYENV_PATH);
end
caller = py.importlib.import_module('py_modules.caller');
py.importlib.reload(caller);

% load config file
if ~strcmp(CONFIG_FROM_JSON_PATH, '')
    config = Utils.load_json(CONFIG_FROM_JSON_PATH);
else
    py.help('py_modules.caller.createInputJson');
    py.py_modules.caller.createInputJson();
end

%% Pipeline Definition/Execution
% set pipeline input
pipeline = Pipeline('123', config);

% assemble pipeline by stages
cat_gt = CatGT;
kilo_sort = KiloSort;
pipeline.assemble_pipeline({cat_gt, kilo_sort});

% run pipeline
pipeline.execute();
disp(pipeline.pipeline_result);

