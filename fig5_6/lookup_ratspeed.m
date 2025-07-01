function ratvelocity = lookup_ratspeed(t, epochs)

ratvelocity = zeros(size(t));

t0 = 0;
for i = 1:length(epochs)
    try
    is_in_epoch = t >= t0 + epochs(i).time(1) & t < t0 + epochs(i).time(end);
    catch
        debug;
    end
    tq = t(is_in_epoch) - min(epochs(i).time);
    tq = t(is_in_epoch) - t0;
    if isnumeric(epochs(i).velocity)
        if any(is_in_epoch)
            if length(tq) > 1
                ratvelocity(is_in_epoch) = interp1(epochs(i).time, epochs(i).velocity, tq);
            else
                ratvelocity(is_in_epoch) = lininterpwextrap_sorted(epochs(i).time, epochs(i).velocity, tq);
            end        
        end
    else
        ratvelocity(is_in_epoch) = epochs(i).velocity(tq);
    end
    
    t0 = t0 + epochs(i).time(end);
end