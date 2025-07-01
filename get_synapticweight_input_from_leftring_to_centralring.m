function W = get_synapticweight_input_from_leftring_to_centralring(u, params)

inputconn = params.connectivity.inputLeftWeight;

% W = recurrentweight_gaussian(u, inputconn.settings);
W = inputconn.value;

% U = inputconn.func(x, inputconn.settings);
