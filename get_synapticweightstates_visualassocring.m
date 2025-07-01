function W = get_synapticweightstates_visualassocring(x)

N = length(x);
Ls = roots([1, 1, -N]);
L = Ls(1);
% u = x(1:(length(x)-1)/2);
W = x(L+1:end);

% activity = params.readactivity;
% 
% U = activity.func(x, activity.settings);

