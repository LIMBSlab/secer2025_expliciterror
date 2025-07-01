function xvisualassoc = map_x_to_visualassocringstates(xnetwork, params_visualassoc)

L = length(params_visualassoc.neurons.pos);
% xcentral = xnetwork(3*L+2:5*L+2);
xvisualassoc = xnetwork(5*L+1:6*L+L^2);