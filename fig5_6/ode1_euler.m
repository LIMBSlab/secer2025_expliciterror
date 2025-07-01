function [tlog, xlog, dxlog] = ode1_euler(odevf, dt, tfinal, x0, numconfunc, varargin)


tspan = 0:dt:tfinal;

tlog = get_props_from_varargin(varargin, {'TimeEvaluate'}, {tspan});
filledlog = false(size(tlog));
xlog = zeros(length(x0),length(tlog));

if all(size(tlog) == size(tspan))
    is_logspan_same = true;
else
    is_logspan_same = false;
end

nsteps = length(tspan) - 1;
x = x0;
xlog(:,1) = x0;

filledlog(1) = true;

for istep = 1:nsteps
    t = tspan(istep);
    dx = odevf(t, x);
    
    tnext = tspan(istep+1);
    xnext = x + dx*dt;
    xnext = numconfunc(xnext);
    
    if is_logspan_same
        xlog(:,istep+1) = xnext;
        dxlog(:,istep) = dx;
    else
        if any(~filledlog(tlog >= t & tlog <= tnext))
            xlog(:,tlog >= t & tlog <= tnext & ~filledlog) = interp1([t, tnext].', [x, xnext].', tlog(:,tlog >= t & tlog <= tnext & ~filledlog)).';
            
            dxlog(:,tlog >= t & tlog <= tnext & ~filledlog) = dx;
            
            filledlog(tlog >= t & tlog <= tnext) = true;
        end
    end
    % 
    % if mod(t, 1) < 0.01
    %     Nneurons = 180;
    %     wmat_leftring = xlog(2*Nneurons+1:3*Nneurons,:);
    %     wmat_rightring = xlog(4*Nneurons+3:5*Nneurons+2,:);
    % 
    %     figure;
    %     clf;
    %     plot(mean(wmat_leftring, 1));
    %     hold on;
    %     plot(mean(wmat_rightring, 1));
    % end

    x = xnext;
end

xlog = xlog.';
dxlog = dxlog.';
