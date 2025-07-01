function W = get_synapticweight_recurrentProfile_rotring(u, params)

% nids = params.neurons.id;
% Npos = params.neurons.pos;

recurrentconn = params.connectivity.recurrentWeightProfile;
% W = recurrentweight_gaussian(u, recurrentconn.settings);
W = recurrentconn.value;