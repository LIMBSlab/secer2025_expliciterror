function u = get_activitystates_visualassocring(x)

N = length(x);
Ls = roots([1, 1, -N]);
L = Ls(1);
% u = x(1:(length(x)-1)/2);
u = x(1:L);

% activity = params.readactivity;
% 
% U = activity.func(x, activity.settings);

