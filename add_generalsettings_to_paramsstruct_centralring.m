function params_out = add_generalsettings_to_paramsstruct_centralring(params_in, varargin)

global tonicdrive_visual_centralring;

params_out = params_in;

params_out.tonicdrive = 0.00;

if isempty(tonicdrive_visual_centralring)
    params_out.tonicdrive_visual = 0.1;
else
    params_out.tonicdrive_visual = tonicdrive_visual_centralring;
end

uthresh = 0.6;
umax = 1;

u0 = (umax+uthresh)*(max(cosd(params_out.neurons.pos(:)),uthresh) - uthresh);

params_out.initialstate = u0;
params_out.timeconstant = 20e-3;