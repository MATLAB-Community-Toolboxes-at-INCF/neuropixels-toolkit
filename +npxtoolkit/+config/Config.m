classdef (Abstract) Config < handle
    %Config Summary of this class goes here
    %   Detailed explanation goes here

    methods (Static)
        function config = parseJson(fpath)
            fid = fopen(fpath); 
            raw = fread(fid,inf); 
            config = char(raw'); 
            fclose(fid);
            config = jsondecode(config);
        end
    end
end