function lmbias = lookup_lmbias(t, epochs)


status_landmarks = lookup_landmarkstatus(t, epochs);

lmbias = ones(size(t));

t0 = 0;
for i = 1:length(epochs)
    is_in_epoch = t >= t0 + epochs(i).time(1) & t < t0 + epochs(i).time(end);
    tq = t(is_in_epoch) - min(epochs(i).time);
    tq = t(is_in_epoch) - t0;

    if isnumeric(epochs(i).position2lm)
        if any(is_in_epoch)
            if length(tq) > 1
                lmbias_tmp = interp1(epochs(i).time, epochs(i).lmbias, tq);
            else
                lmbias_tmp = lininterpwextrap_sorted(epochs(i).time, epochs(i).lmbias, tq);
            end        
        end
    else
        lmbias_tmp = epochs(i).lmbias(tq);
    end

    lmbias_tmp(~status_landmarks(is_in_epoch)) = nan;
    lmbias(is_in_epoch) = lmbias_tmp;    

    t0 = t0 + epochs(i).time(end);
end