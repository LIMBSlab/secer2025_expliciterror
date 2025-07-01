function [upre_thresh, upost_thresh] = get_plasticitythresholds_leftring(x)

upre_thresh = x(end-1);
upost_thresh = x(end);

% w = x(length(x)/2+1:end);

% synapticweights = params.readsynapticweights;
% U = synapticweights.func(x, synapticweights.settings);
