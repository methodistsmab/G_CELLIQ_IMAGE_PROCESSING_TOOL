function ConvertRGBImg( InputPath, OutputPath)

%%% this function is used to convert the three channels of images:
%%% tubulin/red channel, DNA/blue channel and F-actin/green channel into
%%% RGB images.
%%% fuhai li( fhl@bwh.harvard.edu)

Index = dir( strcat( InputPath, '\', '*.tif'));

N = floor(length(Index)/3)-1;

for i = 0:1:N
    img_n = mat2gray(imread(strcat(InputPath, '\', Index(i*3+1).name)));
    img_a = mat2gray(imread(strcat(InputPath, '\', Index(i*3+2).name)));    
    img_t = mat2gray(imread(strcat(InputPath, '\', Index(i*3+3).name)));

    imgrgb(:,:,1) = img_t;
    imgrgb(:,:,2) = img_a;
    imgrgb(:,:,3) = img_n;
    
    imwrite( imgrgb, strcat( OutputPath, '\', strrep(Index(i*3+1).name, '.tif', '_rgb.tif')));
end
    
    


