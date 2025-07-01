function params = setparams_leftring(Nneurons, varargin)

global weightvisual_rotring shiftvisual_rotring;

recreateparams_flag = get_props_from_varargin(varargin, {'RecreateParams'}, {false});

if isfile('params_leftring.mat') && ~recreateparams_flag
    load('params_leftring.mat');
    
    return;
end
    
%%
params.neurons = create_neuronsstruct(Nneurons);

%%
params.connectivity.recurrentWeightProfile = create_recurrentweightstruct('StrengthLongRange',0, 'StrengthShortRange',0, 'Nneurons', Nneurons);

params.connectivity.inputCentralWeight = create_recurrentweightstruct('StrengthShortRange',8, 'StrengthLongRange',0, ...
                                                                      'Range', 10, 'Type', 'Gaussian', 'Nneurons', Nneurons);
                                                                                                                                                                                                               
%%
params.readactivity.settings = struct();
params.readsynapticweights.settings = struct();

%%
[status_plasticity, gamma_plasticity, u0_speed, u0_ring] = get_props_from_varargin(varargin, {'StatusPlasticity','DegreeOfPlasticity','PresynapticBaselineActivity','PostsynapticBaselineActivity'}, ...
                                                                                             {false,2e-2,0,0});

params = add_generalsettings_to_paramsstruct_rotring(params, 'StatusPlasticity', status_plasticity, ...
                                                              'DegreeOfPlasticity', gamma_plasticity, ...
                                                              'BaselineActivityLevelRing', u0_ring, ...
                                                              'BaselineActivityLevelSpeed', u0_speed);

%%
params.decode_angle = create_decodeanglestruct();
params.decode_position = create_decodepositionstruct();
params.decode_bumpwidth = create_decodebumpwidthstruct();
params.decode_bumpamplitude = create_decodebumpamplitudestruct();
params.decode_gain = create_decodegainstruct(params.initialstate(Nneurons+1:2*Nneurons));
params.decode_avggain = create_decodeavggainstruct(params.initialstate(Nneurons+1:2*Nneurons));

uref_encode = get_props_from_varargin(varargin, {'EncodeBasisActivity'}, {zeros(Nneurons,1)});
params.encode_angle = create_encodeanglestruct(uref_encode);

%%
inputspeedweights.settings = struct();
params.connectivity.inputSpeedWeight = inputspeedweights;

if isempty(weightvisual_rotring)
    weightvisual = -0.8;                                                             
else
    weightvisual = weightvisual_rotring;
end

if isempty(shiftvisual_rotring)
    shiftvisual = 50;                                                             
else
    shiftvisual = shiftvisual_rotring;
end

params.connectivity.inputVisualWeight = create_inputvisualweightstruct('ShiftDirection', +1, 'ShiftAmount', shiftvisual, ...
                                                                       'Strength', weightvisual, 'Nneurons', Nneurons);

debug;
