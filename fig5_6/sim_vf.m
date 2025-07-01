function dx = sim_vf(t, x, params)

if t > 24
    debug;
end

params_exp = params.experiment;
params_network = params.network;

xnetwork = x(1:end-2);
xanimal = x(end-1);

angvel_labframe = lookup_ratspeed(t, params_exp.epochs);

if isfield(params_exp, 'status_landmarks')
    status_landmarks = params_exp.status_landmarks;
else
    status_landmarks = lookup_landmarkstatus(t, params_exp.epochs);
end


ucentralring = get_activitystates_centralring(map_x_to_centralringstates(xnetwork, params_network.centralring));
uleftring = get_activitystates_leftring(map_x_to_leftringstates(xnetwork, params_network.leftring));
urightring = get_activitystates_rightring(map_x_to_rightringstates(xnetwork, params_network.leftring));
ang_lmbias = 0;

if status_landmarks
    if strcmp(params_exp.type, 'ErrorCode')
        ang_lmbias = lookup_lmbias(t, params_exp.epochs);

        if ang_lmbias > 10
            debug;
        elseif ang_lmbias < -10
            debug;
        else
            debug;
        end


        angvel_lmframe = angvel_labframe;

        xlandmarks = decode_bumpcenter_wrappedangle(ucentralring) + ang_lmbias;  
    elseif strcmp(params_exp.type, 'CueRotation')
        ang_lmbias = lookup_lmbias(t, params_exp.epochs);

        angvel_lmframe = angvel_labframe;

        xlandmarks = xanimal + ang_lmbias;  
    else
        lmgain = lookup_lmgain(t, params_exp.epochs);
        angvel_lmframe = angvel_labframe.*lmgain;
        % angpos_lmframe = lookup_ratposition2lm(t, params_exp.epochs);

        xlandmarks = x(end);
    end    

    pvisualring = params_network.visualring;
    
else
    angvel_lmframe = angvel_labframe;

    ucentralring = map_x_to_centralringstates(xnetwork, params_network.centralring);

    pvisualring = params_network.visualring;
    xlandmarks = decode_bumpcenter_wrappedangle(ucentralring);  

end

uvisualring = compute_visualbump(xlandmarks, pvisualring.bumpamp, pvisualring.bumpwidth, length(ucentralring));
angcenter = decode_bumpcenter_wrappedangle(ucentralring);

if abs(angcenter - 120) < 0.1
    debug;
elseif abs(angcenter - 180) < 0.1
    debug;
elseif abs(angcenter - 250) < 0.1
    debug;
end

if t > 10
    debug;
end


%%
pleftspeed = params_network.leftspeedcells;
uleftspeed = encode_speedresponse(angvel_labframe, pleftspeed.encode.settings);

prightspeed = params_network.rightspeedcells;
urightspeed = encode_speedresponse(angvel_labframe, prightspeed.encode.settings);

%%
dxnetwork = fullnetwork_vf(xnetwork, uleftspeed, urightspeed, uvisualring, status_landmarks, abs(angvel_labframe), params_network);

dx = [dxnetwork; angvel_labframe; angvel_lmframe];