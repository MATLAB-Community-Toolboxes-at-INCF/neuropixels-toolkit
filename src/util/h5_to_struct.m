function dataStruct = h5_to_struct(h5file)
    % Open the HDF5 file and get its info
    info = h5info(h5file); 
    
    % Initialize the struct to hold data
    dataStruct = struct(); 
    
    % Recursively process the HDF5 content
    dataStruct = recursively_load_datasets(h5file, info, dataStruct, '/');
end

% Helper function to recursively load datasets and groups from the HDF5 file
function currentStruct = recursively_load_datasets(h5file, h5infoObj, currentStruct, currentPath)
    % Loop through each group in the current HDF5 object
    for i = 1:length(h5infoObj.Groups)
        group_name = h5infoObj.Groups(i).Name;
        group_name = matlab.lang.makeValidName(strrep(group_name, currentPath, '')); % Remove the current path
        
        % Create a struct for the group
        currentStruct.(group_name) = struct(); 
        
        % Recursively process subgroups
        currentStruct.(group_name) = recursively_load_datasets(h5file, h5infoObj.Groups(i), currentStruct.(group_name), h5infoObj.Groups(i).Name);
    end
    
    % Loop through each dataset in the current HDF5 object
    for j = 1:length(h5infoObj.Datasets)
        dataset_name = h5infoObj.Datasets(j).Name;
        dataset_name = matlab.lang.makeValidName(strrep(dataset_name, currentPath, '')); % Remove the current path
        
        % Construct the full path for the dataset
        dataset_path = fullfile(currentPath, dataset_name);
        
        % Read the dataset and add it to the current struct
        dataset_data = h5read(h5file, dataset_path);
        currentStruct.(dataset_name) = dataset_data;
    end
end
