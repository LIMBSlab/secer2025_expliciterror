function W = get_synapticweight_recurrentProfile_centralring(u, params)

% nids = params.neurons.id;
% Npos = params.neurons.pos;

recurrentconn = params.connectivity.recurrentWeightProfile;
% W = recurrentweight_gaussian(u, recurrentconn.settings);
W = recurrentconn.value;
% w = recurrentconn.func(Npos, recurrentconn.settings);