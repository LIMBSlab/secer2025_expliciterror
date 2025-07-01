function [tsamples, bumpheight_centralring, bumpheight_leftring, bumpheight_rightring, ...
        bumpwidth_centralring, bumpwidth_leftring, bumpwidth_rightring, ...
        bumpmean_centralring, bumpmean_leftring, bumpmean_rightring, ...
        angwrapped_centralring, angwrapped_leftring, angwrapped_rightring, angwrapped_labframe, angwrapped_lmframe, ...
        pos_centralring, pos_leftring, pos_rightring, pos_labframe, pos_lmframe, ...
        vel_centralring, vel_leftring, vel_rightring, vel_labframe, vel_lmframe, ...
        avgpigain_leftring, avgpigain_rightring, hippgain_centralring, hippgain_leftring, hippgain_rightring, expgain, ...
        uthreshmat_leftring, uthreshmat_rightring, stdpigain_leftring, stdpigain_rightring] = process_ode45results(t, xmat, params, varargin)

Nneurons = length(params.network.centralring.neurons.pos);

pnetwork = params.network;
pexperiment = params.experiment;

dt = get_props_from_varargin(varargin, {'Resample'}, {0.1});
tsamples = t(1):dt:t(end);

%%
% umat_centralring = xmat(1:Nneurons,:);
% umat_leftring = xmat(Nneurons+1:2*Nneurons,:);
% wmat_leftring = xmat(2*Nneurons+1:3*Nneurons,:);
% umat_rightring = xmat(3*Nneurons+2:4*Nneurons+1,:);
% wmat_rightring = xmat(4*Nneurons+2:5*Nneurons+1,:);

