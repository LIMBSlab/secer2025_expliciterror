function G = decode_pigainavg(w, settings)

G = mean(decode_pigain(w, settings),1);

% xneurons = linspace(-pi, +pi, size(w, 2)+1);
% 
% wnorm = decode_pigain(w, settings);
% wnorm = [wnorm; wnorm(1,:)];

% G = circ_mean_degrees(xneurons, wnorm);