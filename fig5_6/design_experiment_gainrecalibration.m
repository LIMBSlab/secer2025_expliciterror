function params_experiment = design_experiment_gainrecalibration(initialvisualgain, finalvisualgain)

global ratspeed_average;
global ratspeed_fluctuation_cov;

dt = 0.02;

epochpre_time = 0:dt:10;
epochpre_speed = @(t) interp1(epochpre_time, zeros(size(epochpre_time)), t);
epochpre_gain = @(t) interp1([epochpre_time(1), epochpre_time(end)], [initialvisualgain, initialvisualgain], t);
epochpre_position2lm = @(t) interp1(epochpre_time, cumsum(epochpre_speed(epochpre_time).*epochpre_speed(epochpre_time))*dt, t);

epoch0_time = 0:dt:15;
epoch0_speed = @(t) interp1(epoch0_time, zeros(size(epoch0_time)), t);
epoch0_gain = @(t) interp1([epoch0_time(1), epoch0_time(end)], [initialvisualgain, initialvisualgain], t);
epoch0_position2lm = @(t) interp1(epoch0_time, cumsum(epoch0_speed(epoch0_time).*epoch0_speed(epoch0_time))*dt, t);

if abs(ratspeed_average) > 0.01
    epoch1_time = 0:dt:200*360/ratspeed_average;
else
    epoch1_time = 0:dt:2000;
end
vprofile = movmean(1 + ratspeed_fluctuation_cov*randn(size(epoch1_time)),30, 'Endpoints',0) - 0.66;
vprofile = max(vprofile, 0);
vprofile = ratspeed_average*vprofile/mean(vprofile);
epoch1_speed = @(t) interp1(epoch1_time, vprofile, t);
epoch1_gain = @(t) interp1([epoch1_time(1), epoch1_time(end)], [initialvisualgain, initialvisualgain], t);
epoch1_position2lm = @(t) epoch0_position2lm(epoch0_time(end)) + interp1(epoch1_time, cumsum(epoch1_speed(epoch1_time).*epoch1_gain(epoch1_time))*dt, t);

if abs(ratspeed_average) > 0.01
    epoch2_time = 0:dt:20*360/ratspeed_average;
else
    epoch2_time = 0:dt:1000;
end
vprofile = movmean(1 + ratspeed_fluctuation_cov*randn(size(epoch2_time)),30, 'Endpoints',0) - 0.66;
vprofile = max(vprofile, 0);
vprofile = ratspeed_average*vprofile/mean(vprofile);
epoch2_speed = @(t) interp1(epoch2_time, vprofile, t);
epoch2_gain = @(t) interp1([epoch2_time(1), epoch2_time(end)], [initialvisualgain, finalvisualgain], t);
epoch2_position2lm = @(t) epoch1_position2lm(epoch1_time(end)) + interp1(epoch2_time, cumsum(epoch2_speed(epoch2_time).*epoch2_gain(epoch2_time))*dt, t);

if abs(ratspeed_average) > 0.01
    epoch3_time = 0:dt:160*360/ratspeed_average;
else
    epoch3_time = 0:dt:1600;
end
vprofile = movmean(1 + ratspeed_fluctuation_cov*randn(size(epoch3_time)),30, 'Endpoints',0) - 0.66;
vprofile = max(vprofile, 0);
vprofile = ratspeed_average*vprofile/mean(vprofile);
epoch3_speed = @(t) interp1(epoch3_time, vprofile, t);
epoch3_gain = @(t) interp1([epoch3_time(1), epoch3_time(end)], [finalvisualgain, finalvisualgain], t);
epoch3_position2lm = @(t) epoch2_position2lm(epoch2_time(end)) + interp1(epoch3_time, cumsum(epoch3_speed(epoch3_time).*epoch3_gain(epoch3_time))*dt, t);

if abs(ratspeed_average) > 0.01
    epoch4_time = 0:dt:20*360/ratspeed_average;
else
    epoch4_time = 0:dt:1000;
end
vprofile = movmean(0.8*ratspeed_average + 0.4*ratspeed_average*randn(size(epoch4_time)),30, 'Endpoints',vprofile(end));
epoch4_speed = @(t) interp1(epoch4_time, vprofile, t);
epoch4_gain = @(t) interp1([epoch4_time(1), epoch4_time(end)], [finalvisualgain, finalvisualgain], t);
epoch4_position2lm = @(t) epoch3_position2lm(epoch3_time(end)) + interp1(epoch4_time, cumsum(epoch4_speed(epoch4_time).*epoch4_gain(epoch4_time))*dt, t);


params_experiment.type = 'GainCalibration';
params_experiment.epochs(1).time = epochpre_time;
params_experiment.epochs(1).velocity = epochpre_speed;
params_experiment.epochs(1).lmgain = epochpre_gain;
params_experiment.epochs(1).position2lm = epochpre_position2lm;
params_experiment.epochs(1).status_landmarks = false;

params_experiment.epochs(2).time = epoch0_time;
params_experiment.epochs(2).velocity = epoch0_speed;
params_experiment.epochs(2).lmgain = epoch0_gain;
params_experiment.epochs(2).position2lm = epoch0_position2lm;
params_experiment.epochs(2).status_landmarks = true;

params_experiment.epochs(3).time = epoch1_time;
params_experiment.epochs(3).velocity = epoch1_speed;
params_experiment.epochs(3).lmgain = epoch1_gain;
params_experiment.epochs(3).position2lm = epoch1_position2lm;
params_experiment.epochs(3).status_landmarks = true;

params_experiment.epochs(4).time = epoch2_time;
params_experiment.epochs(4).velocity = epoch2_speed;
params_experiment.epochs(4).lmgain = epoch2_gain;
params_experiment.epochs(4).position2lm = epoch2_position2lm;
params_experiment.epochs(4).status_landmarks = true;

params_experiment.epochs(5).time = epoch3_time;
params_experiment.epochs(5).velocity = epoch3_speed;
params_experiment.epochs(5).lmgain = epoch3_gain;
params_experiment.epochs(5).position2lm = epoch3_position2lm;
params_experiment.epochs(5).status_landmarks = true;

params_experiment.epochs(6).time = epoch4_time;
params_experiment.epochs(6).velocity = epoch4_speed;
params_experiment.epochs(6).lmgain = epoch4_gain;
params_experiment.epochs(6).position2lm = epoch4_position2lm;
params_experiment.epochs(6).status_landmarks = false;
