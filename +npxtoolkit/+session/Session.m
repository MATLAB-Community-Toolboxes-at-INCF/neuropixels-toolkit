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
            import npxtoolkit.internal.thirdparty.logging.log4m
            obj.Info = sessionInfo;
            obj.Pipelines = [];
            obj.L = log4m.getLogger("npx.log");
            obj.L.info("Session.m", "Creating a session...");
        end
        
        function obj = addPipeline(obj, pipeline)
            obj.L.info("Session.m", "Adding the pipeline to session...");
            obj.Pipelines = [obj.Pipelines, pipeline];
        end

        function parExecute(obj)
            % sessions can run in parallel
            obj.L.info("Session.m", "Executing session...");
            for curr = obj.Pipelines
                obj.L.info("Session.m", "Excuting Pipeline: " + curr.Info + "...");
                curr.execute();
            end
            obj.L.info("Session.m", "Session execution done!");
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

