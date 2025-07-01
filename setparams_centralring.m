function params = setparams_centralring(Nneurons, varargin)

global weightvisual_centralring;

recreateparams_flag = get_props_from_varargin(varargin, {'RecreateParams'}, {false});

if isfile('params_centralring.mat') && ~recreateparams_flag
    load('params_centralring.mat');
    
    return;
end

%%
params.neurons = create_neuronsstruct(Nneurons);

%%
params.connectivity.recurrentWeightProfile = create_recurrentweightstruct('StrengthShortRange',0.9, 'StrengthLongRange',-0.7, 'Range', 4, ...
                                                                          'Nneurons', Nneurons);

params.connectivity.inputLeftWeight = create_recurrentweightstruct('StrengthShortRange',8, 'StrengthLongRange',-0.0, 'Range', 10, ...
                                                                   'ShiftAmount', 12, 'ShiftDirection', +1, 'Type', 'Gaussian', ...
                                                                   'Nneurons', Nneurons);

params.connectivity.inputRightWeight = create_recurrentweightstruct('StrengthShortRange',8, 'StrengthLongRange',-0.0, 'Range', 10, ...
                                                                    'ShiftAmount', 12, 'ShiftDirection', -1, 'Type', 'Gaussian', ...
                                                                    'Nneurons', Nneurons);
                                                                
%%
if isempty(weightvisual_centralring)
    params.connectivity.inputVisualWeight = create_inputvisualweightstruct('Strength', -1, 'Nneurons', Nneurons);                                                  
else
    params.connectivity.inputVisualWeight = create_inputvisualweightstruct('Strength', weightvisual_centralring, 'Nneurons', Nneurons);        
end

%%
params.readactivity.settings = struct();
params.readsynapticweights.settings = struct();

%%
params = add_generalsettings_to_paramsstruct_centralring(params);

%%
params.decode_angle = create_decodeanglestruct();
params.decode_position = create_decodepositionstruct();
params.decode_bumpwidth = create_decodebumpwidthstruct();
params.decode_bumpamplitude = create_decodebumpamplitudestruct();
uref_encode = get_props_from_varargin(varargin, {'EncodeBasisActivity'}, {zeros(Nneurons,1)});
params.encode_angle = create_encodeanglestruct(uref_encode);

