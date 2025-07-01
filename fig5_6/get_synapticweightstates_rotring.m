function w = get_synapticweightstates_rotring(xrot)

w = xrot((length(xrot)-2)/2+1:end-2);
% w = x(length(x)/2+1:end);

% synapticweights = params.readsynapticweights;
% U = synapticweights.func(x, synapticweights.settings);
