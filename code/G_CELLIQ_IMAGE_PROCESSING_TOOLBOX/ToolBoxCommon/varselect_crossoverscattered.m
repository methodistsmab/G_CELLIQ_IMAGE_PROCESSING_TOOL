function xoverKids  = varselect_crossoverscattered(parents,options,GenomeLength,FitnessFcn,unused,thisPopulation)
%VARSELECT_CROSSOVERSCATTERED Crossover function for variable selection.
%   
%   This function is exactly the same as the built in crossoverscattered
%   function, with a small tweak to ensure that children generated by
%   crossover contain a non-redundant set of variable indices.
 
%   Copyright 2003-2004 The MathWorks, Inc.


% How many children to produce?
nKids = length(parents)/2;

% Allocate space for the kids
xoverKids = zeros(nKids,GenomeLength);

% To move through the parents twice as fast as thekids are
% being produced, a separate index for the parents is needed
index = 1;

% for each kid...
for i=1:nKids
    % get parents
    r1 = parents(index);
    index = index + 1;
    r2 = parents(index);
    index = index + 1;

    % Randomly select half of the genes from each parent
    % This loop may seem like brute force, but it is twice as fast as the
    % vectorized version, because it does no allocation.
    while 1
        for j = 1:GenomeLength
            if(rand > 0.5)
                xoverKids(i,j) = thisPopulation(r1,j);
            else
                xoverKids(i,j) = thisPopulation(r2,j);       
            end
        end
        
        % Check that all indices are different
        % If so, break out of the loop,
        % otherwise loop again.
        if size(xoverKids(i,:))==size(unique(xoverKids(i,:)))
            break
        end
    end
end

