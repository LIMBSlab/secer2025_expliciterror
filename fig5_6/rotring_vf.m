function dxrotring = rotring_vf(xrotring, ucentralring, uotherrotring, uvisualring, urotspeed, statusvisual, ratspeed, params_rotring)

tau = params_rotring.timeconstant;
utonic = params_rotring.tonicdrive;
utonic = 0;

% if statusvisual
%     utonic_visual = params_leftring.tonicdrive_visual;
% else
utonic_visual = 0;
% end

urotring = get_activitystates_rotring(xrotring);
Bspeed = get_synapticweightstates_rotring(xrotring);

% uleftring_thresh = xleftring(end);

L = length(urotring);

wself_left = get_synapticweight_recurrentProfile_rotring(urotring, params_rotring);
winput_center = get_synapticweight_input_from_centralring_to_rotring(urotring, params_rotring);
Bvisual = get_synapticweight_input_from_visualring_to_rotring(urotring, params_rotring);

%%
% duleftring_thresh = (-uleftring_thresh + mean(uleftring))/5000;

%%
u0ring = params_rotring.baselineactivity_ring;
% u0ring = params_rotring.baselineactivity_ring2;
% u0ring = params_rotring.baselineactivity_ring3;
u0speed = params_rotring.baselineactivity_speed;

B0speed = get_synapticweightstates_rotring(params_rotring.initialstate);

beta = params_rotring.speedplasticity;

% stop recalibration plasticity if no landmarks or no plasticity flag or no
% movement
if ~statusvisual || ~params_rotring.status_plasticity || abs(ratspeed) < 1e-5
    dBspeed = zeros(size(urotring));
else
    dBspeed = 100*beta*(urotspeed - u0speed).*(urotring - u0ring);
    % dBspeed = 100*beta*(urotspeed - u0speed).*(urotring - u0ring) - 1e-4*(Bspeed - B0speed);
    dBspeed = 100*beta*(urotring > 0).*((urotspeed - u0speed).*(urotring - u0ring) - 1e-4*(Bspeed-B0speed));
end

if mean(dBspeed) > 1e-8
    debug;
elseif mean(dBspeed) < -1e-7
    debug;
end

% easier to assume an adaptive threshold learning mechanism than
% hard-coding it. this is active when animal is stationary
% if abs(ratspeed) < 1e-5
%     du0speed = (-u0speed + mean(urotspeed))/0.1;
%     du0ring = (-u0ring + mean(urotring))/0.1;
% else
    du0speed = 0;
    du0ring = 0;
% end

%%
Is = cconv(wself_left, urotring, L)*(2*pi)/L ...
    + cconv(winput_center, ucentralring, L)*(2*pi)/L ...
    + cconv(Bvisual, uvisualring, L) + Bspeed*urotspeed ...
    + utonic + utonic_visual - 20*(mean(urotring)+mean(uotherrotring));

durotring = (-urotring + synapticactivation_function(Is))/tau;

%%
% dxleftring = [duleftring; dBspeed; duleftring_thresh];
dxrotring = [durotring; dBspeed; du0speed; du0ring];