function population = varselect_gacreate(numSelectedVariables,FitnessFcn,...
    options,numVariables)
%VARSELECT_GACREATE Population creation function for variable selection
%   
%   This function creates a population matrix containing options.PopulationSize 
%   individuals. Each individual consists of a set of randomly selected variable 
%   indices. The indices are a subset of size numSelectedVariables, drawn from 1 
%   to numVariables.

%   Note: This function's input arguments are required by the GADS toolbox.
%   see GADS documentation for further detail.

%   Copyright 2003-2005 The MathWorks, Inc.

% Repeat for each member of the population
for i = 1:options.PopulationSize
    % Initialise a flag to indicate that all selected variables are
    % distinct from each other
    allVariablesUnique = 0;
    % Loop continuously until all selected variables are unique
    while ~allVariablesUnique
        % Randomly select a subset of variable indices
        variables = floor(rand(numSelectedVariables,1)*numVariables)+1;
        % Check that all variables are different. If so, set the flag
        % to break out of the loop, otherwise loop again
        if size(variables) == size(unique(variables))
            allVariablesUnique = 1;
        end
    end
    % Add the current variable subset to the population
    population(i,:) = variables;
end
        
