function dxrightring = rightring_vf(xrightring, ucentralring, uleftring, uvisualring, urightspeed, statusvisual, ratspeed, params_rightring)

tau = params_rightring.timeconstant;
utonic = params_rightring.tonicdrive;

% if statusvisual
    % utonic_visual = params_rightring.tonicdrive_visual;
% else
    utonic_visual = 0;
% end

urightring = get_activitystates_rightring(xrightring);
Bspeed = get_synapticweightstates_rightring(xrightring);
% urightring_thresh = xrightring(end);

L = length(urightring);

wself_right = get_synapticweight_recurrentProfile_rightring(urightring, params_rightring);
winput_center = get_synapticweight_input_from_centralring_to_rightring(urightring, params_rightring);
Bvisual = get_synapticweight_input_from_visualring_to_rightring(urightring, params_rightring);

%%
% durightring_thresh = (-urightring_thresh + mean(urightring))/5000;

%%
% u0ring = params_rightring.baselineactivity_ring;
% u0speed = params_rightring.baselineactivity_speed;
beta = params_rightring.speedplasticity;

% stop recalibration plasticity if no landmarks or no plasticity flag or no
% movement
if ~statusvisual || ~params_rightring.status_plasticity || abs(ratspeed) < 1e-5
    dBspeed = zeros(size(uleftring));
else
    dBspeed = beta*(uleftspeed - u0speed).*(uleftring - u0ring);
end


if all(uvisualring == 0) || ~params_rightring.status_plasticity
    dBspeed = zeros(size(urightring));
else
    dBspeed = plasticity_covariancerule(beta, urightspeed, urightring, u0speed, u0ring);
end

%%
Is = cconv(wself_right, urightring, L)*(2*pi)/L ...
    + cconv(winput_center, ucentralring, L)*(2*pi)/L ...
    + Bvisual*uvisualring + Bspeed*urightspeed ...
    + utonic + utonic_visual - 10*(mean(urightring)+mean(uleftring));

durightring = (-urightring + synapticactivation_function(Is))/tau;

%%
% dxrightring = [durightring; dBspeed; durightring_thresh];
dxrightring = [durightring; dBspeed];