function recurrentweights = create_recurrentweightstruct(varargin)

connrange = 1.5;
wiggleorder = 2;
amp0 = 0.1;
ampinf = -0.05;
connshiftdeg = 0;
connshiftdir = +1;
conntype = 'Gaussian';
Nneurons = 360;

[connrange, wiggleorder, amp0, ampinf, connshiftdeg, connshiftdir, conntype, Nneurons] = get_props_from_varargin(varargin, {'Range','WiggleOrder','StrengthShortRange',...
                                                                                                                  'StrengthLongRange','ShiftAmount','ShiftDirection', ...
                                                                                                                  'Type', 'Nneurons'}, ...
                                                                                                                  {connrange, wiggleorder, amp0, ...
                                                                                                                  ampinf, connshiftdeg, connshiftdir, ...
                                                                                                                  conntype, Nneurons});

recurrentweights.settings.range = connrange;
recurrentweights.settings.wiggleorder = wiggleorder;
recurrentweights.settings.amp_shortrange = amp0;
recurrentweights.settings.amp_longrange = ampinf;
recurrentweights.settings.shiftdegrees = connshiftdeg;
recurrentweights.settings.shiftdir = connshiftdir;
recurrentweights.settings.conntype = conntype;

recurrentweights.value = recurrentweight_gaussian(zeros(Nneurons,1), recurrentweights.settings);

% 
% if strcmp(conntype, 'Gaussian')
%     recurrentweights.func = @(x, settings) circshift(recurrentweight_gaussian(x, settings), [settings.shiftdir*round(length(x)*settings.shiftdegrees/360), 0]);
% elseif strcmp(conntype, 'MexicanHat')
%     recurrentweights.func = @(x, settings) circshift(recurrentweight_mexihat(x, settings), [settings.shiftdir*round(length(x)*settings.shiftdegrees/360), 0]);
% else
%     recurrentweights.func = @(x, settings) circshift(recurrentweight_gaussian(x, settings), [settings.shiftdir*round(length(x)*settings.shiftdegrees/360), 0]);
% end