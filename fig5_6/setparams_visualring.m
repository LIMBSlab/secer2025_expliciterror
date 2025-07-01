function params = setparams_visualring(Nneurons, varargin)

recreateparams_flag = get_props_from_varargin(varargin, {'RecreateParams'}, {false});

if isfile('params_visualring.mat') && ~recreateparams_flag
    load('params_visualring.mat');
    
    return;
end

%%
params.neurons = create_neuronsstruct(Nneurons);

%%
params.decode_angle = create_decodeanglestruct();

uref_encode = get_props_from_varargin(varargin, {'EncodeBasisActivity'}, {zeros(Nneurons,1)});
params.encode_angle = create_encodeanglestruct(uref_encode);

uref_encode = get_props_from_varargin(varargin, {'EncodeBasisActivity4CentralRing'}, {zeros(Nneurons,1)});
params.encode_angle_centralring = create_encodeanglestruct(uref_encode);

uref_encode = get_props_from_varargin(varargin, {'EncodeBasisActivity4RotationRing'}, {zeros(Nneurons,1)});
params.encode_angle_rotationring = create_encodeanglestruct(uref_encode);