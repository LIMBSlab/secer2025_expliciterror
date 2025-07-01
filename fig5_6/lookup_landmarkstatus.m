function landmarkstatus = lookup_landmarkstatus(t, epochs)

landmarkstatus = zeros(size(t));

t0 = 0;
for i = 1:length(epochs)
    is_in_epoch = t >= t0 + epochs(i).time(1) & t < t0 + epochs(i).time(end);
    if isfield(epochs(i),'status_landmarks')
        if any(is_in_epoch)
            landmarkstatus(is_in_epoch) = epochs(i).status_landmarks;
        end
    end
    
    t0 = t0 + epochs(i).time(end);
end

landmarkstatus = logical(landmarkstatus);