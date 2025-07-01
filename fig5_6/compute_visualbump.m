function [u_visualbump, xneurons_array] = compute_visualbump(ang, amp, width, Nneurons)

    xneurons_array = linspace(-pi,+pi,Nneurons+1);

    gaussref_rotrings = normpdf(circ_dist(xneurons_array, atan2(sind(ang),cosd(ang))), 0, width/6);
    idx_belowzero = Nneurons/2 + 1- round(width/2/(2*pi/(Nneurons+1)));
    % gaussref_rotrings = max(gaussref_rotrings - gaussref_rotrings(idx_belowzero),0);
    gaussref_rotrings = gaussref_rotrings(1:Nneurons)/max(gaussref_rotrings);
    xneurons_array = rad2deg(xneurons_array(1:Nneurons));

    % shiftvisual_rotring = round(360*(findfirst(gaussref_rotrings.' > 0.95) - findfirst(gaussref_rotrings.' > 0.05))/(2*(Nneurons + 1)));

    u_visualbump = amp*gaussref_rotrings;