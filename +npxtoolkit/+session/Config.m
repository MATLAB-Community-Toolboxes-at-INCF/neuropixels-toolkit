classdef Config < handle
    %RunSpec Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        %User Input
        % brain region specific params
        refPerMSDict = containers.Map()
        % threshold values appropriate for KS2, KS2.5
        ksThDict = containers.Map()
        
        %External tool/module path
        ecephysDir
        KS2ver
        kilosortRepo
        npyMatlabRepo
        catGTPath
        tPrimePath
        cWavesPath
        kilosortOutputTmp
        
        %Input Data
        rootDataDir
        dataDir
        npxDir
        % Name for log file for this session run
        logName
        % run_specs
        runSpecs
        runName
        gateIdx
        triggers
        probes
        brainRegions

        %Output Destination
        % Cat GT
        catGTDest
        runCatGT
        carMode
        loccarMin
        loccarMax
        catGTCmdStr
        niPresent
        niExtractStr

        % Kilosort
        ksRemDup
        ksSaveRez
        ksCopyFporc
        ksTemplateRadiusUm
        ksWhiteningRadiusUm
        ksMinfrGoodChannels

        % C Waves
        cWavesSnrUm
        EventExParamStr
        
        % TPrime
        runTPrime
        syncPeriod
        toStreamSyncParams
        niStreamSyncParams

        % modules list
        modules
        jsonDir

    end
    
    methods
        %function obj=Config()
        %end
        
        function obj=loadFromJson(obj, json)
            disp(json);
            obj.refPerMSDict = json.refPerMSDict;
            obj.ksThDict = json.ksThDict;
            obj.ecephysDir = json.ecephysDir;

        end
    end
end

