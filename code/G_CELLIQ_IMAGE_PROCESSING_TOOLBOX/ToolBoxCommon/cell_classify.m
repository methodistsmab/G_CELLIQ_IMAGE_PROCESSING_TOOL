%%% Cellular Phenotype Classification
%%% Created Feb. 24, 2006

%%  Last updated Feb. 24, 2006
%%% Jun Wang (jwang@bwh.harvard.edu)

function Phenotype=cell_classify(Cell_Fea)


load('ClassifierData');

Cell_Fea_Norm =normlize_cell(Cell_Fea,min_Fea,max_Fea);
Cell_Fea_Selected1=Cell_Fea_Norm(selectedVars1,:);
Phenotype=classify(Cell_Fea_Selected1',DataX1',DataY1);

Cell_Fea_Norm2=Cell_Fea_Norm(1:157,:);
Cell_Fea_Selected2=Cell_Fea_Norm2(selectedVars2,:);
Phenotype2=classify(Cell_Fea_Selected2',DataX2',DataY2);
Phenotype((Phenotype==3)&(Phenotype2==1))=1;


Cell_Fea_Norm3=Cell_Fea_Norm(1:157,:);
Cell_Fea_Norm3([86:96],:)=[];
Cell_Fea_Selected3=Cell_Fea_Norm3(selectedVars3,:);
Phenotype3=classify(Cell_Fea_Selected3',DataX3',DataY3);
Phenotype((Phenotype==3)&(Phenotype3==1))=1;

Cell_Fea_Norm4=Cell_Fea_Norm(1:157,:);
Cell_Fea_Norm4([86:98],:)=[];
Cell_Fea_Selected4=Cell_Fea_Norm4(selectedVars4,:);
Phenotype4=classify(Cell_Fea_Selected4',DataX4',DataY4);
Phenotype((Phenotype==3)&(Phenotype4==1))=1;