function params_experiment = design_experiment_cuerotation(anglm_bias_arr)
dt = 0.02;

T_epoch0 = 25;
T_epochexps = 15;

epoch0_time = 0:dt:T_epoch0;
epoch0_speed = @(t) interp1(epoch0_time, zeros(size(epoch0_time)), t);
epoch0_gain = @(t) interp1([epoch0_time(1), epoch0_time(end)], [1, 1], t);
epoch0_bias = @(t) interp1([epoch0_time(1), epoch0_time(end)], [0, 0], t);
epoch0_position2lm = @(t) interp1(epoch0_time, cumsum(epoch0_speed(epoch0_time).*epoch0_speed(epoch0_time))*dt, t);
epoch0_statuslm = true;

epoch_time = 0:dt:T_epochexps;
epoch_speed = @(t) interp1(epoch_time, zeros(size(epoch_time)), t);
epoch_gain = @(t) interp1([epoch_time(1), epoch_time(end)], [1, 1], t);
epoch_position2lm = @(t) interp1(epoch_time, cumsum(epoch_speed(epoch_time).*epoch_speed(epoch_time))*dt, t);
epoch_statuslm = true;

params_experiment.type = 'CueRotation';
params_experiment.epochs(1).time = epoch0_time;
params_experiment.epochs(1).velocity = epoch0_speed;
params_experiment.epochs(1).lmgain = epoch0_gain;
params_experiment.epochs(1).lmbias = epoch0_bias;
params_experiment.epochs(1).position2lm = epoch0_position2lm;
params_experiment.epochs(1).status_landmarks = epoch0_statuslm;

for idxbias = 1:length(anglm_bias_arr)
    anglm_bias = anglm_bias_arr(idxbias);

    epoch_bias = @(t) interp1([epoch_time(1), epoch_time(end)], [anglm_bias, anglm_bias], t);
    
    params_experiment.epochs(idxbias+1).time = epoch_time;
    params_experiment.epochs(idxbias+1).velocity = epoch_speed;
    params_experiment.epochs(idxbias+1).lmgain = epoch_gain;
    params_experiment.epochs(idxbias+1).lmbias = epoch_bias;
    params_experiment.epochs(idxbias+1).position2lm = epoch_position2lm;
    params_experiment.epochs(idxbias+1).status_landmarks = epoch_statuslm;
end

params_experiment.duration = T_epoch0 + T_epochexps*(length(params_experiment.epochs)-1);
