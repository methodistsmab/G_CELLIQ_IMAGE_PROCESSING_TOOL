%%% Cellular Phenotype Classification
%%% Created Feb. 24, 2006

%%  Last updated Feb. 24, 2006
%%% Jun Wang (jwang@bwh.harvard.edu)

function Phenotype=cell_classify(Cell_Fea)


load('ClassifierData');

Cell_Fea_Norm =normlize_cell(Cell_Fea,min_Fea,max_Fea);
Cell_Fea_Selected=Cell_Fea_Norm(selectedVars,:);
Phenotype=classify(Cell_Fea_Selected',DataX',DataY);

Cell_Fea_Norm2=Cell_Fea_Norm(1:157,:);
Cell_Fea_Selected_text=Cell_Fea_Norm2(selectedVars_text,:);
Phenotype_text=classify(Cell_Fea_Selected_text',DataX_text',DataY_text);

Phenotype((Phenotype==3)&(Phenotype_text==1))=1;


Cell_Fea_Norm3=Cell_Fea_Norm(1:157,:);
Cell_Fea_Norm3([86:96],:)=[];
Cell_Fea_Selected_3=Cell_Fea_Norm3(selectedVars3,:);
Phenotype_3=classify(Cell_Fea_Selected_3',DataX3',DataY3);

Phenotype((Phenotype==3)&(Phenotype_3==1))=1;