function encode_angle = create_encodeanglestruct(uref)

encode_angle.settings.basis_activity = uref;
encode_angle.settings.gain = 1;
encode_angle.settings.basis_angle = decode_bumpcenter_wrappedangle(uref(:));
encode_angle.settings.basis_diffangle = 360/length(uref);
% encode_angle.func = @(angle, settings) circshift(settings.gain*settings.basis_activity, round((angle-settings.basis_angle)/settings.basis_diffangle));
