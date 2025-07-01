function lmgain = lookup_lmgain(t, epochs)


status_landmarks = lookup_landmarkstatus(t, epochs);

lmgain = ones(size(t));

t0 = 0;
for i = 1:length(epochs)
    is_in_epoch = t >= t0 + epochs(i).time(1) & t < t0 + epochs(i).time(end);
    tq = t(is_in_epoch) - min(epochs(i).time);
    tq = t(is_in_epoch) - t0;

    if isnumeric(epochs(i).position2lm)
        if any(is_in_epoch)
            if length(tq) > 1
                lmgain_tmp = interp1(epochs(i).time, epochs(i).lmgain, tq);
            else
                lmgain_tmp = lininterpwextrap_sorted(epochs(i).time, epochs(i).lmgain, tq);
            end        
        end
    else
        lmgain_tmp = epochs(i).lmgain(tq);
    end

    lmgain_tmp(~status_landmarks(is_in_epoch)) = nan;
    lmgain(is_in_epoch) = lmgain_tmp;    

    t0 = t0 + epochs(i).time(end);
end