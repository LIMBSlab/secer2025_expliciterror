function params = setparams_leftspeedcells(Nneurons, varargin)

recreateparams_flag = get_props_from_varargin(varargin, {'RecreateParams'}, {false});

if isfile('params_leftspeedcells.mat') && ~recreateparams_flag
    load('params_leftspeedcells.mat');
    
    return;
end

%%
params.neurons = create_neuronsstruct(Nneurons);

%%
params.encode = create_speedcellencodestruct('Direction',+1);

params.decode = create_speedcelldecodestruct('Direction',+1);
