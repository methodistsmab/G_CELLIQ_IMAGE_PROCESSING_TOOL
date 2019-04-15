function [value]=WFSC(dataset,y,class1,class2)
%dataset row vector
%y label vector
%w=0.2;
%for example:WFSC(MG(:,genei)',y',1,-1)
FeaScore = zeros(211,5);
for genei = 1: 211
    FeaScore(genei,1) = WFSC( Phenotype_Sample(:,genei)',Phenotype_Label_P1',1,-1);
    FeaScore(genei,2) = WFSC( Phenotype_Sample(:,genei)',Phenotype_Label_P2',1,-1);
    FeaScore(genei,3) = WFSC( Phenotype_Sample(:,genei)',Phenotype_Label_P3',1,-1);
    FeaScore(genei,4) = WFSC( Phenotype_Sample(:,genei)',Phenotype_Label_P4',1,-1);
    FeaScore(genei,5) = WFSC( Phenotype_Sample(:,genei)',Phenotype_Label_P5',1,-1);
end
[Sort_FeaScore, Sort_Index] = sort(FeaScore);

TheSelecVars = zeros();
[selectedVars, errorRate] = varselect_GA_open(Phenotype_Sample(:,Sort_Index(38:105,1))', Phenotype_Label_P1', 10);
