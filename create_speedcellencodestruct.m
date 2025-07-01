function encodestruct = create_speedcellencodestruct(varargin)

[baseline0, slope0, dir0] = get_props_from_varargin(varargin,{'Baseline','Slope','Direction'},{0.07, 1.9E-3, -1});

encodestruct.settings.baseline = baseline0;
encodestruct.settings.slope = slope0;
encodestruct.settings.dir = dir0;

% encodestruct.func = @(vel, settings) settings.baseline + settings.dir*settings.slope*vel;