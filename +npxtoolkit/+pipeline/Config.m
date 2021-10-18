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
            obj.KS2ver = json.KS2ver;
            obj.KilosortRepo = json.kilosortRepo;
            obj.NpyMatlabRepo = json.npyMatlabRepo;
            obj.CatGTPath = json.catGTPath;
            obj.TPrimePath = json.tPrimePath;
            obj.CWavesPath = json.cWavesPath;
            obj.KilosortOutputTmp = json.kilosortOutputTmp;
            obj.RootDataDir = json.rootDataDir;
            obj.NpxDir = json.npxDir;
            obj.LogName = json.logName;
            obj.RunSpecs = json.runSpecs;
            obj.RunName = json.runName;
            obj.GateIdx = json.gateIdx;
            obj.Triggers = json.triggers;
            obj.Probes = json.probes;
            obj.BrainRegions = json.brainRegions;
            obj.CatGTDest = json.catGTDest;
            obj.RunCatGT = json.runCatGT;
            obj.CarMode = json.carMode;
            obj.LoccarMin = json.loccarMin;
            obj.LoccarMax = json.loccarMax;
            obj.CatGTCmdStr = json.catGTCmdStr;
            obj.NiPresent = json.niPresent;
            obj.NiExtractStr = json.niExtractStr;
            obj.KsRemDup = json.ksRemDup;
            obj.KsSaveRez = json.ksSaveRez;
            obj.KsCopyFporc = json.ksCopyFporc;
            obj.KsTemplateRadiusUm = json.ksTemplateRadiusUm; 
            obj.KsWhiteningRadiusUm = json.ksWhiteningRadiusUm;
            obj.KsMinfrGoodChannels = json.ksMinfrGoodChannels;
            obj.CWavesSnrUm = json.cWavesSnrUm;
            obj.EventExParamStr = json.EventExParamStr;
            obj.RunTPrime = json.runTPrime;
            obj.SyncPeriod = json.syncPeriod;
            obj.ToStreamSyncParams = json.toStreamSyncParams;
            obj.NiStreamSyncParams = json.niStreamSyncParams;
            obj.Modules = json.modules;
            obj.JsonDir = json.jsonDir;
        end
    end
end

