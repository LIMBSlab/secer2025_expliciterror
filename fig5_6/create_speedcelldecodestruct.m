function decodestruct = create_speedcelldecodestruct(varargin)

[baseline0, slope0, dir0] = get_props_from_varargin(varargin,{'Baseline','Slope','Direction'},{10, 0.1, -1});

decodestruct.settings.baseline = baseline0;
decodestruct.settings.slope = slope0;
decodestruct.settings.dir = dir0;

% encodestruct.func = @(activity, settings) (activity - settings.baseline)/(settings.dir*settings.slope);