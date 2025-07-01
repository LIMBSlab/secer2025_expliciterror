function [weightsamples_requested, distsamples_requested] = recurrentweight_gaussian(x, settings, varargin)

distsamples_highres = linspace(-180, +180, 720*max(settings.range,1));
weightsamples_highres = normpdf(deg2rad(distsamples_highres)*settings.range, 0, 1);
weightsamples_highres = (weightsamples_highres - weightsamples_highres(end))/(max(weightsamples_highres) - weightsamples_highres(end));
weightsamples_highres = (settings.amp_shortrange - settings.amp_longrange)*weightsamples_highres + settings.amp_longrange;

distsamples_highres_expanded = [distsamples_highres(1:end-1)-360, distsamples_highres, distsamples_highres(2:end)+360];
weightsamples_highres_expanded = [weightsamples_highres(1:end-1), weightsamples_highres, weightsamples_highres(2:end)];

distsamples_requested_default = linspace(0, 360, length(x)+1).';
distsamples_requested_default = distsamples_requested_default(1:end-1);

distsamples_requested = get_props_from_varargin(varargin, {'Distance'}, {distsamples_requested_default});
weight0samples_requested = interp1(distsamples_highres_expanded, weightsamples_highres_expanded, distsamples_requested);

weightsamples_requested = circshift(weight0samples_requested, [settings.shiftdir*round(length(x)*settings.shiftdegrees/360), 0]);

% interp1(xsamples_nonunique, wsamples_nonunique, xsamples);