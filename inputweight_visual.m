function W = inputweight_visual(u, settings)

W = 0*u;
for i = 1:length(settings.shiftdir)
    shiftidx = length(u)*settings.shiftdegrees(i)/360;
    shiftidx_floor = floor(shiftidx);
    w_floor = shiftidx - shiftidx_floor;
    shiftidx_ceil = ceil(shiftidx);
    w_ceil = shiftidx_ceil - shiftidx;

    shiftidx_floor = mod(settings.shiftdir(i)*shiftidx_floor, length(u)) + 1;
    shiftidx_ceil = mod(settings.shiftdir(i)*shiftidx_ceil, length(u)) + 1;
    
    if shiftidx_floor == shiftidx_ceil
        W(shiftidx_floor) = W(shiftidx_floor) + settings.amp(i);
    else
        W(shiftidx_floor) = W(shiftidx_floor) + settings.amp(i)*w_floor;
        W(shiftidx_ceil) = W(shiftidx_ceil) + settings.amp(i)*w_ceil;
    end
    % W = W + circshift(settings.amp(i)*eye(length(u)),[settings.shiftdir(i)*round(length(u)*settings.shiftdegrees(i)/360), 0]);
end