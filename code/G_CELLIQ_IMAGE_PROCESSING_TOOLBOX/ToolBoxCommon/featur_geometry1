%%% Geometric Feature Extraction
%%% Created Jan. 24, 2006
%%% First version is based on Jun Yan's version, which extracts 12
%%% features; But partial of the features are intensity related, instead of
%%% geometric feature;
%%  Last updated Jan. 24, 2006
%%% Jun Wang (jwang@bwh.harvard.edu)


function FGEO=featur_geometry(I)

fig=figure;
%imshow(uint8(I));
[C,ch]=contour(I,[0,0],'r');
C=round(C);
C(:,C(1,:)==0)=[];
%C(:,C(1,:)<0.001)=[];
%C=C(:,2:size(C,2));
delete(fig);
%bw=roipoly(I,C(1,:),C(2,:));

% 
level = graythresh(I);
bw = im2bw(I,level);
bw = bwmorph(bw,'open');
[labelimage,numlabel]=bwlabel(bw);
if numlabel==1
    area_ind=1;
    insidebw=(labelimage==1);
else
    for i=1:numlabel

        subarea(i)=sum(sum(labelimage==i));
    end
    [max_area max_label]=max(subarea);
    area_ind=max_label;
    insidebw=(labelimage==area_ind);
end
bw=insidebw;


STATS = regionprops(uint8(bw),'all');

% pixel_index=STATS.PixelList;
% FGEO(1)=max(max(I(pixel_index(:,1),pixel_index(:,2)))); % max intensity
% FGEO(2)=min(min(I(pixel_index(:,1),pixel_index(:,2)))); % min intensity
%%%for debug
% FGEO(2)=100;
% for i=1:length(pixel_index)
%     if FGEO(2)>I(pixel_index(i,1),pixel_index(i,2))
%         FGEO(2)=I(pixel_index(i,1),pixel_index(i,2));
%     end
% end

FGEO(1) = double(max(max(I(bw==1))));                           % max intensity
FGEO(2) = double(min(min(I(bw==1))));                           % min intensity
FGEO(3) = double(mean(mean(I(bw==1))));                         % max intensity
FGEO(4) = double(std((I(bw==1))));                              % deviation of intensity
FGEO(5) = double(STATS.MajorAxisLength);                        % length of long axis
FGEO(6) = double(STATS.MinorAxisLength);                        % length of short axis
FGEO(7) = double(STATS.MajorAxisLength/STATS.MinorAxisLength);  % long axis / shor axis
FGEO(8) = double(STATS.Area);                                   % area
FGEO(9) = double(STATS.Perimeter);                              % perimeter
FGEO(10)= double(STATS.Perimeter^2/(4*pi*STATS.Area));          % compactness

STATS1  = regionprops(uint8(STATS.ConvexImage),'all');
FGEO(11)= STATS.Perimeter;                             % perimeter of convex image

% if STATS.Perimeter==0
%     ttt=1;
% end

FGEO(12)= STATS1.Perimeter/(STATS.Perimeter+0.0001);             % roughness
FGEO = reshape(FGEO,[length(FGEO) 1]);