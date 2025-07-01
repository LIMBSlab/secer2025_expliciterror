global weightvisual_centralring;
global weightvisual_rotring shiftvisual_rotring;
global tonicdrive_visual_rotring;
global bumpwidth_visualring;
global ratspeed_average;
global ratspeed_fluctuation_cov;

weightvisual_centralring = -0.3;
weightvisual_rotring = -0.6;
shiftvisual_rotring = 40;
tonicdrive_visual_rotring = 0.02;


ratspeed_average = 20;
ratspeed_fluctuation_cov = 0;% careful with this parameter. anything more than 0.25 induce a lot of chattering into velocity profile.

recreateParams = true;
Nneurons = 180;

bumpwidth_visualring = 3;

%% Should there be a change to global parameters or network parameters defined in setparams_ functions, run this section
if recreateParams
    [params, x0] = create_simparams_errortheorypaper(Nneurons, 'RecreateParams', true, 'StatusPlasticity', true, 'StatusVisualInputs', true, 'AdaptiveSearchForPlasticityThresholds', true);
else
    if isfile('simparams_lmon.mat')
        load('simparams_lmon.mat');
    else
        [params, x0] = create_simparams_errortheorypaper(Nneurons, 'RecreateParams', true, 'StatusPlasticity', true, 'StatusVisualInputs', true, 'AdaptiveSearchForPlasticityThresholds', true);
    end
end

%% Error code
params.network.leftring.speedplasticity = 0*0.001;
params.network.rightring.speedplasticity = 0*0.001;


ang_lmbias_arr = -30:5:30;
bumpmean_leftring_arr = [];
bumpmean_rightring_arr = [];

params.experiment = design_experiment_errorcode(ang_lmbias_arr);    

tfinal = sum(arrayfun(@(x) x.time(end), params.experiment.epochs));
[tvec, xmat] = simulate(x0, params, tfinal, 'Solver', 1);

[tsamples, bumpheight_centralring, bumpheight_leftring, bumpheight_rightring, ...
    bumpwidth_centralring, bumpwidth_leftring, bumpwidth_rightring, ...
    bumpmean_centralring, bumpmean_leftring, bumpmean_rightring, ...
    angwrapped_centralring, angwrapped_leftring, angwrapped_rightring, angwrapped_labframe, angwrapped_lmframe, ...
    pos_centralring, pos_leftring, pos_rightring, pos_labframe, pos_lmframe, ...
    vel_centralring, vel_leftring, vel_rightring, vel_labframe, vel_lmframe, ...
    pigain_leftring, pigain_rightring, hippgain_centralring, hippgain_leftring, hippgain_rightring, expgain, ...
    uthreshmat_leftring, uthreshmat_rightring] = process_ode45results(tvec, xmat, params, 'Resample', 0.02);

errorsamples = lookup_lmbias(tsamples, params.experiment.epochs);


t_steadystate_begin = params.experiment.epochs(1).time(end) + (params.experiment.epochs(2).time(end) - params.experiment.epochs(2).time(1))/2;

for iepoch = 2:length(params.experiment.epochs)
    t_steadystate_arr(iepoch-1) = sum(arrayfun(@(x) x.time(end), params.experiment.epochs(1:iepoch-1))) + (params.experiment.epochs(iepoch).time(end) - params.experiment.epochs(iepoch).time(1))/2;
end

error_arr = interp1(tsamples, errorsamples, t_steadystate_arr);
bumpmean_leftring_arr = interp1(tsamples, bumpmean_leftring, t_steadystate_arr);
bumpmean_rightring_arr = interp1(tsamples, bumpmean_rightring, t_steadystate_arr);

bumpmean_leftring_arr_intercept = interp1(error_arr, bumpmean_leftring_arr, 0);
bumpmean_rightring_arr_intercept = interp1(error_arr, bumpmean_rightring_arr, 0);

error_fine_arr = -180:1:180;
bumpmeannormal_leftring_finearr = movmean(interp1(error_arr, bumpmean_leftring_arr./bumpmean_leftring_arr_intercept, error_fine_arr),3);
bumpmeannormal_rightring_finearr = movmean(interp1(error_arr, bumpmean_rightring_arr./bumpmean_rightring_arr_intercept, error_fine_arr),3);

