function W = get_synapticweight_input_from_rightring_to_centralring(u, params)

inputconn = params.connectivity.inputRightWeight;

% W = recurrentweight_gaussian(u, inputconn.settings);
W = inputconn.value;

% U = inputconn.func(x, inputconn.settings);
