function Feature_211 = RNAi_FeaExt_col_skipExist(InputPathImg, OutputPath)

%%% InputPathImg is the path of segmented images.
%%% OutputPath is the path to store the extracted features.
warning off;
path( 'ToolBoxCommon/RNAi_recognition/', path);
InputPathImg = InputPathImg;
OutputPath = OutputPath;


% pos=strfind(InputPathImg,'\');
% upperInputPathImg = InputPathImg(1:pos(length(pos)));
% handles.upperdirectory = upperdirectory;

Ind = dir( strcat( InputPathImg, '/', '*.tif')); %%%%%
warning off;

Ind1=dir(strcat( OutputPath, '/', 'Feature.mat'));

fea_file = strcat( OutputPath, '/', 'Feature.mat');
Feature = [];
%skip the exist Feature.mat file
if (size(Ind1,1)==0)
    
for i = 1:length( Ind)
    
    %%% load images
    img_file = strcat( InputPathImg, '/', Ind(i).name);
    img = rgb2gray(imread( img_file));
    %%% first extract each cells features
    if size( img,1)>=10
    fea = fea_extraction( img);
    Feature = [Feature, fea];
    end;
    %%%only extract cells with width>10, Mar 23,2007, Zheng
end
disp(fea_file);
save( fea_file, 'Feature');
Feature_211 = Feature;
end


