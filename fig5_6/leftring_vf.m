function dxleftring = leftring_vf(xleftring, ucentralring, urightring, uvisualring, uleftspeed, statusvisual, ratspeed, params_leftring)

tau = params_leftring.timeconstant;
utonic = params_leftring.tonicdrive;

% if statusvisual
%     utonic_visual = params_leftring.tonicdrive_visual;
% else
utonic_visual = 0;
% end

uleftring = get_activitystates_leftring(xleftring);
Bspeed = get_synapticweightstates_leftring(xleftring);
[u0speed, u0ring] = get_plasticitythresholds_leftring(xleftring);

% uleftring_thresh = xleftring(end);

L = length(uleftring);

wself_left = get_synapticweight_recurrentProfile_leftring(uleftring, params_leftring);
winput_center = get_synapticweight_input_from_centralring_to_leftring(uleftring, params_leftring);
Bvisual = get_synapticweight_input_from_visualring_to_leftring(uleftring, params_leftring);

%%
% duleftring_thresh = (-uleftring_thresh + mean(uleftring))/5000;

%%
% u0ring = params_leftring.baselineactivity_ring;
% u0speed = params_leftring.baselineactivity_speed;
beta = params_leftring.speedplasticity;

% stop recalibration plasticity if no landmarks or no plasticity flag or no
% movement
if ~statusvisual || ~params_leftring.status_plasticity || abs(ratspeed) < 1e-5
    dBspeed = zeros(size(uleftring));
else
    dBspeed = beta*(uleftspeed - u0speed).*(uleftring - u0ring);
end

% easier to assume an adaptive threshold learning mechanism than
% hard-coding it. this is active when animal is stationary
if abs(ratspeed) < 1e-5
    du0speed = (-u0speed + uleftspeed)/0.1;
    du0ring = (-u0ring + uleftring)/0.1;
else
    du0speed = 0;
    du0ring = 0;
end

%%
Is = cconv(wself_left, uleftring, L)*(2*pi)/L ...
    + cconv(winput_center, ucentralring, L)*(2*pi)/L ...
    + Bvisual*uvisualring + Bspeed*uleftspeed ...
    + utonic + utonic_visual - 10*(mean(urightring)+mean(uleftring));

duleftring = (-uleftring + synapticactivation_function(Is))/tau;

%%
% dxleftring = [duleftring; dBspeed; duleftring_thresh];
dxleftring = [duleftring; dBspeed; du0speed; du0ring];