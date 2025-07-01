function dxleftring = visualassoc_vf(xvisualassoc, ucentralring, uvisualring, statusvisual, params_visualassoc)

tau = params_visualassoc.timeconstant;
status_plasticity = params_visualassoc.plasticity_status;
tau_pl = params_visualassoc.plasticity_timeconstant;
beta_pl = params_visualassoc.plasticity_degree;

uvisualassoc = get_activitystates_visualassocring(xvisualassoc);
N = length(uvisualassoc);

Wvisual_flat = get_synapticweightstates_visualassocring(xvisualassoc);
Wvisual = reshape(Wvisual_flat, N, N);

%%
if statusvisual
    Is = Wvisual*uvisualring + ucentralring;
    
    duvisualassoc = (-uvisualassoc + synapticactivation_function(Is))/tau;
    
    if status_plasticity
        dWvisual = (-Wvisual + beta_pl*uvisualassoc(:)*uvisualring(:).')/tau_pl;
    else
        dWvisual = zeros(length(uvisualassoc), length(uvisualring));
    end
    dWvisual_flat = reshape(Wvisual, [], 1);
    
    dxvisualassoc = [duvisualassoc; dWvisual_flat];
else
    dxvisualassoc = zeros(size(xvisualassoc));
end