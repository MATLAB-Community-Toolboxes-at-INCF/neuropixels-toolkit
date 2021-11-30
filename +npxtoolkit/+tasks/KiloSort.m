classdef KiloSort < npxtoolkit.tasks.TaskBase
    %KiloSort Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Info
        Probe
        BrainRegion
        Configs
        Output
        L
    end
    
    methods
        function obj = KiloSort(taskInfo, probe, brainRegion, configs)
            import npxtoolkit.internal.thirdparty.logging.log4m
            obj.Info = taskInfo;
            obj.Probe = probe;
            obj.BrainRegion = brainRegion;
            if class(configs.KiloSort.noiseTemplateUseRf)=="char"
                configs.KiloSort.noiseTemplateUseRf = str2num(configs.KiloSort.noiseTemplateUseRf);
            end
            obj.Configs = configs;
            obj.L = log4m.getLogger("npx.log");
        end
        
        function execute(obj)
            obj.L.info("KiloSort.m", strcat("Running task: ", obj.Info));
            names = [fieldnames(obj.Configs.Tools); fieldnames(obj.Configs.Data); fieldnames(obj.Configs.KiloSort)];
            configs = cell2struct([struct2cell(obj.Configs.Tools); struct2cell(obj.Configs.Data); struct2cell(obj.Configs.KiloSort)], names, 1);

            prb = obj.Probe;
            brainRegion = obj.BrainRegion;

            runFolderName = strcat(configs.runName, '_g', configs.gateIdx);
            catGTResultFolderName = strcat('catgt_', runFolderName);
            probFolderName = strcat(runFolderName, '_imec', prb);
            probFolder = fullfile(configs.npxDir, runFolderName, probFolderName);
            inputDataDirectory = probFolder;
            fileName = strcat(runFolderName, '_tcat.imec', prb, '.ap.bin');
            metaName = strcat(runFolderName, '_tcat.imec', prb, '.ap.meta');

            inputMetaFullpath = fullfile(configs.npxDir, catGTResultFolderName, probFolderName, metaName);
            continuousFile = fullfile(configs.npxDir, catGTResultFolderName, probFolderName, fileName);
            outputName = strcat('imec', prb, '_ks2');
            if any(strcmp('kilosort_postprocessing', configs.modules)) || any(strcmp('noise_templates', configs. modules))
                ks_make_copy = true;
            else
                ks_make_copy = false;
            end
            kilosort_output_dir = fullfile(inputDataDirectory, outputName);
            
            ksTh = getfield(configs.ksThDict, brainRegion);
            refPerMS = getfield(configs.refPerMSDict, brainRegion);
            obj.L.debug(strcat("KiloSort.m - ", obj.Info), strcat('ksTh: ', ksTh, ' ,refPerMS: ', string(refPerMS)));

            moduleInputJson = fullfile(configs.jsonDir, strcat(runFolderName, '-input.json'));

            info = py.py_modules.caller.createInputJson(...
                pyargs(...
                    'output_file', moduleInputJson,...
                    'ecephys_directory', configs.ecephysDir,...
                    'kilosort_repository', configs.kilosortRepo,...
                    'KS2ver', configs.KSver,...
                    'npy_matlab_repository', configs.npyMatlabRepo,...
                    'catGTPath', configs.catGTPath,...
                    'tPrime_path', configs.tPrimePath,...
                    'cWaves_path', configs.cWavesPath,...
                    'kilosort_output_tmp', configs.kilosortOutputTmp,...
                    'npx_directory', configs.npxDir,...
                    'continuous_file', continuousFile,...
                    'spikeGLX_data', configs.spikeGLXData,...
                    'input_meta_path', inputMetaFullpath,...
                    'kilosort_output_directory', configs.catGTDest,...
                    'noise_template_use_rf', configs.noiseTemplateUseRf,...
                    'catGT_run_name', configs.runName,...
                    'gate_string', configs.gateIdx,...
                    'probe_string', prb,...
                    'ks_remDup', configs.ksRemDup,...                   
                    'ks_finalSplits', configs.ksFinalSplits,...
                    'ks_labelGood', configs.ksLabelGood,...
                    'ks_saveRez', configs.ksSaveRez,...
                    'ks_copy_fproc', configs.ksCopyFporc,...
                    'ks_minfr_goodchannels', configs.ksMinfrGoodChannels,...                  
                    'ks_whiteningRadius_um', configs.ksWhiteningRadiusUm,...
                    'ks_Th', ksTh,...
                    'ks_CSBseed', configs.ksCSBseed,...
                    'ks_LTseed', configs.ksLTseed,...
                    'ks_templateRadius_um', configs.ksTemplateRadiusUm,...
                    'extracted_data_directory', configs.catGTDest,...
                    'event_ex_param_str',  configs.eventExParamStr,...
                    'c_Waves_snr_um', configs.cWavesSnrUm,...                   
                    'qm_isi_thresh', (refPerMS/1000)...
                )...
            );

            for i=1:length(configs.modules)
                moduleName = configs.modules{i};
                obj.L.info(strcat("KiloSort.m - ", obj.Info), strcat("Running module: ", moduleName));
                outputJson = fullfile(configs.jsonDir, strcat(runFolderName, '-', moduleName, '-output.json'));
                % TODO - reduce python
                params = strcat("-W ignore -m ecephys_spike_sorting.modules.", moduleName,...
                                " --input_json ", moduleInputJson,...
                                " --output_json ", outputJson);
                obj.L.info(strcat("KiloSort.m - ", obj.Info), strcat("python ", params));
                py.py_modules.caller.call_python(params);
                obj.L.info(strcat("KiloSort.m - ", obj.Info), strcat("Module: ", moduleName, "Done!"));
            end
            obj.L.info(strcat("KiloSort.m - ", obj.Info), "Done!");
        end
    end
end

