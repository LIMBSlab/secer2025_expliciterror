function decode_angle = create_decodeanglestruct()

decode_angle.settings = struct();

% decode_angle.func = @(u, settings) mod(-180 + (findfirst(u == max(u,[],1),1)-1)*360/size(u,1),360);