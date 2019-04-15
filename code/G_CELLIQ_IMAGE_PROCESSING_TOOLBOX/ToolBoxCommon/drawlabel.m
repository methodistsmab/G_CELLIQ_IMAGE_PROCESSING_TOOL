
%%% ad_img=imadjust(img,stretchlim(img),[]);

function drawlabel(labelImage)

hold on;
imshow(labelImage > 0,[]);
c = regionprops(labelImage,'centroid');
for kk = 1:length(c)
    Centroid = c(kk).Centroid;
    text(Centroid(1),Centroid(2),num2str(kk),'color','red');
end