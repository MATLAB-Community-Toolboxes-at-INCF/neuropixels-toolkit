classdef Session < handle
    %Session Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Info
        Pipelines
        L
    end
    
    methods
        function obj = Session(sessionInfo, logger)
            obj.Info = sessionInfo;
            obj.Pipelines = [];
            obj.L = logger;
        end
        
        function obj = addPipeline(obj, pipeline)
            obj.Pipelines = [obj.Pipelines, pipeline];
        end

        function parExecute(obj)
            % sessions can run in parallel
            for curr = obj.Pipelines
                obj.L.info("Session.m", strcat("Excuting Pipeline: ", curr.Info, "..."));
                curr.execute();
            end
        end
    end

    methods (Static)
        function setPyEnv(PYENV_PATH)
            % load python modules
            pe = pyenv();
            if pe.Status == "NotLoaded"
                pyenv('Version', PYENV_PATH);
            end
            caller = py.importlib.import_module('py_modules.caller');
            py.importlib.reload(caller);
        end
    end
end

