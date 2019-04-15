function RNAi_FeaExt_col( InputPathImg, OutputPath)

%%% InputPathSeg is the path of segmented images: Label Matrix
%%% InputPathImg is the path of intensity images.
%%% OutputPath is the path to store the phenotype results.
warning off;

Ind = dir( strcat( InputPathImg, '\', '*.tif'));
warning off;

fea_file = strcat( OutputPath, '\', 'Feature.mat');
Feature = [];
for i = 1:5%length( Ind)    
    %%% load images
    img_file = strcat( InputPathImg, '\', Ind(i).name);
    img = rgb2gray(imread( img_file));
    %%% first extract each cells features
    fea = fea_extraction( img);
    Feature = [Feature, fea];
end
save( fea_file, 'Feature');

