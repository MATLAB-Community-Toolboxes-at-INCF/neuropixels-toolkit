classdef (Abstract) TaskBase < matlab.mixin.Heterogeneous & handle
    %JOBBASE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Abstract)
        Info
        Configs
        Output
        L
    end
    
    methods (Abstract)
        execute(obj)
    end

    methods (Static)
        function trailRange = getTrailRange(prb, gate, prbFolder)
            tFiles = dir(fullfile(prbFolder,'*.bin'));
            minIndex =  intmax;
            maxIndex = 0;
            searchStr = "_g" + gate+ "_t";
            % for tName in tFiles:
            %     if (fnmatch.fnmatch(tName,'*.bin')):
            %         gPos = tName.find(searchStr)
            %         tStart = gPos + len(searchStr)
            %         tEnd = tName.find('.', tStart)
                    
            %         if gPos > 0 and tEnd > 0:
            %             try:
            %                 tInd = int(tName[tStart:tEnd])                    
            %             except ValueError:
            %                 print(tName[tStart:tEnd])
            %                 print('Error parsing trials for probe folder: ' + prb_folder + '\n')
            %                 return -1, -1
            %         else:
            %             print('Error parsing trials for probe folder: ' + prb_folder + '\n')
            %             return -1, -1
                    
            %         if tInd > maxIndex:
            %             maxIndex = tInd
            %         if tInd < minIndex:
            %             minIndex = tInd
                        
            % return minIndex, maxIndex
            trailRange = [0,0];
        end

        function triggerList = parseTriggerStr(triggerStr, prb, gate, prbFolder)
            strList = split(triggerStr, ',');
            firstTrigStr = strList{1};
            lastTrigStr = strList{2};
            
            if contains(lastTrigStr, 'end') || contains(firstTrigStr, 'start')
                % TODO - npxtoolkit.tasks.CatGT.getTrailRange()
                minInd = 0;
                maxInd = 0;
            end

            if contains(firstTrigStr, 'start')
                firstTrig = minInd;
            else
                firstTrig = str2num(firstTrigStr);
            end
            
            if contains(lastTrigStr, 'end')
                lastTrig = maxInd;
            else
                lastTrig = str2num(lastTrigStr);
            end

            triggerList = {firstTrig, lastTrig};
        end
    end
end

