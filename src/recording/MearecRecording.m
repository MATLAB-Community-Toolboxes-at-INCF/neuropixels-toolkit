classdef MearecRecording
    % A class to handle MEArec recordings, providing functionality to read, 
    % parse, and retrieve attributes and data from a MEArec HDF5 file.

    properties
        recording           % The raw recording data as a matrix (int16)
        nchan               % The number of recording channels
        sampling_frequency  % The sampling frequency of the recording (Hz)
        channel_positions   % The spatial positions of the recording channels
    end

    methods
        function obj = MearecRecording()
            % Constructor to initialize the properties
            obj.recording = [];
            obj.nchan = [];
            obj.sampling_frequency = [];
            obj.channel_positions = [];
        end

        function obj = read_recording(obj, file_path)
            % Reads a MEArec HDF5 file and initializes the class properties.
            %
            % Parameters:
            % ----------
            % file_path : string
            %     Path to the MEArec HDF5 file.

            data = h5_to_struct(file_path);

            % Extract and set properties
            obj.recording = int16(data.recordings);                          % Raw data
            obj.nchan = length(data.channel_positions);                     % Number of channels
            obj.sampling_frequency = data.info.x_recordings.fs;               % Sampling frequency
            obj.channel_positions = data.channel_positions;                 % Channel positions
        end

        function traces = get_traces(obj)
            % Returns the raw recording data.
            %
            % Returns:
            % -------
            % traces : matrix
            %     The raw recording data as a matrix.
            traces = obj.recording;
        end

        function fs = get_signal_sampling_rate(obj)
            % Returns the sampling frequency of the recording.
            %
            % Returns:
            % -------
            % fs : double
            %     The sampling frequency in Hz.
            fs = obj.sampling_frequency;
        end

        function [xcoords, ycoords, kcoords] = get_channel_locations(obj)
            % Returns the spatial positions of the recording channels.
            %
            % Returns:
            % -------
            % xcoords : array
            %     X-coordinates of the channels.
            % ycoords : array
            %     Y-coordinates of the channels.
            % kcoords : array
            %     Group indices (default is 1 for all channels).
            
            positions = obj.channel_positions;
            xcoords = positions(2,:);
            ycoords = positions(3,:);
            kcoords = ones(size(positions, 2), 1); % Default group index as 1
        end
    end
end
