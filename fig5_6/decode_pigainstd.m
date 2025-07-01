function Gstd = decode_pigainstd(w, settings)

Gstd = std(decode_pigain(w, settings),0,1);

% xneurons = linspace(-pi, +pi, size(w, 2)+1);
% 
% wnorm = decode_pigain(w, settings);
% wnorm = [wnorm; wnorm(1,:)];
% 
% Gstd = circ_std_degrees(xneurons, wnorm);