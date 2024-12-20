import os 
import matplotlib.pyplot as plt
import spikeinterface
import spikeinterface as si  # import core only
import spikeinterface.extractors as se
import spikeinterface.sorters as ss
import spikeinterface.comparison as sc
import spikeinterface.widgets as sw
from spikeinterface.exporters import export_to_phy
from probeinterface.plotting import plot_probe
from spikeinterface.postprocessing import compute_principal_components

# :code:extractors : file IO
# :code:preprocessing : preprocessing
# :code:sorters : Python wrappers of spike sorters
# :code:postprocessing : postprocessing
# :code:qualitymetrics : quality metrics on units found by sorter
# :code:comparison : comparison of spike sorting output
# :code:widgets : visualization

def load_mearec(local_path):
    """
    Load MEArec data, extract recording and ground truth sorting, and visualize the data.

    Parameters:
    local_path (str): Path to the MEArec file.

    Returns:
    tuple: A tuple containing the recording object, the sorting_true object, and the probe object.
    """
    # Load recording and sorting_true objects from the MEArec file
    recording, sorting_true = se.read_mearec(local_path)
    
    # High-level information
    print("Load recording to the recording object")
    print(recording)
    print("Load groundtruth to the sorting_true object")
    print(sorting_true)
    
    # Attributes for recording
    print("Access information from the recording object")
    print('Num. channels = {}'.format(len(recording.get_channel_ids())))  # Number of channels in the recording
    print('Sampling frequency = {} Hz'.format(recording.get_sampling_frequency()))  # Sampling frequency of the recording
    print('Num. segments = {}'.format(recording.get_num_segments()))  # Number of segments in the recording
    print('Num. timepoints seg0 = {}'.format(recording.get_num_frames(segment_index=0)))  # Number of timepoints in the first segment
    
    # Attributes for sorting
    print("Access information from the sorting_true object")
    num_seg = recording.get_num_segments()  # Number of segments in the recording
    unit_ids = sorting_true.get_unit_ids()  # Unit IDs in the sorting
    spike_train = sorting_true.get_unit_spike_train(unit_id=unit_ids[0])  # Spike train for the first unit
    print('Number of segments:', num_seg)
    print('Unit ids:', unit_ids)
    print('Spike train of first unit:', spike_train)
    
    # Visualization for recording and sorting
    print("Visualize raw traces for recording and raster for sorting_true")
    w_ts = sw.plot_timeseries(recording, time_range=(0, 5))  # Plot the raw traces of the recording for the first 5 seconds
    plt.savefig("figure/raw_traces.png")  # Save the raw traces plot
    w_rs = sw.plot_rasters(sorting_true, time_range=(0, 5))  # Plot the raster of the sorting for the first 5 seconds
    plt.savefig("figure/groundtruth_raster.png")  # Save the raster plot
    
    # Extract probe information from recording
    print("Access probe information from the recording")
    probe = recording.get_probe()  # Get the probe information from the recording
    print(probe)
    probegroup = recording.get_probegroup()
    print(probegroup)
    plot_probe(probe)  # Plot the layout of the probe
    plt.savefig("figure/probe_layout.png")  # Save the probe layout plot
    
    return recording, sorting_true, probe  # Return the recording, sorting_true, and probe objects


def preprocessing(recording):
    """
    Preprocess the given recording by applying a bandpass filter and common median reference.
    
    Parameters:
    recording (si.BaseRecording): The recording object to preprocess.

    Returns:
    si.BaseRecording: The preprocessed recording object.
    """
    # Apply a bandpass filter to the recording (300-6000 Hz)
    recording_f = si.preprocessing.bandpass_filter(recording, freq_min=300, freq_max=6000)
    print("Bandpass filtered recording:")
    print(recording_f)
    
    # Apply a common median reference to the filtered recording
    recording_cmr = si.preprocessing.common_reference(recording_f, reference='global', operator='median')
    print("Common median referenced recording:")
    print(recording_cmr)
    
    # Extract raw traces from the original recording for the first segment and first channel
    trace0_raw = recording.get_traces(segment_index=0)[:1000, 0]
    # Extract preprocessed traces from the CMR recording for the first segment and first channel
    trace0_cmr = recording_cmr.get_traces(segment_index=0)[:1000, 0]
    # Plot the raw and preprocessed traces
    fig = plt.figure()
    plt.plot(trace0_raw, label="raw_signal")
    plt.plot(trace0_cmr, label="preprocessed_signal")
    plt.legend()
    # Save the plot of raw and preprocessed traces
    plt.savefig("figure/preprocessing_traces.png")

    recording_preprocessed = recording_cmr
    # Save the preprocessed recording in binary format and return it
    # recording_preprocessed = recording_cmr.save(folder='./preprocessed',
    #                                             format='binary')
    print("Preprocessed recording saved:")
    print(recording_preprocessed)
    
    return recording_preprocessed


