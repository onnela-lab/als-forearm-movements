function count = ALS_calculate_roll_metric(data, option, min_angle)
% data ~ angle (roll)
% option = 1 - supinantion only
% option = 2 - pronation only
% option = 3 - supination and pronation

data_diff = diff(data);
data_diff(data_diff < 0.5 & data_diff > -0.5 | abs(data_diff) > 90) = 0;
data_sign = sign(data_diff);

count = 0;
if option == 1 % supination only
    % supination
    [running_length, move_duration, starting_index] = RunLength(data_sign);

    move_duration(running_length<1)=[];
    starting_index(running_length<1)=[];
    running_length(running_length<1)=[];
    MinMax = nan(numel(running_length),4);
    for i = 1:numel(running_length)
        MinMax(i,:) = [data(starting_index(i)), data(starting_index(i)+move_duration(i)), starting_index(i), move_duration(i)];
    end
    
    % clear too small angles
    MinMax(abs(MinMax(:, 2) - MinMax(:, 1)) < min_angle, :) = [];
    
    count = count + size(MinMax,1); % add instances
elseif option == 2 % extension only
    % Pronation
    [running_length, move_duration, starting_index] = RunLength(data_sign);
    
    move_duration(running_length>-1)=[];
    starting_index(running_length>-1)=[];
    running_length(running_length>-1)=[];
    MinMax = nan(numel(running_length),4);
    for j = 1:numel(running_length)
        MinMax(j,:) = [data(starting_index(j)), data(starting_index(j)+move_duration(j)), starting_index(j), move_duration(j)];
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
    MinMax = nan(numel(running_length),4);
    for i = 1:numel(running_length)
        MinMax(i,:) = [data(starting_index(i)), data(starting_index(i)+move_duration(i)), starting_index(i), move_duration(i)];
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
    
    % clear too small angles
    MinMax(abs(MinMax(:, 2) - MinMax(:, 1)) < min_angle, :) = [];
    
    count = count + size(MinMax,1);  % add instances
end