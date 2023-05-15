function [pitch,roll] = ALS_get_pitch_roll(data_trimmed, df)
% note negative sign in "roll formula"
formula valid for Actigraph Watch Link

data_trimmed = data_trimmed(:, 1:3);

data_filtered = filtfilt(df, data_trimmed);

data_filtered(data_filtered >  1) = 1;
data_filtered(data_filtered < -1) = -1;

pitch = atan2d(data_filtered(:, 2), sqrt(data_filtered(:, 1).^2 + data_filtered(:, 3).^2));
roll = atan2d(data_filtered(:, 1), data_filtered(:, 3));