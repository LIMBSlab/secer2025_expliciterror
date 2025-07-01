function xcentral = map_x_to_rightringstates(xnetwork, params_rightring)

L = length(params_rightring.neurons.pos);
xcentral = xnetwork(3*L+3:5*L+4);
% xcentral = xnetwork(3*L+1:5*L);