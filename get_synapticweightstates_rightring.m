function w = get_synapticweightstates_rightring(x)

w = x((length(x)-1)/2+1:end-1);
% w = x(length(x)/2+1:end);

% synapticweights = params.readsynapticweights;

% U = synapticweights.func(x, synapticweights.settings);
