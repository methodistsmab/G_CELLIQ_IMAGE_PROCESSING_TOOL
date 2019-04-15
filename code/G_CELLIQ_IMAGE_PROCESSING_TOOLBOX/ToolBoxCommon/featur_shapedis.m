function FSC=featur_shapedis(CellPatchI)

nbins=10;
fig=figure;
imshow(CellPatchI);
hold on;
[C,ch]=contour(CellPatchI,[0,0],'r');

delete(fig);
C=round(C);
C(:,C(1,:)==0)=[];
%C(:,C(1,:)<0.0001)=[];
%C=C(:,2:size(C,2));

%insidebw=roipoly(CellPatchI,C(1,:),C(2,:));

level = graythresh(CellPatchI);
bw = im2bw(CellPatchI,level);
bw = bwmorph(bw,'open');
[labelimage,numlabel]=bwlabel(bw);

subarea=zeros(numlabel,1);
if numlabel ==0
    FSC = zeros( 1,54);
    return;
elseif numlabel==1
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


cellperi = regionprops(uint8(insidebw),'perimeter');

centroid=mean(C');
centroid=reshape(centroid,[length(centroid) 1]);

cell_area=sum(sum(insidebw==area_ind));
cell_radius=norm(centroid);

% D=C-repmat(centroid,[1 size(C,2)]);
% com_scale=sqrt(D(1,:).^2+D(2,:).^2); 


angle_inv=1:36;

for i=1:length(angle_inv)
    theta=pi*angle_inv(i)/length(angle_inv);
    if i~=18
        k=tan(theta);
        left_C=C(:,(C(1,:)<=centroid(1)));
        right_C=C(:,(C(1,:)>centroid(1)));
        delta_left=(left_C(2,:)+k*centroid(1))-(k*left_C(1,:)+centroid(2));
        delta_right=(right_C(2,:)+k*centroid(1))-(k*right_C(1,:)+centroid(2));
        [a1,b1]=min(abs(delta_left));
        [a2,b2]=min(abs(delta_right));
        FSC(i)=norm(left_C(:,b1)-right_C(:,b2));
    else
        up_C=C(:,(C(2,:)<=centroid(2)));
        bottom_C=C(:,(C(2,:)>centroid(2)));
        delta_up=up_C(1,:)-centroid(1);
        delta_bottom=bottom_C(1,:)-centroid(1);   
        [a1,b1]=min(abs(delta_up));
        [a2,b2]=min(abs(delta_bottom));
        FSC(i)=norm(up_C(:,b1)-bottom_C(:,b2));        
    end
end
FSC=FSC/(cellperi.Perimeter+0.0001);
FSC=sort(FSC);

angle_scale=2*pi*[0:360]/360;

x=centroid(1)+cell_radius*cos(angle_scale);
y=centroid(2)+cell_radius*sin(angle_scale);
circle_p=[x' y']';


area_num=18;
area_intval=360/area_num;

for i=1:area_num
        
    x1=[centroid(1) x((i-1)*area_intval+1:i*area_intval+1)];
    y1=[centroid(2) y((i-1)*area_intval+1:i*area_intval+1)];
    BW = roipoly(CellPatchI,x1,y1);
    FSC_Area(i)=sum(sum(BW&insidebw));
end
FSC_Area=FSC_Area/sum(sum(insidebw));
FSC_Area=sort(FSC_Area);

FSC=[FSC FSC_Area];

% for i=1:length(C)
%     DisM(i,i)=0;
%     for j=i+1:length(C)
%         DisM(i,j)=norm(C(:,i)-C(:,j));
%         DisM(j,i)=DisM(i,j);
%     end
% end
% [PCcoeff, PCvec] = pca(DisM);
% FSC1=PCcoeff(1:10)'/sum(PCcoeff);
% FSC=[FSC FSC1];

