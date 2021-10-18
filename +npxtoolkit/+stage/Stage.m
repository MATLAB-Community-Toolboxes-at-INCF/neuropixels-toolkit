classdef Stage < matlab.mixin.Heterogeneous & handle
    %Stage Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        StageInfo
        CurrentTask
        TaskQueue
    end
    
    methods
        function obj = Stage(stageInfo)
            obj.StageInfo = stageInfo;
            obj.TaskQueue = [];
        end

        function obj = addTask(obj, task)
            obj.TaskQueue = [obj.TaskQueue, task];
        end

        function parExecute(obj)
            % TODO - tasks can run in parallel
            for curr = obj.TaskQueue
                disp(strcat("Current Task: ", curr.TaskInfo))
                curr.execute();
            end
        end
    end
end