umat_centralring = xmat(1:Nneurons,:);
umat_leftring = xmat(Nneurons+1:2*Nneurons,:);
wmat_leftring = xmat(2*Nneurons+1:3*Nneurons,:);
uthreshmat_leftring = xmat(3*Nneurons+1:3*Nneurons+2,:);
uthreshmat_leftring = interp1(t, uthreshmat_leftring.', tsamples).';
umat_rightring = xmat(3*Nneurons+3:4*Nneurons+2,:);
wmat_rightring = xmat(4*Nneurons+3:5*Nneurons+2,:);
uthreshmat_rightring = xmat(5*Nneurons+3:5*Nneurons+4,:);
uthreshmat_rightring = interp1(t, uthreshmat_rightring.', tsamples).';

%%
expgain = lookup_lmgain(t, pexperiment.epochs);
expgain = interp1(t, expgain, tsamples);

vel_labframe = lookup_ratspeed(t, pexperiment.epochs);
vel_labframe = interp1(t, vel_labframe, tsamples);
% vel_labframe = resample(vel_labframe, mean(diff(t)), dt);

pos_labframe = xmat(end-1,:);
pos_labframe = interp1(t, pos_labframe, tsamples);

angwrapped_labframe = mod(pos_labframe,360);

vel_lmframe = expgain.*vel_labframe;

pos_lmframe = xmat(end,:);
pos_lmframe = interp1(t, pos_lmframe, tsamples);

angwrapped_lmframe = mod(pos_lmframe,360);

%%
bumpheight_centralring = decode_bumpamplitude(umat_centralring);
bumpheight_centralring = interp1(t, bumpheight_centralring, tsamples);

bumpheight_leftring = decode_bumpamplitude(umat_leftring);
bumpheight_leftring = interp1(t, bumpheight_leftring, tsamples);

bumpheight_rightring = decode_bumpamplitude(umat_rightring);
bumpheight_rightring = interp1(t, bumpheight_rightring, tsamples);

%%
bumpwidth_centralring = decode_bumpwidth(umat_centralring);
bumpwidth_centralring = interp1(t, bumpwidth_centralring, tsamples);

bumpwidth_leftring = decode_bumpwidth(umat_leftring);
bumpwidth_leftring = interp1(t, bumpwidth_leftring, tsamples);

bumpwidth_rightring = decode_bumpwidth(umat_rightring);
bumpwidth_rightring = interp1(t, bumpwidth_rightring, tsamples);

%%
bumpmean_centralring = decode_bumpmean(umat_centralring);
bumpmean_centralring = interp1(t, bumpmean_centralring, tsamples);

bumpmean_leftring = decode_bumpmean(umat_leftring);
bumpmean_leftring = interp1(t, bumpmean_leftring, tsamples);

bumpmean_rightring = decode_bumpmean(umat_rightring);
bumpmean_rightring = interp1(t, bumpmean_rightring, tsamples);

%%
angwrapped_centralring = decode_bumpcenter_wrappedangle(umat_centralring);
pos_centralring = rad2deg(unwrap(deg2rad(angwrapped_centralring)));
angwrapped_centralring = interp1(t, angwrapped_centralring, tsamples);
pos_centralring = interp1(t, pos_centralring, tsamples);

angwrapped_leftring = decode_bumpcenter_wrappedangle(umat_leftring);
pos_leftring = rad2deg(unwrap(deg2rad(angwrapped_leftring)));
angwrapped_leftring = interp1(t, angwrapped_leftring, tsamples);
pos_leftring = interp1(t, pos_leftring, tsamples);

angwrapped_rightring = decode_bumpcenter_wrappedangle(umat_rightring);
pos_rightring = rad2deg(unwrap(deg2rad(angwrapped_rightring)));
angwrapped_rightring = interp1(t, angwrapped_rightring, tsamples);
pos_rightring = interp1(t, pos_rightring, tsamples);


%%
dt = 0.01;
t_uniform = t(1):dt:t(end);
rawvel_centralring_uniform = numderiv_centraldiff(interp1(tsamples, pos_centralring, t_uniform,'linear','extrap'), dt, 1);
rawvel_leftring_uniform = numderiv_centraldiff(interp1(tsamples, pos_leftring, t_uniform,'linear','extrap'), dt, 1);
rawvel_rightring_uniform = numderiv_centraldiff(interp1(tsamples, pos_rightring, t_uniform,'linear','extrap'), dt, 1);

% vel_centralring_uniform = gaussfilt(t_uniform, rawvel_centralring_uniform, 0.05);
% vel_leftring_uniform = gaussfilt(t_uniform, rawvel_leftring_uniform, 0.05);
% vel_rightring_uniform = gaussfilt(t_uniform, rawvel_rightring_uniform, 0.05);

vel_centralring_uniform = movmean(rawvel_centralring_uniform, 25);
vel_leftring_uniform = movmean(rawvel_leftring_uniform, 25);
vel_rightring_uniform = movmean(rawvel_rightring_uniform, 25);

vel_centralring = interp1(t_uniform, vel_centralring_uniform, tsamples);
vel_leftring = interp1(t_uniform, vel_leftring_uniform, tsamples);
vel_rightring = interp1(t_uniform, vel_rightring_uniform, tsamples);

%%
avgpigain_leftring = decode_pigainavg(wmat_leftring, pnetwork.leftring.decode_avggain.settings);
avgpigain_leftring = interp1(t, avgpigain_leftring, tsamples);

avgpigain_rightring = decode_pigainavg(wmat_rightring, pnetwork.rightring.decode_avggain.settings);
avgpigain_rightring = interp1(t, avgpigain_rightring, tsamples);

stdpigain_leftring = decode_pigainstd(wmat_leftring, pnetwork.leftring.decode_avggain.settings);
stdpigain_leftring = interp1(t, stdpigain_leftring, tsamples);

stdpigain_rightring = decode_pigainstd(wmat_rightring, pnetwork.rightring.decode_avggain.settings);
stdpigain_rightring = interp1(t, stdpigain_rightring, tsamples);

winlen = 2*360;
hippgain_x = [];
hippgain_val_centralring = [];
hippgain_val_leftring = [];
hippgain_val_rightring = [];

for poscenter_win = pos_labframe(1):30:pos_labframe(end)
    if poscenter_win > pos_labframe(1) + winlen/2 && poscenter_win < pos_labframe(end) - winlen/2
        hippgain_x = [hippgain_x, poscenter_win];
        
        poslb_win = poscenter_win - winlen/2;
        posub_win = poscenter_win + winlen/2;
        
        idx_win_begin = find(pos_labframe >= poslb_win, 1, 'first');
        idx_win_end = find(pos_labframe <= posub_win, 1, 'last');
        
        vel_centralring_win = vel_centralring(idx_win_begin:idx_win_end);
        vel_leftring_win = vel_leftring(idx_win_begin:idx_win_end);
        vel_rightring_win = vel_rightring(idx_win_begin:idx_win_end);
 
        vel_labframe_win = vel_labframe(idx_win_begin:idx_win_end);
        
        hippgain_centralring = pinv(vel_labframe_win(:))*vel_centralring_win(:);
        hippgain_leftring = pinv(vel_labframe_win(:))*vel_leftring_win(:);
        hippgain_rightring = pinv(vel_labframe_win(:))*vel_rightring_win(:);
        
        hippgain_val_centralring = [hippgain_val_centralring, hippgain_centralring];
        hippgain_val_leftring = [hippgain_val_leftring, hippgain_leftring];
        hippgain_val_rightring = [hippgain_val_rightring, hippgain_rightring];
    end
end

if ~isempty(hippgain_x)
    hippgain_centralring = NaN(size(pos_labframe));
    hippgain_leftring = NaN(size(pos_labframe));
    hippgain_rightring = NaN(size(pos_labframe));
    
    is_in_x = pos_labframe >= hippgain_x(1) & pos_labframe <= hippgain_x(end);
    
    hippgain_centralring(is_in_x) = interp1(hippgain_x, hippgain_val_centralring, pos_labframe(is_in_x), 'linear');
    hippgain_leftring(is_in_x) = interp1(hippgain_x, hippgain_val_leftring, pos_labframe(is_in_x), 'linear', 'extrap');
    hippgain_rightring(is_in_x) = interp1(hippgain_x, hippgain_val_rightring, pos_labframe(is_in_x), 'linear');
else
    hippgain_centralring = [];
    hippgain_leftring = [];
    hippgain_rightring = [];
end