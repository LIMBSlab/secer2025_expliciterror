function neurons = create_neuronsstruct(Nneurons)

neurons.pos = linspace(-180, +180, Nneurons+1).';
neurons.pos = neurons.pos(1:Nneurons);
neurons.count = Nneurons;