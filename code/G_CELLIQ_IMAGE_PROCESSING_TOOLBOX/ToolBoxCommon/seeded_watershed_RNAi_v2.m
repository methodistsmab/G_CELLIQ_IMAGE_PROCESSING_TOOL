function LabMat = seeded_watershed_RNAi_v2( seeds, img)

bg_marker = img == 0;
% seeds = imdilate( seeds, ones(3,3));
%seeds = imfill( seeds, 'holes');
Boundary = imdilate( seeds, ones(3,3)) - seeds;

Marker = bg_marker | seeds;
Marker(Boundary == 1) = 0;

[fx, fy] = gradient( double(img));
graImg = mat2gray( abs(fx) + abs(fy));

com_img = imcomplement(img);
Overlaid_img = imimposemin( graImg, Marker);
LabMatPre = watershed_old( Overlaid_img);
        
LabMatPre2 = im2bw(LabMatPre,.5);
BlackWatershedLines = bwlabel(LabMatPre2);
SecondaryObjects1 = im2bw(BlackWatershedLines,.5);
LabelMatrixImage1 = bwlabel(SecondaryObjects1,4);
area_locations = find(LabelMatrixImage1);
area_labels = LabelMatrixImage1(area_locations);
map = [0 full(max(sparse(area_locations, area_labels, seeds(area_locations))))];
LabMatPre2 = map(LabelMatrixImage1 + 1);
LabMat = bwlabel( LabMatPre2);

sed2 = im2bw( LabMat, .5);
Boundary = imdilate( sed2, ones(3,3)) - sed2;

Marker = sed2 | bg_marker;
Marker(Boundary == 1) = 0;

Overlaid_img2 = imimposemin( com_img, Marker);
LabMatPre3 = watershed_old( Overlaid_img2);

LabMatPre2= im2bw(LabMatPre3,.5);
BlackWatershedLines = bwlabel(LabMatPre2);
SecondaryObjects1 = im2bw(BlackWatershedLines,.5);
LabelMatrixImage1 = bwlabel(SecondaryObjects1,4);
area_locations = find(LabelMatrixImage1);
area_labels = LabelMatrixImage1(area_locations);
map = [0 full(max(sparse(area_locations, area_labels, seeds(area_locations))))];
LabMatPre2 = map(LabelMatrixImage1 + 1);
LabMat = bwlabel( LabMatPre2);
maxImg = ordfilt2( LabMat, 9, ones(3,3));
LabMat = ordfilt2( maxImg, 1, ones(3,3));
bou = maxImg - LabMat;
LabMat(bou>0) = 0;