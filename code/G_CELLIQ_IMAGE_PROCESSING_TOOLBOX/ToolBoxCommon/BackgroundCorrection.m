function BackgroundCorrection( InputPath, OutputPath)

Index = dir( strcat( InputPath, '\', '*.tif'));
path( 'C:\FHL\Projects\ToolBoxCommon\BgCorrection\', path); 
path( 'C:\FHL\Projects\ToolBoxCommon\Propagate\', path);
path( 'C:\FHL\Projects\ToolBoxCommon\Self\', path);
path( 'C:\FHL\Projects\ToolBoxCommon\snake\', path);

H = fspecial( 'gaussian');
outfile = strcat( OutputPath, '\', Index(1).name);
img_t = imread( strcat( InputPath, '\', Index(1).name));

%     img_t = imfilter( img_t, H);
%     img_t = medfilt2( img_t, [3 3]);
img_t = imfilter( img_t, H);    
imwrite(img_t, outfile);

[bg_img, StaBG, cut] = bg_compensate_v2( img_t, 1.7);

for i = 2:1:length( Index)
%%% load images ----------------------------------------------------------
    disp(num2str(i));    
    img_t = imread( strcat( InputPath, '\', Index(i).name));
    %%% smooth the image
    img_t = imfilter( img_t, H);
    [bg_img, temp, cut] = bg_compensate_v2( img_t, 1.7);
    
    adjust_factor = StaBG./temp;
    newImg = uint16(double(img_t).*adjust_factor);
    
    outfile = strcat( OutputPath, '\', Index(i).name);
    imwrite( newImg, outfile);
end
    


%%% plot corrected intensity images 
% Index = dir( strcat( InputPath, '\', '*.tif'));
% Mean = [];
% for i = 1:length( Index)
%     img = imread( strcat(InputPath, '\', Index(i).name));
%     %% background .....
% %      img = img(87:172, 110:227);
%     img = img(409:468, 189:405);
%     Mean = [Mean, mean2(img)];
% end
% %Mean1 = [min(Mean) - 10, Mean, max(Mean) + 10]; figure, axis off;
% % xlim([1, 230]);
% figure, plot(Mean); hold on; plot(1, Mean(1), 'r*'); %plot( 200, Mean(200), 'r*');
% % plot(Mean1, 'r');
% xlim([1, 200]);
% ylim([3800, 3970]);
% % title('Mean value of original 051606-HeLaMCF10A-DMSO-1');
% title('Mean value of background of original 051606-HeLaMCF10A-DMSO-1');
% title('Mean value of normalized 051606-HeLaMCF10A-DMSO-1');
% title('Mean value of background of normalized 051606-HeLaMCF10A-DMSO-1');


