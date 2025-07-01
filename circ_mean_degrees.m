function [mu_deg, ul_deg, ll_deg] = circ_mean_degrees(alpha_deg, w, dim)

alpha_deg = alpha_deg(:);

alpha = deg2rad(alpha_deg);

if nargin == 1
    [mu, ul, ll] = circ_mean(alpha);
elseif nargin == 2
    [mu, ul, ll] = circ_mean(alpha, w);
elseif nargin > 2
    [mu, ul, ll] = circ_mean(alpha, w, dim);
end

mu_deg = rad2deg(mu);
ul_deg = rad2deg(ul);
ll_deg = rad2deg(ll);