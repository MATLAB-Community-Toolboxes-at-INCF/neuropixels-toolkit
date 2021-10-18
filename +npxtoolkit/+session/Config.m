classdef Config < handle
    %RunSpec Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        %User Input
        % brain region specific params
        RefPerMSDict = containers.Map()
        % threshold values appropriate for KS2, KS2.5
        KsThDict = containers.Map()
        
        %External tool/module path
        EcephysDir
        KS2ver
        KilosortRepo
        NpyMatlabRepo
        CatGTPath
        TPrimePath
        CWavesPath
        KilosortOutputTmp
        
        %Input Data
        RootDataDir
        DataDir
        NpxDir
        % Name for log file for this session run
        LogName
        % run_specs
        RunSpecs
        RunName
        GateIdx
        Triggers
        Probes
        BrainRegions

        %Output Destination
        % Cat GT
        CatGTDest
        RunCatGT
        CarMode
        LoccarMin
        LoccarMax
        CatGTCmdStr
        NiPresent
        NiExtractStr

        % Kilosort
        KsRemDup
        KsSaveRez
        KsCopyFporc
        KsTemplateRadiusUm
        KsWhiteningRadiusUm
        KsMinfrGoodChannels

        % C Waves
        CWavesSnrUm
        EventExParamStr
        
        % TPrime
        RunTPrime
        SyncPeriod
        ToStreamSyncParams
        NiStreamSyncParams

        % modules list
        Modules
        JsonDir

    end
    
    methods
        %function obj=Config()
        %end
        
        function obj=loadFromJson(obj, json)
            % disp(json);
            obj.RefPerMSDict = json.refPerMSDict;
            obj.KsThDict = json.ksThDict;
            obj.EcephysDir = json.ecephysDir;

        end
    end
end

