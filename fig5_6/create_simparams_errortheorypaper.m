function [params, x0] = create_simparams_errortheorypaper(Nneurons, varargin)

%%
is_visualinputs = get_props_from_varargin(varargin, {'StatusVisualInputs'}, {false});

global bumpwidth_visualring;
global ratspeed_average;
global ratspeed_fluctuation_cov;
global shiftvisual_rotring;

if isempty(bumpwidth_visualring)
    bumpwidthvisual = 5;
else
    bumpwidthvisual = abs(bumpwidth_visualring);
end

if is_visualinputs
    paramsnetwork.visualring.bumpwidth = bumpwidth_visualring;
    paramsnetwork.visualring.bumpamp = 0.6;
    
    [gaussref_array, xref_array] = compute_visualbump(0, 1, bumpwidth_visualring, 1000);

    % shiftvisual_rotring = round(360*0.5*(findfirst(gaussref_rotrings(:) == 1) - findfirst(gaussref_rotrings(:) > 0.5))/(Nneurons+1));
    shiftvisual_rotring = xref_array(findfirst(gaussref_array(:) == 1)) - xref_array(findfirst(gaussref_array(:) > 0.5));

    uref_visualring_rotrings = 0.6*gaussref_array;
else
    paramsnetwork.visualring = setparams_visualring(Nneurons, varargin{:});
end    


paramsnetwork.centralring = setparams_centralring(Nneurons, varargin{:});
paramsnetwork.leftring = setparams_leftring(Nneurons, varargin{:});
paramsnetwork.rightring = setparams_rightring(Nneurons, varargin{:});
paramsnetwork.leftspeedcells = setparams_leftspeedcells(Nneurons, varargin{:});
paramsnetwork.rightspeedcells = setparams_rightspeedcells(Nneurons, varargin{:});
% paramsnetwork.rightspeedcells = setparams_leftrightbalancelineattractor(Nneurons, varargin{:});

% paramsnetwork.visualassocring = setparams_visualassocring(Nneurons);

paramsexperiment.epochs = [];

params.network = paramsnetwork;
params.experiment = paramsexperiment;

%%
x0_ring = combine_ringstates_to_x(paramsnetwork.centralring.initialstate, ...
                                  paramsnetwork.leftring.initialstate, ...
                                  paramsnetwork.rightring.initialstate);
x0 = [x0_ring; 0; 0];

%%
status_leftringplasticity_backup = params.network.leftring.status_plasticity;
status_rightringplasticity_backup = params.network.rightring.status_plasticity;
is_adaptivesearch4plasticity = get_props_from_varargin(varargin, {'AdaptiveSearchForPlasticityThresholds'}, {false});

