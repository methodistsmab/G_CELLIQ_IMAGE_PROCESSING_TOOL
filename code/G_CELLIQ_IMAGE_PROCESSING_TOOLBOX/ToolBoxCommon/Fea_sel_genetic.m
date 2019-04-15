function [selectedVars, errorRate] = Fea_sel_genetic()
load C:\fhl\Training_data\N\feature.mat;
Feature_N = Features;
load C:\fhl\Training_data\S\feature.mat;
Feature_S = Features;
load C:\fhl\Training_data\R\feature.mat;
Feature_R = Features;

DataX = [Feature_N(1:20,:);Feature_S(1:20,:);Feature_R(1:20,:)];
LabelY = [ones(1,20), ones(1,20) + 1, ones(1,20) + 2];
selectednum = 5;

[selectedVars, errorRate] = varselect_GA_open(DataX, LabelY, selectednum);

