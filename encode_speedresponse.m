function rate = encode_speedresponse(vel, settings)

rate = settings.baseline + settings.dir*settings.slope*vel;