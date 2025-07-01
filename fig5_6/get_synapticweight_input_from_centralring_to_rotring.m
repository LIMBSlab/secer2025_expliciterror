function W = get_synapticweight_input_from_centralring_to_rotring(u, params)

inputconn = params.connectivity.inputCentralWeight;

% W = recurrentweight_gaussian(u, inputconn.settings);
W = inputconn.value;
% U = inputconn.func(x, inputconn.settings);
