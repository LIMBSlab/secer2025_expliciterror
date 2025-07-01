function [tvec, xmat, dxmat] = simulate(x0, params, tfinal, varargin)

[solvertype, plot_status, tspan] = get_props_from_varargin(varargin, {'Solver', 'PlotStatus', 'TimeEvaluate'}, {1, false, nan});

% if ~plot_status
if solvertype == 23
    if isnan(tspan)
        tspan = [0, tfinal];
    end
    [tvec, xmat] = ode23(@(t, x) sim_vf(t, x, params), tspan, x0);
    dxmat = 0*xmat;
elseif solvertype == 45
    if isnan(tspan)
        tspan = [0, tfinal];
    end    
    [tvec, xmat] = ode45(@(t, x) sim_vf(t, x, params), tspan, x0);
    dxmat = 0*xmat;
elseif solvertype == 1
    dt = 1e-3;
    
    if isrow(x0)
        numcon = @(x) [max(x(1:end-2),0), x(end-1:end)];
    else
        numcon = @(x) [max(x(1:end-2),0); x(end-1:end)];
    end
    
    if isnan(tspan)
        [tvec, xmat, dxmat] = ode1_euler(@(t, x) sim_vf(t, x, params), dt, tfinal, x0, numcon);
    else
        [tvec, xmat, dxmat] = ode1_euler(@(t, x) sim_vf(t, x, params), dt, tfinal, x0, numcon, 'TimeEvaluate', tspan);
    end
else
    if isnan(tspan)
        tspan = [0, tfinal];
    end    

    options = odeset('RelTol', 1e-4, 'AbsTol', 1e-7, 'NonNegative', 1:length(x0)-2);
    [tvec, xmat] = ode15s(@(t, x) sim_vf(t, x, params), tspan, x0, options);    
    dxmat = 0*xmat;
    % [tvec, xmat] = ode113(@(t, x) sim_vf(t, x, params), tspan, x0);    
end


tvec  = tvec(:).';
xmat = xmat.'; 

