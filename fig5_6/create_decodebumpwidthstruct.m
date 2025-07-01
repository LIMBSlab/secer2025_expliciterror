function decode_bumpwidth = create_decodebumpwidthstruct()

decode_bumpwidth.settings = struct();
% decode_bumpwidth.func = @(u, settings) circ_absdist_degrees(-180+findfirst(circshift_columns(u,round(size(u,1)/2)-out2(@() max(u,[],1))) >= max(u,[],1)/20,1,1,'last')*360/size(u,1), -180+findfirst(circshift_columns(u,round(size(u,1)/2)-out2(@() max(u,[],1))) >= max(u,[],1)/20,1,1,'first')*360/size(u,1));