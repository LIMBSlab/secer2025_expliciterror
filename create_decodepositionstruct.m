function decode_position = create_decodepositionstruct()

% decode_angle = create_decodeanglestruct();

decode_position.settings = struct();
% decode_position.func = @(u, settings) decode_angle.func(u(:,1)) + [0, cumsum(circ_dist_degrees(decode_angle.func(u(:,2:end)), decode_angle.func(u(:,1:end-1))))];