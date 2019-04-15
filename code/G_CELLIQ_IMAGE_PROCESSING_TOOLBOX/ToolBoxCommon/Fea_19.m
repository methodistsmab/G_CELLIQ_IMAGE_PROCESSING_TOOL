function Features = Fea_19(Cell)
%%% this function extracts the 19 features of one cell image.
%%% the reference is 'Algorithms for cytoplasm segmentation of fluorescence
%%% labelled cells', Analytical Cellular Pathology 24 (2002) 101 - 111 IOS
%%% Press. 
%%% Fuhai Li (fhli@bwh.harvard.edu), Apr. 5, 2006.

%level = graythresh(I);
Cell_L = Cell;
Features = [];
bw = im2bw(Cell_L,1/300);
bw = imfill(bw,'holes');
PROP = regionprops(uint8(bw),'Area','Perimeter','ConvexArea','ConvexImage','BoundingBox');
Features(1) = PROP.Area;
Features(2) = PROP.Perimeter;

CompactnessIndex = (PROP.Perimeter)^2/(4 * pi * PROP.Area);
Features(3) = CompactnessIndex;
Features(4) = PROP.ConvexArea;

ConvexPerimeter = regionprops(uint8(PROP.ConvexImage),'Perimeter');
Features(5) = ConvexPerimeter.Perimeter;%% adding codes

Features(6) = PROP.ConvexArea/PROP.Area;
Features(7) = ConvexPerimeter.Perimeter/PROP.Perimeter;

temp_box = PROP.BoundingBox;
Length = max(temp_box(3),temp_box(4));
Width = min(temp_box(3),temp_box(4));
Features(8) = Length;
Features(9) = Width;
Features(10) = Length/Width;

Cell_temp =  mat2gray(Cell);
LongitudianlMoment = mb_imgmoments(Cell_temp,0,2); 
TansversalMoment = mb_imgmoments(Cell_temp,2,0);
Features(11) = LongitudianlMoment;
Features(12) = TansversalMoment;

IntegratedIntensity = sum(Cell(:));
Features(13) = IntegratedIntensity;

Num = sum(bw(:));
MeanIntensity = IntegratedIntensity/Num;
Features(14) = MeanIntensity;

DeviationIntensityMatrix = Cell - MeanIntensity;
Deviation = DeviationIntensityMatrix .^ 2;
Deviation = double(Deviation) .* double(bw);
StandardDeviation = sqrt(sum(Deviation(:))/Num);
Features(15) = StandardDeviation;

Cell1 = Cell;
Cell1(~bw) = 255;
IntensityRange = max(Cell(:)) - min(Cell1(:)); 
Features(16) = IntensityRange;

D = bwdist(~bw);
border = false(size(bw));
border = (D == 1);
borderIntensity = uint8(border) .* Cell;
MaxBorder = max(borderIntensity(:));
borderIntensity(~border) = 255;
MinBorder = min(borderIntensity(:));
Features(17) = MaxBorder - MinBorder;

Features(18) = Features(17)/Features(16);

Center_intensity_X = mb_imgmoments(Cell,1,0)/mb_imgmoments(Cell,0,0); 
Center_intensity_Y = mb_imgmoments(Cell,0,1)/mb_imgmoments(Cell,0,0); 
Center_binary_X = mb_imgmoments(bw,1,0)/mb_imgmoments(bw,0,0); 
Center_binary_Y = mb_imgmoments(bw,0,1)/mb_imgmoments(bw,0,0); 
MassDisplacement = round(sqrt(abs(Center_intensity_X - Center_binary_X)^2 + abs(Center_intensity_Y - Center_binary_Y)^2));
Features(19) = MassDisplacement;