function [selectedVars, errorRate] = varselect_GA_open(DataX, LabelY, selectednum)
%VARSELECT_DEMO Demonstration of variable selection using genetic
%algorithms.
%   
%   This function demonstrates variable selection using genetic algorithms,
%   using a public dataset of microarray data. The data is read in, and
%   genes which called absent are removed from the dataset. Options are set
%   for the Genetic Algorithm, and the Genetic Algorithm is run.
%   
%   Copyright 2003-2005 The MathWorks, Inc.
%   Updated by Jun Wang (jwang@bwh.harvard.edu)
%   Feb. 5, 2006
%
%   Input:  DataX is a N*D matrix, N is the number of samples, and D is the
%           number of features;
%           LabelY is the class label of the data;
%   Output: selectedVars is index of selected features;
%preforcla;


LabelY=reshape(LabelY,[length(LabelY) 1]);
numSamples = size(DataX,1);
numVariables = size(DataX,2); 
%whos


%% Create a Fitness Function for the Genetic Algorithm
% type varselect_gafit_lda.m

%% Create an Initial Population Function
% type varselect_gacreate.m

%% Create a custom Crossover Function
% type varselect_crossoverscattered.m

%% Create a custom Mutation Function
% type varselect_mutationuniform.m

%% Set Genetic Algorithm Options
% set options for out genetic algorithm in a struct options
options = gaoptimset('CreationFcn',{@varselect_gacreate,numVariables},...
            'CrossoverFcn',@varselect_crossoverscattered,...
            'MutationFcn',@varselect_mutationuniform,...
            'PopulationSize',100,...
            'PopInitRange',[1;numVariables],...
            'FitnessLimit', 0,...
            'StallGenLimit',100,...
            'StallTimeLimit',3600,...
            'TimeLimit',93600,...
            'Generations',20,...
            'CrossoverFraction',0.5,...
            'Display','iter');
            %'Display','iter',...
            %'PlotFcn',@gaplotbestf);

        
%% Carry out GA
numSelectedVars = selectednum;
FitnessFcn = {@varselect_gafit,DataX,LabelY,numSamples};
fprintf('Running genetic algorithm for feature selection.\n');
fprintf('Size of Population : %d.\n', options.PopulationSize);
fprintf('Number of Generations : %d.\n', options.Generations);
[selectedVars, errorRate] = ga(FitnessFcn, ...
        numSelectedVars,options);
