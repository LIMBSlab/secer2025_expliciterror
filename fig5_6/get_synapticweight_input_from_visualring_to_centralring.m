function W = get_synapticweight_input_from_visualring_to_centralring(u, params)

inputconn = params.connectivity.inputVisualWeight;

% W = inputweight_visual(u, inputconn.settings);
W = inputconn.value;
% V = inputconn.func(x, inputconn.settings);