bumpmean_leftring_arr_finearr = movmean(interp1(error_arr, bumpmean_leftring_arr, error_fine_arr),3);
bumpmean_rightring_arr_finearr = movmean(interp1(error_arr, bumpmean_rightring_arr, error_fine_arr),3);

close all;

figure;
plot(error_fine_arr(abs(error_fine_arr) < 50), bumpmeannormal_leftring_finearr(abs(error_fine_arr) < 50), 'LineWidth', 2);
hold on;
plot(error_fine_arr(abs(error_fine_arr) < 50), bumpmeannormal_rightring_finearr(abs(error_fine_arr) < 50), 'LineWidth', 2);
ylim([0.7, 1.3]);

figure;
plot(error_fine_arr, bumpmeannormal_leftring_finearr, 'LineWidth', 2);
hold on;
plot(error_fine_arr, bumpmeannormal_rightring_finearr, 'LineWidth', 2);

figure;
plot(error_fine_arr, bumpmean_leftring_arr_finearr, 'LineWidth', 2);
hold on;
plot(error_fine_arr, bumpmean_rightring_arr_finearr, 'LineWidth', 2);
%% Landmark correction
params.network.leftring.speedplasticity = 0*0.001;
params.network.rightring.speedplasticity = 0*0.001;


ang_lmbias_arr = 40;

params.experiment = design_experiment_cuerotation(ang_lmbias_arr);    

tfinal = sum(arrayfun(@(x) x.time(end), params.experiment.epochs));
[tvec, xmat] = simulate(x0, params, tfinal, 'Solver', 1);

[tsamples, bumpheight_centralring, bumpheight_leftring, bumpheight_rightring, ...
    bumpwidth_centralring, bumpwidth_leftring, bumpwidth_rightring, ...
    bumpmean_centralring, bumpmean_leftring, bumpmean_rightring, ...
    angwrapped_centralring, angwrapped_leftring, angwrapped_rightring, angwrapped_labframe, angwrapped_lmframe, ...
    pos_centralring, pos_leftring, pos_rightring, pos_labframe, pos_lmframe, ...
    vel_centralring, vel_leftring, vel_rightring, vel_labframe, vel_lmframe, ...
    pigain_leftring, pigain_rightring, hippgain_centralring, hippgain_leftring, hippgain_rightring, expgain, ...
    uthreshmat_leftring, uthreshmat_rightring] = process_ode45results(tvec, xmat, params, 'Resample', 0.02);

errorsamples = lookup_lmbias(tsamples, params.experiment.epochs);

t_steadystate_begin = params.experiment.epochs(1).time(end) - 2.5;

tplot = tsamples(tsamples > t_steadystate_begin & tsamples < tsamples(end)-1);
xring = angwrapped_centralring(tsamples > t_steadystate_begin & tsamples < tsamples(end)-1);
xlm = angwrapped_labframe(tsamples > t_steadystate_begin & tsamples < tsamples(end)-1) + errorsamples(tsamples > t_steadystate_begin & tsamples < tsamples(end)-1);

frleft = bumpmean_leftring(tsamples > t_steadystate_begin & tsamples < tsamples(end)-1);
frright = bumpmean_rightring(tsamples > t_steadystate_begin & tsamples < tsamples(end)-1);

close all;

figure;
plot(tplot - tplot(1), xring - xring(1), 'Linewidth', 2);
hold on;
plot(tplot - tplot(1), xlm - xlm(1), 'Linewidth', 2);

figure;
plot(tplot - tplot(1), frleft/frleft(1), 'Linewidth', 2);
hold on;
plot(tplot - tplot(1), frright/frright(1), 'Linewidth', 2);

debug;

%% Landmark correction fail
params.network.leftring.speedplasticity = 0*0.001;
params.network.rightring.speedplasticity = 0*0.001;


ang_lmbias_arr = 150;

params.experiment = design_experiment_cuerotation(ang_lmbias_arr);    

tfinal = sum(arrayfun(@(x) x.time(end), params.experiment.epochs));
[tvec, xmat] = simulate(x0, params, tfinal, 'Solver', 1);

