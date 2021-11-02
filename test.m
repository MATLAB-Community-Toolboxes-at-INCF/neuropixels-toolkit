import npxtoolkit.session.Session
import npxtoolkit.pipeline.Pipeline
import npxtoolkit.config.Config
import npxtoolkit.config.PipelineConfig

import npxtoolkit.internal.thirdparty.logging.log4m
%% main logger
% if exist("npx.log", "file")==2
%     delete("npx.log");
% end
logger = log4m.getLogger("npx.log");
logger.clearLog();
logger.setLogLevel(logger.DEBUG);

%% Future ENV Var 
logger.info("test.m", "Setting up Python environment...");

PYENV_PATH = '/home/ubuntu/anaconda3/envs/spike_sorting/bin/python';
% load python modules
pe = pyenv();
if pe.Status == "NotLoaded"
    pyenv('Version', PYENV_PATH);
end
caller = py.importlib.import_module('py_modules.caller');
py.importlib.reload(caller);

logger.info("test.m", "Done with setting up Python environment!");


%% Processing Session
% define session
logger.info("test.m", "Creating a session...");
session = Session('Session Info', logger);
% init session by pipelines, stages and jobs


%% ===========================================
%% Configuration
logger.info("test.m", "Parsing config file for pipeline...");
json = Config.parseJson("configs/test_config.json");

%% Auto-assembled pipeline
logger.info("test.m", "Auto-assembling a pipeline based on the config file...");
pipelineConfig = PipelineConfig(json.pipeline);
pipeline = Pipeline('Pipeline0 Info', pipelineConfig, logger);
pipeline.autoAssemble(json);

logger.info("test.m", "Adding the pipeline to session...");
session.addPipeline(pipeline);
logger.info("test.m", "Executing session...");
session.parExecute();
logger.info("test.m", "Session execution done!");


% %% ===========================================
% %% Manually-assembled pipeline
% logger.info("test.m", "Manually assemble a pipeline...");
% import npxtoolkit.stage.Stage
% import npxtoolkit.config.TaskConfig
% import npxtoolkit.tasks.CatGT
% import npxtoolkit.tasks.KiloSort
% import npxtoolkit.tasks.TPrime

% %% Configuration
% logger.info("test.m", "Parsing config file for pipeline...");
% json = Config.parseJson("configs/test_config.json");

% %% Pipeline 1
% logger.info("test.m", "Set PipelineConfig...");
% pipelineConfig1 = PipelineConfig(json.pipeline);
% pipeline1 = Pipeline('Pipeline0 Info', pipelineConfig1);

% % CatGT stage
% logger.info("test.m", "Creating CatGT stage...");
% stageCatgt = Stage('CatGT');
% % append stage to pipeline first, in order to pass Pipeline/CommonConfig to tasks
% pipeline1.addStage(stageCatgt);
% logger.info("test.m", "CatGT stage was added!");
% % CatGT task 1
% logger.info("test.m", "Creating CatGT task config...");
% configCatgt1 = TaskConfig(json.CatGT);
% logger.info("test.m", "Creating CatGT task...");
% taskCatgt1 = CatGT('CatGT probe 0', '0', 1, configCatgt1);
% stageCatgt.addTask(taskCatgt1);
% logger.info("test.m", "CatGT task was added!");

% % KiloSort stage
% logger.info("test.m", "Creating KiloSort stage...");
% stageKilo = Stage('KiloSort');
% pipeline1.addStage(stageKilo);
% logger.info("test.m", "KiloSort stage was added!");
% % KiloSort task 1
% logger.info("test.m", "Creating KiloSort task config...");
% configKilo1 = TaskConfig(json.KiloSort);
% logger.info("test.m", "Creating KiloSort task...");
% taskKilo1 = KiloSort('KiloSort probe 0', '0', 'cortex', configKilo1);
% stageKilo.addTask(taskKilo1);
% logger.info("test.m", "KiloSort task was added!");

% % TPrime stage
% logger.info("test.m", "Creating TPrime stage...");
% stageTPrime = Stage('TPrime');
% pipeline1.addStage(stageTPrime);
% logger.info("test.m", "TPrime stage was added!");
% % TPrime task 1
% logger.info("test.m", "Creating TPrime task config...");
% configTPrime1 = TaskConfig(json.TPrime);
% logger.info("test.m", "Creating TPrime task...");
% taskTPrime1 = TPrime('TPrime probe 0', '0', configTPrime1);
% stageTPrime.addTask(taskTPrime1);
% logger.info("test.m", "TPrime task was added!");

% % append pipeline to session
% logger.info("test.m", "Adding the pipeline to session...");
% session.addPipeline(pipeline1);
% %% Execution
% logger.info("test.m", "Executing session...");
% session.parExecute();
% logger.info("test.m", "Session execution done!");


% %% ===========================================
% %% Single task excution(test/special usecase)
% %% Configuration
% logger.info("test.m", "Parsing config file for pipeline...");
% json = Config.parseJson("configs/test_config.json");

% pipelineConfig = PipelineConfig(json.pipeline);
% % config = TaskConfig(json.CatGT);
% % task = CatGT('CatGT probe 0', '0', 1, config);
% % config = TaskConfig(json.KiloSort);
% % task = KiloSort('KiloSort probe 0', '0', 'cortex', config);
% % config = TaskConfig(json.TPrime);
% % task = TPrime('TPrime probe 0', '0', config);

% task.CommonConfig = pipelineConfig;
% task.execute();