function xring = map_x_to_leftringstates(xnetwork, params_leftring)

L = length(params_leftring.neurons.pos);
xring = xnetwork(L+1:3*L+2);
% xring = xnetwork(L+1:3*L);