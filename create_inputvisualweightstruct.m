function inputvisualweights = create_inputvisualweightstruct(varargin)

connstrength = 1;
connshiftdeg = 0;
connshiftdir = +1;

[connstrength, connshiftdeg, connshiftdir, Nneurons] = get_props_from_varargin(varargin, {'Strength', 'ShiftAmount', 'ShiftDirection', 'Nneurons'}, ...
                                                                                         {connstrength, connshiftdeg, connshiftdir, 360});

inputvisualweights.settings.shiftdegrees = connshiftdeg;
inputvisualweights.settings.shiftdir = connshiftdir;
inputvisualweights.settings.amp = connstrength;

inputvisualweights.value = inputweight_visual(zeros(Nneurons,1), inputvisualweights.settings);


% inputvisualweights.func = @(x, settings) circshift(settings.amp*eye(length(x)),[settings.shiftdir*round(length(x)*settings.shiftdegrees/360), 0]);