function LabMat = BW_watershed( bw_img, SE)

bg_marker = bw_img == 0;
disImg = bwdist( ~bw_img);
Noise = rand(size(disImg)).*0.0001;
disImg = disImg + Noise;

Neighbor = getnhood( SE);
Num = sum( Neighbor(:));
SeedImg = disImg >= ordfilt2( disImg, Num, Neighbor);
SeedImg = SeedImg .* bw_img;
% seeds = imdilate( seeds, ones(3,3));
%seeds = imfill( seeds, 'holes');
Marker = bg_marker | SeedImg;

com_img = imcomplement( disImg);
Overlaid_img = imimposemin( com_img, Marker);
LabMatPre = watershed( Overlaid_img);
        
LabMatPre2 = im2bw(LabMatPre,.5);
BlackWatershedLines = bwlabel(LabMatPre2);
SecondaryObjects1 = im2bw(BlackWatershedLines,.5);
LabelMatrixImage1 = bwlabel(SecondaryObjects1,4);
area_locations = find(LabelMatrixImage1);
area_labels = LabelMatrixImage1(area_locations);
map = [0 full(max(sparse(area_locations, area_labels, SeedImg(area_locations))))];
LabMatPre2 = map(LabelMatrixImage1 + 1);
LabMat = bwlabel( LabMatPre2);

