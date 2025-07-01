function decode_avggain = create_decodeavggainstruct(initialweights)

decode_avggain.settings.synapticweights_ref = initialweights;
% decode_avggain.func = @(w, settings) mean(w)/mean(settings.synapticweights_ref);