def sort_Kilosort(recording_preprocessed):
    """
    Sort the preprocessed recording using Kilosort3 and visualize the results.
    
    Parameters:
    recording_preprocessed (si.BaseRecording): The preprocessed recording object to sort.

    Returns:
    si.BaseSorting: The sorting result object from Kilosort3.
    """
    # Print available and installed sorters
    print('Available sorters:', ss.available_sorters())
    print('Installed sorters:', ss.installed_sorters())

    # Configure environment for Kilosort
    os.environ["KILOSORT3_PATH"] = '/opt/Kilosort-3.0'
    # os.environ["NPY_MATLAB_PATH"] = '/opt/npy-matlab'  # Uncomment if needed
    ss.Kilosort3Sorter.set_kilosort3_path('/opt/Kilosort-3.0')
    
    # Print default parameters for Kilosort3
    print("Default parameters for Kilosort3:")
    print(ss.get_default_params('kilosort3'))
    
    # Run Kilosort3 sorter on the preprocessed recording
    sorting_Kilosort3 = ss.run_sorter(sorter_name="kilosort3", recording=recording_preprocessed)
    print('Units found by Kilosort3:', sorting_Kilosort3.get_unit_ids())
    
    # Visualize the raster plot of the sorted units
    w_rs_ks = sw.plot_rasters(sorting_Kilosort3, time_range=(0, 5))
    
    # Save the raster plot
    plt.savefig("figure/extracted_raster.png")
    
    return sorting_Kilosort3


def extract_waveform(sorting_Kilosort3, recording_preprocessed):
    """
    Extract waveforms based on identified spikes from Kilosort3 sorting results and perform various analyses.
    
    Parameters:
    sorting_Kilosort3 (si.BaseSorting): The sorting result object from Kilosort3.

    Returns:
    si.WaveformExtractor: The waveform extractor object with extracted waveforms.
    """
    # Print a message indicating the start of waveform extraction
    print("Extract Waveform based on identified spikes")
    # Create a WaveformExtractor object for the given recording and sorting results
    we_Kilosort3 = si.WaveformExtractor.create(recording_preprocessed, sorting_Kilosort3, 'waveforms', remove_if_exists=True)
    # Set parameters for waveform extraction
    we_Kilosort3.set_params(ms_before=3., ms_after=4., max_spikes_per_unit=500)
    # Run waveform extraction with parallel processing
    we_Kilosort3.run_extract_waveforms(n_jobs=-1, chunk_size=30000)
    # Print the WaveformExtractor object
    print(we_Kilosort3)
    
    # Get the first unit ID from the sorting results
    unit_id0 = sorting_Kilosort3.unit_ids[0]
    # Define colors for plotting
    colors = ['Olive', 'Teal', 'Fuchsia']
    
    # Extract waveforms for the first unit
    waveforms = we_Kilosort3.get_waveforms(unit_id0)
    print(waveforms.shape)
    # Plot the waveforms of the first three units on channel 8
    fig, ax = plt.subplots()
    for i, unit_id in enumerate(sorting_Kilosort3.unit_ids[:3]):
        wf = we_Kilosort3.get_waveforms(unit_id)
        color = colors[i]
        ax.plot(wf[:, :, 8].T, color=color, lw=0.3)
    # Save the plot of the waveforms
    plt.savefig("figure/waveforms.png")

    # Extract waveform template for the first unit
    template = we_Kilosort3.get_template(unit_id0)
    print(template.shape)
    # Plot the template (average waveforms) of the first three units on channel 8
    fig, ax = plt.subplots()
    for i, unit_id in enumerate(sorting_Kilosort3.unit_ids[:3]):
        template = we_Kilosort3.get_template(unit_id)
        color = colors[i]
        ax.plot(template[:, 8].T, color=color, lw=3)
    # Save the plot of the waveform templates
    plt.savefig("figure/waveform_templates.png")

    # Compute principal components for the extracted waveforms
    pc = compute_principal_components(we_Kilosort3, load_if_exists=True,
                                         n_components=3, mode='by_channel_local')
    print(pc)
    # Plot the projection of the first three units on channel 8 onto the first two principal components
    fig, ax = plt.subplots()
    for i, unit_id in enumerate(sorting_Kilosort3.unit_ids[:3]):
        comp = pc.get_projections(unit_id)
        print(comp.shape)
        color = colors[i]
        ax.scatter(comp[:, 0, 8], comp[:, 1, 8], color=color)
    # Label the axes of the principal component plot
    ax.set_ylabel("PC2")
    ax.set_xlabel("PC1")
    # Save the plot of the principal component projections
    plt.savefig("figure/pc_projections.png")
    
    # Print a message indicating the start of waveform export to Phy
    print("Export Waveform to Phy")
    # Export the waveforms to Phy for visualization and further analysis
    export_to_phy(we_Kilosort3, './phy_folder_for_Kilosort3',
                  compute_pc_features=False, 
                  compute_amplitudes=True, 
                  remove_if_exists=True)

    return we_Kilosort3


