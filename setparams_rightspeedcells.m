function params = setparams_rightspeedcells(Nneurons, varargin)

recreateparams_flag = get_props_from_varargin(varargin, {'RecreateParams'}, {false});

if isfile('params_rightspeedcells.mat') && ~recreateparams_flag
    load('params_rightspeedcells.mat');
    
    return;
end

%%
params.neurons = create_neuronsstruct(Nneurons);

%%
params.encode = create_speedcellencodestruct('Direction',-1);

params.decode = create_speedcelldecodestruct('Direction',-1);