[tsamples, bumpheight_centralring, bumpheight_leftring, bumpheight_rightring, ...
    bumpwidth_centralring, bumpwidth_leftring, bumpwidth_rightring, ...
    bumpmean_centralring, bumpmean_leftring, bumpmean_rightring, ...
    angwrapped_centralring, angwrapped_leftring, angwrapped_rightring, angwrapped_labframe, angwrapped_lmframe, ...
    pos_centralring, pos_leftring, pos_rightring, pos_labframe, pos_lmframe, ...
    vel_centralring, vel_leftring, vel_rightring, vel_labframe, vel_lmframe, ...
    pigain_leftring, pigain_rightring, hippgain_centralring, hippgain_leftring, hippgain_rightring, expgain, ...
    uthreshmat_leftring, uthreshmat_rightring] = process_ode45results(tvec, xmat, params, 'Resample', 0.02);

errorsamples = lookup_lmbias(tsamples, params.experiment.epochs);

t_steadystate_begin = params.experiment.epochs(1).time(end) - 2.5;

tplot = tsamples(tsamples > t_steadystate_begin & tsamples < tsamples(end)-1);
xring = angwrapped_centralring(tsamples > t_steadystate_begin & tsamples < tsamples(end)-1);
xlm = angwrapped_labframe(tsamples > t_steadystate_begin & tsamples < tsamples(end)-1) + errorsamples(tsamples > t_steadystate_begin & tsamples < tsamples(end)-1);

frleft = bumpmean_leftring(tsamples > t_steadystate_begin & tsamples < tsamples(end)-1);
frright = bumpmean_rightring(tsamples > t_steadystate_begin & tsamples < tsamples(end)-1);


close all;

figure;
plot(tplot - tplot(1), xring - xring(1), 'Linewidth', 2);
hold on;
plot(tplot - tplot(1), xlm - xlm(1), 'Linewidth', 2);
ylim([-10, 180]);
xlim([0, 14]);

figure;
plot(tplot - tplot(1), frleft/frleft(1), 'Linewidth', 2);
hold on;
plot(tplot - tplot(1), frright/frright(1), 'Linewidth', 2);
ylim([0.77, 1.28]);
xlim([0, 14]);

debug;

%%
finalvisualgain_arr = 0.5:0.2:1.5;
% finalvisualgain_arr = fliplr(finalvisualgain_arr);

for idx = 1:length(finalvisualgain_arr)
    params.network.leftring.status_plasticity = true;
    params.network.rightring.status_plasticity = true;    
    params.network.leftring.speedplasticity = 60*0.001;
    params.network.rightring.speedplasticity = 60*0.001;
    
    initialvisualgain = finalvisualgain_arr(idx);
    finalvisualgain = initialvisualgain;
    ang_lmbias = 0;

    % ratspeed_fluctuation_cov = 0.1;
    
    params.experiment = design_experiment_gainrecalibration(initialvisualgain, finalvisualgain);
    
    tic;
    [tvec, xmat] = simulate(x0, params, 1000, 'Solver', 1, 'TimeEvaluate', 0:0.1:1000);
    toc;

    [tsamples, bumpheight_centralring, bumpheight_leftring, bumpheight_rightring, ...
        bumpwidth_centralring, bumpwidth_leftring, bumpwidth_rightring, ...
        bumpmean_centralring, bumpmean_leftring, bumpmean_rightring, ...
        angwrapped_centralring, angwrapped_leftring, angwrapped_rightring, angwrapped_labframe, angwrapped_lmframe, ...
        pos_centralring, pos_leftring, pos_rightring, pos_labframe, pos_lmframe, ...
        vel_centralring, vel_leftring, vel_rightring, vel_labframe, vel_lmframe, ...
        pigain_leftring, pigain_rightring, hippgain_centralring, hippgain_leftring, hippgain_rightring, expgain, ...
        uthreshmat_leftring, uthreshmat_rightring, stdpigain_leftring, stdpigain_rightring] = process_ode45results(tvec, xmat, params, 'Resample', 0.02);    
 
    
     
        
    figure;
    plot(movmean(diff(pos_centralring),20));
    hold on;
    plot(movmean(diff(pos_labframe),20));


    
    figure;
    plot(tsamples/60, pigain_leftring, 'Linewidth', 2, 'Color', 'g');
    hold on;
    plot(tsamples/60, pigain_rightring, 'Linewidth', 2, 'Color', 'g');
    plot(tsamples/60, expgain, 'Linewidth', 2, 'Color', 'r', 'LineStyle', '--');
    ylim([0.5, 1.5]);

    figure;
    plot(tsamples, bumpmean_leftring);
    hold on;
    plot(tsamples, bumpmean_rightring);  
    plot(tsamples, params.network.leftring.baselineactivity_ring*ones(size(bumpmean_leftring)), '--');
    plot(tsamples, params.network.rightring.baselineactivity_ring*ones(size(bumpmean_rightring)), '--');

    figure;
    plot(tsamples, stdpigain_leftring);
    hold on;
    plot(tsamples, stdpigain_rightring);

    save(sprintf('kstar%d.mat', 10*finalvisualgain));
