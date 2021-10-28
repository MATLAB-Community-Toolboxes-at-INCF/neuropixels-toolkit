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
        KSver
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

        % Data source
        SpikeGLXData
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
        NoiseTemplateUseRf
        KsRemDup
        KsFinalSplits
        KsLabelGood
        KsSaveRez
        KsCopyFporc
        KsCSBseed
        KsLTseed
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
            obj.KSver = json.KSver;
            obj.KilosortRepo = strcat(json.kilosortRepo, obj.KSver);
            obj.NpyMatlabRepo = json.npyMatlabRepo;
            obj.CatGTPath = json.catGTPath;
            obj.TPrimePath = json.tPrimePath;
            obj.CWavesPath = json.cWavesPath;
            obj.KilosortOutputTmp = json.kilosortOutputTmp;
            obj.RootDataDir = json.rootDataDir;
            obj.DataDir = json.dataDir;
            obj.NpxDir = fullfile(obj.RootDataDir, obj.DataDir);
            obj.LogName = json.logName;
            obj.RunSpecs = json.runSpecs;
            obj.RunName = json.runName;
            obj.GateIdx = json.gateIdx;
            obj.Triggers = json.triggers;
            obj.Probes = json.probes;
            obj.BrainRegions = json.brainRegions;
            obj.SpikeGLXData = str2num(json.spikeGLXData);
            obj.CatGTDest = obj.NpxDir;
            obj.RunCatGT = str2num(json.runCatGT);
            obj.CarMode = json.carMode;
            obj.LoccarMin = json.loccarMin;
            obj.LoccarMax = json.loccarMax;
            obj.CatGTCmdStr = json.catGTCmdStr;
            obj.NiPresent = str2num(json.niPresent);
            obj.NiExtractStr = json.niExtractStr;
            obj.NoiseTemplateUseRf = str2num(json.noiseTemplateUseRf);
            obj.KsRemDup = json.ksRemDup;
            obj.KsFinalSplits = json.ksFinalSplits;
            obj.KsLabelGood = json.ksLabelGood;
            obj.KsSaveRez = json.ksSaveRez;
            obj.KsCopyFporc = json.ksCopyFporc;
            obj.KsCSBseed = json.ksCSBseed;
            obj.KsLTseed = json.ksLTseed;
            obj.KsTemplateRadiusUm = json.ksTemplateRadiusUm; 
            obj.KsWhiteningRadiusUm = json.ksWhiteningRadiusUm;
            obj.KsMinfrGoodChannels = json.ksMinfrGoodChannels;
            obj.CWavesSnrUm = json.cWavesSnrUm;
            obj.EventExParamStr = json.EventExParamStr;
            obj.RunTPrime = str2num(json.runTPrime);
            obj.SyncPeriod = json.syncPeriod;
            obj.ToStreamSyncParams = json.toStreamSyncParams;
            obj.NiStreamSyncParams = json.niStreamSyncParams;
            obj.Modules = json.modules;
            obj.JsonDir = json.jsonDir;
        end
    end
end

