function ImgConvert( InputPath, OutputPath)

IndImg = dir(strcat( InputPath, '\', '*.tif'));

for i = 1:length(IndImg)
    img = mat2gray(imread(strcat(InputPath, '\', IndImg(i).name)));
    imwrite( img, strcat( OutputPath, '\', IndImg(i).name));
end
