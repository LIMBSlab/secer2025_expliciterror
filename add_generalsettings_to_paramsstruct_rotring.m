function params_out = add_generalsettings_to_paramsstruct_rotring(params_in, varargin)

global tonicdrive_visual_rotring;

params_out = params_in;

params_out.tonicdrive = 0.5;

if isempty(tonicdrive_visual_rotring)
    params_out.tonicdrive_visual = 1.5;
else
    params_out.tonicdrive_visual = tonicdrive_visual_rotring;
end

[u0_ring, u0_speed] = get_props_from_varargin(varargin, {'BaselineActivityLevelRing', 'BaselineActivityLevelSpeed'}, {0,0});

gamma_plasticity = get_props_from_varargin(varargin, {'DegreeOfPlasticity'},{1e-3});

params_out.baselineactivity_ring = u0_ring;
params_out.baselineactivity_speed = u0_speed;
params_out.speedplasticity = gamma_plasticity;

status_plasticity = get_props_from_varargin(varargin, {'StatusPlasticity'}, {false});
params_out.status_plasticity = status_plasticity;

uthresh = 0.4;
umax = 1;

u0 = (umax+uthresh)*(max(cosd(params_out.neurons.pos(:)),uthresh) - uthresh);
w0 = 1.6*ones(length(params_out.neurons.pos),1);

% params_out.initialstate = [u0; w0; mean(u0)];
params_out.initialstate = [u0; w0; 0; 0];
params_out.timeconstant = 20e-3;
