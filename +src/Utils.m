classdef Utils
    %Utils Summary of this class goes here
    %   Detailed explanation goes here
    
    methods(Static)
        function config = load_json(fpath)
            fid = fopen(fpath); 
            raw = fread(fid,inf); 
            config = char(raw'); 
            fclose(fid);
            disp(config) % debug
            config = jsondecode(config);
        end
    end
end