if status_leftringplasticity_backup && status_rightringplasticity_backup && is_adaptivesearch4plasticity
    params.network.leftring.status_plasticity = false;
    params.network.rightring.status_plasticity = false;        
    
    ratspeed_fluctuation_cov_backup = ratspeed_fluctuation_cov;
    ratspeed_fluctuation_cov = 0;
    params.experiment = design_experiment_gainrecalibration(1, 1);
    ratspeed_fluctuation_cov = ratspeed_fluctuation_cov_backup;

    params.experiment.status_landmarks = false;

    % params.experiment.status_landmarks = true;
    
    [tvec, xmat] = simulate(x0, params, 60, 'Solver', 1);

    [tsamples, bumpheight_centralring, bumpheight_leftring, bumpheight_rightring, ...
     bumpwidth_centralring, bumpwidth_leftring, bumpwidth_rightring, ...
     bumpmean_centralring, bumpmean_leftring, bumpmean_rightring, ...
     angwrapped_centralring, angwrapped_leftring, angwrapped_rightring, angwrapped_labframe, angwrapped_lmframe, ...
     pos_centralring, pos_leftring, pos_rightring, pos_labframe, pos_lmframe, ...
     vel_centralring, vel_leftring, vel_rightring, vel_labframe, vel_lmframe] = process_ode45results(tvec, xmat, params, 'Resample', 0.02);  

    dxlab = [0, movmean(diff(pos_labframe),10)];
    dxring = [0, movmean(diff(pos_centralring),10)];

    kpi = mean(dxring(end-200:end-100))/mean(dxlab(end-200:end-100));

    u0_leftspeed = encode_speedresponse(0, paramsnetwork.leftspeedcells.encode.settings);
    params.network.leftring.baselineactivity_speed = u0_leftspeed;
    
    xleftring = map_x_to_leftringstates(xmat(:,end), paramsnetwork.leftring);
    uleftring = get_activitystates_rotring(xleftring);       
    bumpleft_last = uleftring;
    
    tmp = interp1(linspace(-180, +180, length(bumpleft_last)+1), [bumpleft_last; bumpleft_last(1)], -180:0.001:179.99);
    params.network.leftring.baselineactivity_ring = mean(tmp(tmp > 0));
    % params.network.leftring.baselineactivity_ring = mean(tmp); 

    u0_rightspeed = encode_speedresponse(0, paramsnetwork.rightspeedcells.encode.settings);
    params.network.rightring.baselineactivity_speed = u0_rightspeed;

    xrightring = map_x_to_rightringstates(xmat(:,end), paramsnetwork.rightring);
    urightring = get_activitystates_rotring(xrightring);       
    bumpright_last = urightring;

    tmp = interp1(linspace(-180, +180, length(bumpright_last)+1), [bumpright_last; bumpright_last(1)], -180:0.001:179.99);
    params.network.rightring.baselineactivity_ring = mean(tmp(tmp > 0));
    % params.network.rightring.baselineactivity_ring = mean(tmp);

    params.experiment = design_experiment_gainrecalibration(1, 1);
    
    [tvec, xmat] = simulate(x0, params, 60, 'Solver', 1);

    [tsamples, bumpheight_centralring, bumpheight_leftring, bumpheight_rightring, ...
     bumpwidth_centralring, bumpwidth_leftring, bumpwidth_rightring, ...
     bumpmean_centralring, bumpmean_leftring, bumpmean_rightring, ...
     angwrapped_centralring, angwrapped_leftring, angwrapped_rightring, angwrapped_labframe, angwrapped_lmframe, ...
     pos_centralring, pos_leftring, pos_rightring, pos_labframe, pos_lmframe, ...
     vel_centralring, vel_leftring, vel_rightring, vel_labframe, vel_lmframe] = process_ode45results(tvec, xmat, params, 'Resample', 0.01);  

    dxlab = [0, movmean(diff(pos_labframe),1)];

    idxgoback = find(pos_centralring > pos_centralring(end) - 360, 1, 'first');

    tmpleftarr2 = [];
    tmprightarr2 = [];    
    tmpleftarr3 = [];
    tmprightarr3 = [];
    for idx_resample = idxgoback:length(vel_labframe)
        if abs(dxlab(idx_resample)) < 1e-5
            continue;
        end

        idx = out2(@() findClosest(tsamples(idx_resample), tvec));

        xleftring = map_x_to_leftringstates(xmat(:,idx), paramsnetwork.leftring);
        uleftring = get_activitystates_rotring(xleftring);       
        bumpleft_last = uleftring;

        tmp = interp1(linspace(-180, +180, length(bumpleft_last)+1), [bumpleft_last; bumpleft_last(1)], -180:0.001:179.99);
        tmpleftarr2 = [tmpleftarr2, mean(tmp(tmp > 0))];
        tmpleftarr3 = [tmpleftarr3, mean(tmp(tmp > 0)*dxlab(idx_resample))/mean(dxlab(idx_resample))];

        xrightring = map_x_to_rightringstates(xmat(:,idx), paramsnetwork.rightring);
        urightring = get_activitystates_rotring(xrightring);       
        bumpright_last = urightring;        

        tmp = interp1(linspace(-180, +180, length(bumpright_last)+1), [bumpright_last; bumpright_last(1)], -180:0.001:179.99);

        tmprightarr2 = [tmprightarr2, mean(tmp(tmp > 0))];
        tmprightarr3 = [tmprightarr3, mean(tmp(tmp > 0)*dxlab(idx_resample))/mean(dxlab(idx_resample))];
    end

    params.network.leftring.baselineactivity_ring2 = mean(tmpleftarr2);
    params.network.rightring.baselineactivity_ring2 = mean(tmprightarr2);    
    params.network.leftring.baselineactivity_ring3 = mean(tmpleftarr3);
    params.network.rightring.baselineactivity_ring3 = mean(tmprightarr3);

    params.network.leftring.status_plasticity = status_leftringplasticity_backup;
    params.network.rightring.status_plasticity = status_rightringplasticity_backup;
end

%%
save('simparams_lmoff.mat', 'Nneurons', 'params', 'x0');