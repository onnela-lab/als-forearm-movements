function result = forearm_movements(data, fs)
% Identify forearm movements and their features from a raw accelerometry signal
% collected using wearable devices placed on the wrist.
%
% Inputs:
% data ~    tridimensional raw sub-second level accelerometer data collected
%           with ActiGraph Insight Watch
% fs ~      sampling frequency of data
% 

% define digital low-pass filter
df = designfilt('lowpassfir', 'FilterOrder', 8, 'CutoffFrequency', 0.1, ...
    'SampleRate', fs);

% calculate pitch and roll
[pitch, roll] = ALS_get_pitch_roll(data, df);

% wrap around roll
roll_wrapped = ALS_wrap_roll(roll, fs);

% Remove unstable roll
roll_wrapped(pitch < -85) = NaN;
roll_wrapped(pitch > 85) = NaN;

% Flexion
flexion_45 = ALS_calculate_pitch_metric(pitch, 1, 45);

% Extension
extension_45 = ALS_calculate_pitch_metric(pitch, 2, 45);

% Flexion and extension
flex_ext_45 = ALS_calculate_pitch_metric(pitch, 3, 45);

% Supination
supination_45 = ALS_calculate_roll_metric(roll_wrapped, 1, 45);

% Pronation
pronation_45 = ALS_calculate_roll_metric(roll_wrapped, 2, 45);

% Supination and pronation
sup_pro_45 = ALS_calculate_roll_metric(roll_wrapped, 3, 45);

% GET DURATION OF TOP 10 MOVES BY A GIVEN ANGLE
% Flexion
dur_flexion_45_10 = ALS_calculate_pitch_metric_duration(pitch, 1, 45, 10);

% Extension
dur_extension_45_10 = ALS_calculate_pitch_metric_duration(pitch, 2, 45, 10);

% Flexion and extension
dur_flex_ext_45_10 = ALS_calculate_pitch_metric_duration(pitch, 3, 45, 10);

% GET DURATION OF TOP 10 MOVES BY A GIVEN ANGLE
% Supination
dur_supination_45_10 = ALS_calculate_roll_metric_duration(roll_wrapped, 1, 45, 10);

% Pronation
dur_pronation_45_10 = ALS_calculate_roll_metric_duration(roll_wrapped, 2, 45, 10);

% Supination and pronation
dur_sup_pro_45_10 = ALS_calculate_roll_metric_duration(roll_wrapped, 3, 45, 10);

result = [flexion_45, extension_45, flex_ext_45, ...
    supination_45, pronation_45, sup_pro_45, ...
    dur_flexion_45_10, dur_extension_45_10, dur_flex_ext_45_10, 
    dur_supination_45_10, dur_pronation_45_10, dur_sup_pro_45_10];
