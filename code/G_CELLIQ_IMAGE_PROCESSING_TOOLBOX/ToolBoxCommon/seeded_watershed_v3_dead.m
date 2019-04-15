function LabMat = seeded_watershed_v3_dead( seeds, img)

bg_marker = img == 0;
seeds = imdilate( seeds, ones(3,3));
%seeds = imfill( seeds, 'holes');
Boundary = imdilate( seeds, ones(3,3)) - seeds;

Marker = bg_marker | seeds;
Marker(Boundary == 1) = 0;

com_img = imcomplement( img);
Overlaid_img = imimposemin( com_img, Marker);
LabMatPre = watershed( Overlaid_img);
        
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
Overlaid_img2 = imimposemin( com_img, sed2);
LabMatPre2 = watershed( Overlaid_img2);
bw2 = im2bw( LabMatPre2, .5);
LabMatPre2 = ~bg_marker .* bw2;

BlackWatershedLines = bwlabel(LabMatPre2);
SecondaryObjects1 = im2bw(BlackWatershedLines,.5);
LabelMatrixImage1 = bwlabel(SecondaryObjects1,4);
area_locations = find(LabelMatrixImage1);
area_labels = LabelMatrixImage1(area_locations);
map = [0 full(max(sparse(area_locations, area_labels, seeds(area_locations))))];
LabMatPre2 = map(LabelMatrixImage1 + 1);
LabMat = bwlabel( LabMatPre2);
