function roll_wrapped = ALS_wrap_roll(input_data, fs)

% disp('Wrapping roll around negative angles...')
% adjust data around -180deg
ind_negative = find(diff(input_data, 1) > 340);
if ~isempty(ind_negative)  % if it's not empty
    for i = 1 : numel(ind_negative)
        adjust_start = ind_negative(i) + 1;
        % find breaking point when function stops decreasing
        
        if adjust_start + fs * 60 > length(input_data)
            break_point = find(diff(input_data(adjust_start:end)) > 0, 1, 'first');
        else
            break_point = find(diff(input_data(adjust_start:adjust_start + fs * 60)) > 0, 1, 'first');
        end
        if ~isempty(break_point)  % if there is a break point
            input_data(adjust_start:adjust_start + break_point) = (...
                -(180 + 180 - ...
                input_data(adjust_start:adjust_start + break_point)));
        end
    end
end

% disp('Wrapping roll around positive angles...')
% adjust data around +180deg
ind_positive = find(diff(input_data, 1) < -340);
if ~isempty(ind_positive)  % if it's not empty
    for i = 1 : numel(ind_positive)
        adjust_start = ind_positive(i) + 1;
        % find breaking point when function stops decreasing
        if adjust_start + fs * 60 > length(input_data)
            break_point = find(diff(input_data(adjust_start:end)) > 0, 1, 'first');
        else
            break_point = find(diff(input_data(adjust_start:adjust_start + fs * 60)) > 0, 1, 'first');
        end
        if ~isempty(break_point)  % if there is a break point
            input_data(adjust_start:adjust_start + break_point) = (...
                (180 + 180 + ...
                input_data(adjust_start:adjust_start + break_point)));
        end
    end
end

roll_wrapped = input_data;