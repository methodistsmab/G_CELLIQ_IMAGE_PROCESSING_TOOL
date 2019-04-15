%%% Geometric Feature Extraction
%%% Created Jan. 24, 2006

%%  Last updated Jan. 24, 2006
%%% Jun Wang (jwang@bwh.harvard.edu)


function Cell_Fea=fea_extraction(I)


[FG, FECDF, FGEO, FMO, FTEX, FSC]=Cell_Feature_Extraction_v2(I);

Cell_Fea=[reshape(FG,1,length(FG)) reshape(FECDF,1,length(FECDF)) reshape(FGEO,1,length(FGEO)) reshape(FMO,1,length(FMO))...
    reshape(FTEX,1,length(FTEX)) reshape(FSC,1,length(FSC))];
%% remove two useless features;
Cell_Fea([87,98])=[];
Cell_Fea=reshape(Cell_Fea,length(Cell_Fea),1);

