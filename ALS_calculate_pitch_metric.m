function count = ALS_calculate_pitch_metric(data, option, min_angle)
% data ~ angle (pitch or roll)
% option = 1 - flexion only
% option = 2 - extension only
% option = 3 - flexion and extension

data_diff = diff(data);
data_diff(data_diff < 0.5 & data_diff > -0.5) = 0;
data_sign = sign(data_diff);

count = 0;
if option == 1 % flexion only
    % Flexion & supination
    [running_length, move_duration, starting_index] = RunLength(data_sign);

    move_duration(running_length<1)=[];
    starting_index(running_length<1)=[];
    running_length(running_length<1)=[];
    MinMax = nan(numel(running_length),4);
    for i = 1:numel(running_length)
        MinMax(i,:) = [data(starting_index(i)), data(starting_index(i)+move_duration(i)), starting_index(i), move_duration(i)];
    end
    
    % wrap around
    for j = 1:size(MinMax,1)
        if MinMax(j,2)<MinMax(j,1) % this is wrong!
            MinMax(j,2) = 180 + (180 + MinMax(j,2));
        end
    end
    
    % clear too small angles
    MinMax(abs(MinMax(:, 2) - MinMax(:, 1)) < min_angle, :) = [];
    
    count = count + size(MinMax,1); % add instances
elseif option == 2 % extension only
    % Extension & pronation
    [running_length, move_duration, starting_index] = RunLength(data_sign);
    
    move_duration(running_length>-1)=[];
    starting_index(running_length>-1)=[];
    running_length(running_length>-1)=[];
    MinMax = nan(numel(running_length),4);
    for j = 1:numel(running_length)
        MinMax(j,:) = [data(starting_index(j)), data(starting_index(j)+move_duration(j)), starting_index(j), move_duration(j)];
    end
    
    % wrap around
    for j = 1:size(MinMax,1)
        if MinMax(j,2)>MinMax(j,1)
            MinMax(j,2) = -180 - (180 - MinMax(j,2));
        end
    end
    % clear too small angles
    MinMax(abs(MinMax(:, 2) - MinMax(:, 1)) < min_angle, :) = [];
    
    count = count + size(MinMax,1);  % add instances
elseif option == 3 % flexion and extension / supination and pronation
    % Flexion / supination
    [running_length, move_duration, starting_index] = RunLength(data_sign);

    move_duration(running_length<1)=[];
    starting_index(running_length<1)=[];
    running_length(running_length<1)=[];
    MinMax = nan(numel(running_length), 4);
    for i = 1:numel(running_length)
        MinMax(i,:) = [data(starting_index(i)), data(starting_index(i)+move_duration(i)), starting_index(i), move_duration(i)];
    end
    
    % wrap around
    for j = 1:size(MinMax,1)
        if MinMax(j,2)<MinMax(j,1)
            MinMax(j,2) = 180 + (180 + MinMax(j,2));
        end
    end
    
    % clear too small angles
    MinMax(abs(MinMax(:, 2) - MinMax(:, 1)) < min_angle, :) = [];
    count = count + size(MinMax,1); % add instances
    
    % Extension / pronation
    [running_length, move_duration, starting_index] = RunLength(data_sign);
    
    move_duration(running_length>-1)=[];
    starting_index(running_length>-1)=[];
    running_length(running_length>-1)=[];
    MinMax = nan(numel(running_length),4);
    for j = 1:numel(running_length)
        MinMax(j,:) = [data(starting_index(j)), data(starting_index(j)+move_duration(j)), starting_index(j), move_duration(j)];
    end
    
    % wrap around
    for j = 1:size(MinMax,1)
        if MinMax(j, 2)>MinMax(j, 1)
            MinMax(j, 2) = -180 - (180 - MinMax(j, 2));
        end
    end
    % clear too small angles
    MinMax(abs(MinMax(:, 2) - MinMax(:, 1)) < min_angle, :) = [];
    
    count = count + size(MinMax, 1);  % add instances
end