def quality_metrics(we_Kilosort3):
    """
    Evaluate spike sorting based on quality metrics using the WaveformExtractor object.
    
    Parameters:
    we_Kilosort3 (si.WaveformExtractor): The waveform extractor object containing extracted waveforms.

    Returns:
    None
    """
    # Print a message indicating the start of quality metrics evaluation
    print("Evaluate spike sorting based on quality metrics")
    
    # Compute the signal-to-noise ratio (SNR) for the extracted waveforms
    snrs = si.qualitymetrics.compute_snrs(we_Kilosort3)
    # Print the computed SNRs
    print(snrs)
    
    # Compute inter-spike interval (ISI) violations for the extracted waveforms
    si_violations_ratio, isi_violations_rate, isi_violations_count = si.qualitymetrics.compute_isi_violations(
        we_Kilosort3, isi_threshold_ms=1.5)
    # Print the computed ISI violation metrics
    print(si_violations_ratio)
    print(isi_violations_rate)
    print(isi_violations_count)
    
    # Compute additional quality metrics such as SNR, ISI violations, and amplitude cutoff
    metrics = si.qualitymetrics.compute_quality_metrics(
        we_Kilosort3, metric_names=['snr', 'isi_violation', 'amplitude_cutoff'])
    # Print the computed quality metrics
    print(metrics)


def sorting_comparison(sorting_true, sorting_Kilosort3):
    """
    Compare sorted spikes against ground truth sorting and visualize the comparison results.
    
    Parameters:
    sorting_true (si.BaseSorting): The ground truth sorting object.
    sorting_Kilosort3 (si.BaseSorting): The sorting result object from Kilosort3.

    Returns:
    None
    """
    # Print a message indicating the start of sorting comparison
    print("Compare sorted spikes and groundtruth")
    # Compare the Kilosort3 sorting results to the ground truth sorting
    comp_true_Kilosort3 = sc.compare_sorter_to_ground_truth(gt_sorting=sorting_true, tested_sorting=sorting_Kilosort3)
    # Get and print the performance metrics of the comparison
    comp_true_Kilosort3.get_performance()
    
    # Plot the confusion matrix for the comparison
    w_conf = sw.plot_confusion_matrix(comp_true_Kilosort3)    
    # Save the confusion matrix plot
    plt.savefig("figure/confusion_matrix.png")
    
    # Plot the agreement matrix for the comparison
    w_agr = sw.plot_agreement_matrix(comp_true_Kilosort3)
    # Save the agreement matrix plot
    plt.savefig("figure/agreement_matrix.png")



if __name__ == "__main__":

    # 1. Preparation
    print("\n\n 1. Preparation")
    local_path = './dataset/mearec/mearec_test_10s.h5'
    if not os.path.isfile(local_path):
        print("The testing dataset is not avaliable at local_path {local_path}, triggering dataset_downloading")
        local_path = si.download_dataset(remote_path='mearec/mearec_test_10s.h5')
    output_dir = './figure'
    if not os.path.exists(output_dir):
        os.makedirs(output_dir)    

    # 2. Loading the data and probe information
    print("\n\n 2. Loading the data and probe information \n")
    recording, sorting_true, probe = load_mearec(local_path)

    # 3. Signal Conditioning
    print("\n\n 3. Signal Conditioning \n")
    recording_preprocessed = preprocessing(recording)
    
    # 4. Data Packaging for Automated Spike Sorting
    print("\n\n 4. Data Packaging for Automated Spike Sorting \n")
    
    # 5. Automatic Spike Sorting
    print("\n\n 5. Automatic Spike Sorting \n")
    sorting_Kilosort3 = sort_Kilosort(recording_preprocessed)
    
    # 6. Postprocessing of Spike Sorted Data 
    print("\n\n 6. Postprocessing of Spike Sorted Data \n")
    we_Kilosort3 = extract_waveform(sorting_Kilosort3, recording_preprocessed)
    
    # 7. Time Alignment to Auxiliary Data Stream 
    print("\n\n 7. Time Alignment to Auxiliary Data Stream \n")
    
    # 8. Quality Assessment 
    print("\n\n 8. Quality Assessment \n")
    quality_metrics(we_Kilosort3)
    sorting_comparison(sorting_true, sorting_Kilosort3)