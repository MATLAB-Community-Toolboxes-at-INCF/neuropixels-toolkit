classdef Stage < matlab.mixin.Heterogeneous & handle
    %Stage Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Info
        CurrentTask
        TaskQueue
        L
    end
    
    methods
        function obj = Stage(stageInfo, logger)
            obj.Info = stageInfo;
            obj.TaskQueue = [];
            obj.L = logger;
        end

        function obj = addTask(obj, task)
            obj.TaskQueue = [obj.TaskQueue, task];
        end

        function parExecute(obj)
            % TODO - tasks can run in parallel
            for curr = obj.TaskQueue
                obj.L.info(strcat("Stage.m - ", obj.Info), strcat("Excuting Task: ", curr.Info));
                try
                    curr.execute();
                catch ME
                    obj.L.error("Error - Stage.m curr.execute", strcat(curr.Info, " Execution"));
                    rethrow(ME);
                end
            end
        end
    end
end

