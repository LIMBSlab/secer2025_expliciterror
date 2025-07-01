function ducentralring = centralring_vf(ucentralring, uleftring, urightring, uvisualring, statusvisual, params_centralring)

tau = params_centralring.timeconstant;
utonic = params_centralring.tonicdrive;
utonic = 0.8;

% if statusvisual
%     utonic_visual = params_centralring.tonicdrive_visual;
% else
    utonic_visual = 0;
% end

% ucentralring = get_activitystates_centralring(ucentralring, params_centralring);
L = length(ucentralring);

wself_central = get_synapticweight_recurrentProfile_centralring(ucentralring, params_centralring);
winput_left = get_synapticweight_input_from_leftring_to_centralring(ucentralring, params_centralring)/3;
winput_right = get_synapticweight_input_from_rightring_to_centralring(ucentralring, params_centralring)/3;
Bvisual = get_synapticweight_input_from_visualring_to_centralring(ucentralring, params_centralring);

Is = cconv(wself_central, ucentralring, L)*(2*pi)/L ...
   + cconv(winput_left, uleftring, L)*(2*pi)/L ...
   + cconv(winput_right, urightring, L)*(2*pi)/L ...
   + utonic + utonic_visual + cconv(Bvisual, uvisualring, L);
%    + cconv(Bvisual, uvisualring, L)*(2*pi)/L;

ducentralring = (-ucentralring + synapticactivation_function(Is))/tau;