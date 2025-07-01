function vq = lininterpwextrap_sorted(X, V, xq)
% linear interpolation, given set of X and V values, and an x query
% assumes X values are in strictly increasing order
%
% Differences from matlab built-in :
%       much, much faster
%       if coordinate is exactly on the spot, doesn't look at neighbors.  e.g. interpolate([blah, blah2], [0, NaN], blah) returns 0 instead of NaN
%       extends values off the ends instead of giving NaN
%       

% if length(X) ~= length(V), error('X and V sizes do not match'); end

vq = 0;

N = length(X);
if X(1) >= xq % xquery is less than every element of X
    infindex = 1;
elseif xq >= X(N)  % xquery is greater than every element of X
    infindex = N-1;
else
    infindex = find((xq >= X), 1, 'last');
end

xinf = X(infindex); vinf = V(infindex);
xsup = X(infindex+1); vsup = V(infindex+1);

if xq == xinf
   vq(1) = vinf;
elseif xq == xsup
   vq(1) = vsup;
else
   vq(1) = vinf + (xq - xinf)*(vsup-vinf)/(xsup-xinf);
end