end

debug;


%% Recalibration failure
params.network.leftring.status_plasticity = true;
params.network.rightring.status_plasticity = true;
params.network.leftring.speedplasticity = 90*0.001;
params.network.rightring.speedplasticity = 90*0.001;

ang_lmbias = 0;

params.experiment = design_experiment_gainrecalibration(1, 0.1);

tic;
[tvec, xmat, dxmat] = simulate(x0, params, 450, 'Solver', 1, 'TimeEvaluate', 0:0.1:450);
toc;

[tsamples, bumpheight_centralring, bumpheight_leftring, bumpheight_rightring, ...
    bumpwidth_centralring, bumpwidth_leftring, bumpwidth_rightring, ...
    bumpmean_centralring, bumpmean_leftring, bumpmean_rightring, ...
    angwrapped_centralring, angwrapped_leftring, angwrapped_rightring, angwrapped_labframe, angwrapped_lmframe, ...
    pos_centralring, pos_leftring, pos_rightring, pos_labframe, pos_lmframe, ...
    vel_centralring, vel_leftring, vel_rightring, vel_labframe, vel_lmframe, ...
    pigain_leftring, pigain_rightring, hippgain_centralring, hippgain_leftring, hippgain_rightring, expgain, ...
    uthreshmat_leftring, uthreshmat_rightring] = process_ode45results(tvec, xmat, params, 'Resample', 0.02);

pos_error = pos_lmframe-pos_centralring;

close all;

figure;
plot(tsamples, pos_error-pos_error(1));
% hold on;
% plot(tsamples, movmean(pos_lmframe-pos_centralring,500));

figure;
plot(tsamples, expgain);
hold on;
plot(tsamples, hippgain_centralring)
plot(tsamples, pigain_leftring);



save(sprintf('kstar%d.mat', 10*finalvisualgain));

%% Pure path integration
params.network.leftring.status_plasticity = 0*0.001;
params.network.rightring.status_plasticity = 0*0.001;

ang_lmbias = 0;
ratspeed_average = 30;


params.experiment = design_experiment_gainrecalibration(1, 1);
params.experiment.status_landmarks = false;

tic;
[tvec, xmat, dxmat] = simulate(x0, params, 80, 'Solver', 1, 'TimeEvaluate', 0:0.01:80);
toc;

[tsamples, bumpheight_centralring, bumpheight_leftring, bumpheight_rightring, ...
    bumpwidth_centralring, bumpwidth_leftring, bumpwidth_rightring, ...
    bumpmean_centralring, bumpmean_leftring, bumpmean_rightring, ...
    angwrapped_centralring, angwrapped_leftring, angwrapped_rightring, angwrapped_labframe, angwrapped_lmframe, ...
    pos_centralring, pos_leftring, pos_rightring, pos_labframe, pos_lmframe, ...
    vel_centralring, vel_leftring, vel_rightring, vel_labframe, vel_lmframe, ...
    pigain_leftring, pigain_rightring, hippgain_centralring, hippgain_leftring, hippgain_rightring, expgain, ...
    uthreshmat_leftring, uthreshmat_rightring] = process_ode45results(tvec, xmat, params, 'Resample', 0.02);

pos_error = pos_lmframe-pos_centralring;

close all;

figure;
plot(pos_centralring);

figure;
plot(mod(pos_centralring(1279:end),360), diff(pos_centralring(1278:end)))
figure
plot(movmean(diff(pos_centralring),20));
hold on;
plot(movmean(diff(pos_labframe),20));
% hold on;
% plot(tsamples, movmean(pos_lmframe-pos_centralring,500));

figure;
plot(tsamples, bumpmean_centralring);
hold on;
plot(tsamples, bumpmean_leftring)
plot(tsamples, bumpmean_rightring);

figure;
plot(tsamples, bumpwidth_centralring);
hold on;
plot(tsamples, bumpwidth_leftring)
plot(tsamples, bumpwidth_rightring);
