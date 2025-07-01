function W = get_synapticweight_input_from_visualring_to_rotring(u, params)

inputconn = params.connectivity.inputVisualWeight;
% W = inputweight_visual(u, inputconn.settings);
W = inputconn.value;

% U = inputconn.func(u, inputconn.settings);