classdef Stage < matlab.mixin.Heterogeneous & handle
    %Stage Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Info
        CommonConfigForTask
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
            task.CommonConfig = obj.CommonConfigForTask;
            obj.TaskQueue = [obj.TaskQueue, task];
        end

        function parExecute(obj)
            % TODO - tasks can run in parallel
            for curr = obj.TaskQueue
                obj.L.info(strcat("Stage.m - ", obj.Info), strcat("Excuting Task: ", curr.Info));
                curr.execute();
            end
        end
    end
end

