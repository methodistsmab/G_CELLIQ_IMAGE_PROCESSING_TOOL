
%%% ad_img=imadjust(img,stretchlim(img),[]);

function drawImglabel(Img, labelImage)

hold on;
imshow(Img,[]);
c = regionprops(labelImage,'centroid');
for kk = 1:length(c)
    Centroid = c(kk).Centroid;
    text(Centroid(1),Centroid(2),num2str(kk),'color','green');
end