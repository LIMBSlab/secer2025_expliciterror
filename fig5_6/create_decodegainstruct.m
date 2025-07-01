function decode_gain = create_decodegainstruct(initialweights)

decode_gain.settings.synapticweights_ref = initialweights;
% decode_gain.func = @(w, settings) w./(settings.synapticweights_ref);