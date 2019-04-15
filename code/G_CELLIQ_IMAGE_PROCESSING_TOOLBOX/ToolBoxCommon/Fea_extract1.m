function Features = Fea_extract1(InputPath)
%%% this function is to extract the features of the cells in the InputPath
%%% file. And the return result is a (N*D) feature matrix which N is the
%%% numbers of the samples and D is the dimension of each sample.

InputPath = strcat(InputPath,'\');
Features = [];
data_file = strcat(InputPath,'*.bmp');
Dir = dir(data_file);
Num = length(Dir);

for i = 1:Num
    Cell = imread(strcat(InputPath,Dir(i).name));
    features = Fea_19(Cell);
    Features = [Features;features];
end
feature_file = strcat(InputPath,'feature.mat');
save(feature_file,'Features');