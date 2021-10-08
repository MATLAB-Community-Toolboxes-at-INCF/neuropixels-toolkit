classdef Stage < handle
    %Stage Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        stageInfo
        currentTask
        taskQueue
    end
    
    methods
        function obj = Stage(stageInfo)
            obj.stageInfo = stageInfo;
            obj.taskQueue = {};
        end

        function obj = addTask(task)
            obj.taskQueue{end+1} = task;
        end

        function parExecute(obj)
            % TODO - tasks can run in parallel
            for task = obj.taskQueue
                curr = task{:};
                curr.execute();
            end
        end
    end
end

