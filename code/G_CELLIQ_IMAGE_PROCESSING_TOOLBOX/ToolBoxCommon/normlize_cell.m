function Cell_Fea_Norm =normlize_cell(Cell_Fea,min_Fea,max_Fea)

numSamples = size(Cell_Fea,2);
numVariables = size(Cell_Fea,1);

eps_threshold=0.000001;

    
Cell_Fea_Norm=(Cell_Fea-repmat(min_Fea,[1 numSamples]))./repmat((max_Fea-min_Fea)+eps_threshold,[[1 numSamples]]);