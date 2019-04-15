function RNAi_MoreNuc_det_seg_60X( InputPath, OutputPathCell, OutputPathLabPhe,Para_SE1,Para_SEd,Mu,Iter)
%%% this is a testing version ....
%%% inputpath is the path of the input images
%%% outputpath is where you want to put the segmentation result
%%% two solutions: I. use the nuclei as the seeds of the following
%%% segmentation. II. segment the cells directly. We can test it firstly
%%% and then get the conclusions. You conclusion should include the error
%%% rate. The other question is that how about segment the cytoplasm from
%%% the background?

%%% set path
path('ToolBoxCommon', path);
path('ToolBoxCommon/BgCorrection', path);
path( 'ToolBoxCommon/Propagate', path);
path( 'ToolBoxCommon/Self', path);
path( 'ToolBoxCommon/snake', path);
path( 'ToolBoxCommon/threshold', path);
% path('.\ToolBoxCommon', path); %%%Fuhai Li, changed..Aug. 2010.

%% set parameters

num_1 = 13;
num_2 = 7;
SE1 = strel( 'disk', num_1);   %SE1 = strel( 'disk', 13);
SEd = strel('disk', num_2);     %SEd = strel( 'disk', 3);
mu = .1;
ITER = 0;

%%
Index = dir( strcat( InputPath, '/', '*.tif'));
N = floor( length(Index)/3) - 1;

for i = 0:1:N
    %%% create a directory for each image
    OutDir = strcat(OutputPathCell, '/', strrep(Index(i*3+2).name, '.tif', '_seg'));
    mkdir( OutDir);
%     TimeB = cputime; 
%%% load images ----------------------------------------------------------
    img_t = mat2gray(imread( strcat( InputPath, '/', Index(i*3+3).name)));
    img_a = mat2gray(imread( strcat( InputPath, '/', Index(i*3+2).name)));
    img_n = mat2gray(imread( strcat( InputPath, '/', Index(i*3+1).name)));
    % discard dark images
    thresh_n=graythresh(img_n);
    if thresh_n>=0.05
       %discard dark images
    img_cyto = mat2gray(img_a + img_t);    
    [rows, cols] = size( img_n);
    img_col = zeros([rows, cols, 3]);
    img_col(:,:,1) = img_a;
    img_col(:,:,2) = img_t;
    img_col(:,:,3) = img_n;
%%%% background correction ----------------------------------------------- 
    %%% nuclei channel
    try
    [bg_img_n, temp, cut_n] = bg_compensate_v2( img_n, 1.7);
    catch
        mkdir([InputPath,'/rule out']);
        movefile(strcat(InputPath, '/', Index(i*3+1).name),strcat(InputPath,'/rule out'));
        movefile(strcat(InputPath, '/', Index(i*3+2).name),strcat(InputPath,'/rule out'));
        movefile(strcat(InputPath, '/', Index(i*3+3).name),strcat(InputPath,'/rule out'));
        warning on;
        warning('background correction error!');
        warning off;
        continue;
    end
    %%% segment the cytometry from the back ground by the data driven
    %%% background correction method. 
    %bw_cyto1 = im2bw( img_cyto, .7*graythresh( img_cyto));
    [bw_cyto, T] = adaptive_threshold( img_n);
    bw_cyto1 = img_n > .4*T;
    bw_cyto2 = im2bw( img_a, .75*graythresh( img_cyto));
    bw_cyto = bw_cyto1 | bw_cyto2;
    
    %% fill the holes
    labt = bwlabel( ~bw_cyto);
    Prop = regionprops( labt, 'area');
    Area = cat(1, Prop.Area);
    indext = find( Area < 50);
    for k = 1:length( indext)
        labt(labt == indext(k)) = 0;
    end
    bw_cyto = ~(im2bw(labt, .5));
    
    %%% segment the nuclei from the back ground by the data driven
    %%% background correction method.
%     bw_n = bg_img_n>.3*cut_n;
    bg_img_n = mat2gray(bg_img_n);
%     bw_n1 = im2bw( bg_img_n, .65*graythresh(bg_img_n));
   bw_n = im2bw( bg_img_n, .5*graythresh(bg_img_n));
    
    labt = bwlabel(~bw_n);
    Prop = regionprops(labt, 'area');
    Area = cat(1, Prop.Area);
    Indt = find(Area > 30);
    bw_n = false(size(labt));
    for kk = 1:length(Indt)
        bw_n(labt == Indt(kk)) = true;
    end
    bw_n = ~bw_n;
    bw_cyto = bw_cyto | imdilate(bw_n, SEd);
    
    disNucImg = bwdist(~bw_n);

    
%%% compute the gradient vector flow -------------------------------------
   
    [u_t, v_t] = GVF_v3( disNucImg, mu, ITER);
% %%% compute convergence (central) point image --------------------------------------
    flux_img = par_dif_v2( u_t, v_t, 25, bw_n);
%     
% %%% Detect nuclei with different radii R_bright and R_dark ---------------    
    seeds_1 = flux_img>25;
    
    Seeds = imdilate( seeds_1, SE1);
    Seeds = bwmorph( Seeds, 'shrink', Inf);
    Seeds = imdilate( Seeds, SE1);

    %%%%
%     [Seeds, sed_img] = SNR_thresh_2( Seeds, img_t1, .35);
%%% segmentation with seeded watershed method ----------------------------
    %%% segment the nuclei channel.
    LabMat_n = seeded_watershed_v2( bw_n.*Seeds,bw_n.*double(img_n));
    Prop = regionprops(LabMat_n, 'area', 'Eccentricity' );
    Area = cat(1, Prop.Area);
    Ecc = cat(1, Prop.Eccentricity);
    indext = find(Area < 200);
    for k = 1:length( indext)
        LabMat_n(LabMat_n == indext(k)) = 0;
    end
    LabMat_n = bwlabel(im2bw( LabMat_n, .5)); 
    
    Seeds_a = im2bw( LabMat_n, .5);  

    %%% segment the actin channel
%     LabMat_cyto = seeded_watershed_v2( bw_cyto.*Seeds_a,bw_cyto.*double(img_cyto));
    %LabMat_cyto = ProVorSeg_v3( bwlabel(Seeds_a), img_cyto, bw_cyto);
    LabMat_cyto = seeded_watershed_RNAi_v2( Seeds_a, bw_cyto.*double(img_cyto));
    
    %LabMatEdit = RemBouTouCel_v2( LabMat_cyto);
    LabMatEdit = LabMat_cyto;
    %%% remove the debrises .......
    Prop = regionprops( LabMatEdit, 'area');
    Area = cat(1, Prop.Area);
    indt = find(Area < 500);
    for kt = 1:length(indt)
        LabMatEdit( LabMatEdit == indt(kt)) = 0;
    end
    LabMatEdit = bwlabel( im2bw( LabMatEdit, .5));    
    
    maxLab = ordfilt2( LabMatEdit, 9, ones(3,3));
    minLab = ordfilt2( maxLab, 1, ones(3,3));
    Bou = maxLab - minLab;
    minLab(Bou > 0) = 0;
    bwt = bwmorph(im2bw( minLab, .5),'open');
    labt = bwlabel( ~bwt);
    Prop = regionprops( labt, 'area');
    Area = cat(1, Prop.Area);
    indt = find( Area < 500);
    if length(indt) > 0        
        for k = 1:length( indt)
            bwt = labt == indt(k);
            bwt = bwmorph(bwt, 'dilate', 1);
            tag = bwt.*LabMatEdit;
            tag = unique( tag(:));
            if length( tag) <3
                labt(labt == indt(k)) = 0;
            end
        end
%         bwt = bwmorph(~im2bw(labt, .5), 'open');
        LabMat_a = bwlabel( ~im2bw(labt, .5));        
    else
        LabMat_a = LabMatEdit;
    end
    %Tubulin segmentation
    
    
     %%% nuclei channel
%      img_t=img_cyto;
    try
    [bg_img_t, temp, cut_t] = bg_compensate_v2( img_t, 1.7);
    catch
        mkdir([InputPath,'/rule out']);
        movefile(strcat(InputPath, '/', Index(i*3+1).name),strcat(InputPath,'/rule out'));
        movefile(strcat(InputPath, '/', Index(i*3+2).name),strcat(InputPath,'/rule out'));
        movefile(strcat(InputPath, '/', Index(i*3+3).name),strcat(InputPath,'/rule out'));
        warning on;
        warning('background correction error!');
        warning off;
        continue;
    end
    %%% segment the cytometry from the back ground by the data driven
    %%% background correction method. 
    %bw_cyto1 = im2bw( img_cyto, .7*graythresh( img_cyto));
    [bw_cyto, T] = adaptive_threshold( img_t);
    bw_cyto1 = img_t > .4*T;
    bw_cyto2 = im2bw( img_a, .75*graythresh( img_cyto));
    bw_cyto = bw_cyto1 | bw_cyto2;
    
    %% fill the holes
    labt = bwlabel( ~bw_cyto);
    Prop = regionprops( labt, 'area');
    Area = cat(1, Prop.Area);
    indext = find( Area < 50);
    for k = 1:length( indext)
        labt(labt == indext(k)) = 0;
    end
    bw_cyto = ~(im2bw(labt, .5));
    
     %%% segment the nuclei from the back ground by the data driven
    %%% background correction method.
%     bw_n = bg_img_n>.3*cut_n;
    bg_img_t = mat2gray(bg_img_t);
%     bw_n1 = im2bw( bg_img_n, .65*graythresh(bg_img_n));
   bw_t = im2bw( bg_img_t, .5*graythresh(bg_img_t));
    
    labt = bwlabel(~bw_t);
    Prop = regionprops(labt, 'area');
    Area = cat(1, Prop.Area);
    Indt = find(Area > 30);
    bw_t = false(size(labt));
    for kk = 1:length(Indt)
        bw_t(labt == Indt(kk)) = true;
    end
    bw_t = ~bw_t;
    bw_cyto = bw_cyto | imdilate(bw_t, SEd);
    
    disTubImg = bwdist(~bw_t);
    %%% scale space theory -- gaussian filtering
%     Sigma = 2;
%     HSize = ceil( Sigma * 3) *2 + 1;
%     H = fspecial( 'gaussian', HSize, Sigma);
%     img_n1 = imfilter( disNucImg, H);
    
    %%% if you want to use the distance image
%     img_n1 = bwdist(~bw_n);
    
%%% compute the gradient vector flow -------------------------------------
   
    [u_t, v_t] = GVF_v3( disTubImg, mu, ITER);
% %%% compute convergence (central) point image --------------------------------------
    flux_img = par_dif_v2( u_t, v_t, 25, bw_t);
%     
% %%% Detect nuclei with different radii R_bright and R_dark ---------------    
    seeds_1 = flux_img>25;
    
    Seeds = imdilate( seeds_1, SE1);
    Seeds = bwmorph( Seeds, 'shrink', Inf);
    Seeds = imdilate( Seeds, SE1);
   
    %%%%
%     [Seeds, sed_img] = SNR_thresh_2( Seeds, img_t1, .35);
%%% segmentation with seeded watershed method ----------------------------
    %%% segment the nuclei channel.
    LabMat_t = seeded_watershed_v2( bw_t.*Seeds,bw_t.*double(img_t));
    Prop = regionprops(LabMat_n, 'area', 'Eccentricity' );
    Area = cat(1, Prop.Area);
    Ecc = cat(1, Prop.Eccentricity);
    indext = find(Area < 200);
    for k = 1:length( indext)
        LabMat_t(LabMat_t == indext(k)) = 0;
    end
    LabMat_t = bwlabel(im2bw( LabMat_t, .5)); 
    
    Seeds_t = im2bw( LabMat_n, .5);  

         
    
    %End Tubulin Segmentation
    
    
    %%% remove the cells touching the image boundaries
%     LabMat_a = RNAi_RemBouTouCel( LabMat_a);    
    %%% draw results
    seg_img_n   = bou_dra( img_n, LabMat_n);
    seg_img_col = bou_dra( img_col, LabMat_a);
    seg_img_cyt = bou_dra( img_cyto, LabMat_a);
    seg_img_t = bou_dra( img_t, LabMat_t);
    
    fig = figure;
    drawImglabel(seg_img_col, LabMat_a);
    seg_img_a = getframe(gca, [1,1, cols, rows]);
    close(fig);
    pause(0.001);
    seg_img_a = seg_img_a.cdata;
    %%% crop cells ............................
    for it = 1:max(LabMat_a(:))
       celt = crop_col_cell( it, LabMat_a, img_col);
       outfilet = strcat( OutDir, '/', num2str(it), '.tif');
       imwrite( celt, outfilet);
    end 
    
%%% draw result ----------------------------------------------------------   
    ActinImage = LabMat_a;
    NucleiImage = im2bw(LabMat_n, .5).*LabMat_a;    
    PhenoImage = ones(max(ActinImage(:)), 1);
    
    output_file = strrep(Index(i*3+2).name, '.tif', '_PhenoImage.mat'); 
    output_file = strcat( OutputPathLabPhe, '/', strrep(output_file, '.TIF', '_PhenoImage.mat')); 
    save( output_file, 'PhenoImage');

    output_file = strrep(Index(i*3+2).name, '.tif', '_Data.mat'); 
    output_file = strcat( OutputPathLabPhe, '/', strrep(output_file, '.TIF', '_Data.mat')); 
    save( output_file, 'ActinImage', 'NucleiImage');
  
    seg_n_file = strrep( Index(i*3+2).name, '.tif', '_NucleiImage.tif');
    seg_n_file = strcat( OutputPathLabPhe, '/', strrep(seg_n_file, '.TIF', '_ColorImage2.tif')); 
    imwrite( seg_img_n, seg_n_file);
    
    seg_n_file = strrep( Index(i*3+2).name, '.tif', '_ColorImage1.tif');
    seg_n_file = strcat( OutputPathLabPhe, '/', strrep(seg_n_file, '.TIF', '_ColorImage2.tif')); 
    imwrite( seg_img_col, seg_n_file);

    seg_n_file = strrep( Index(i*3+2).name, '.tif', '_ColorImage2.tif');
    seg_n_file = strcat( OutputPathLabPhe, '/', strrep(seg_n_file, '.TIF', '_ColorImage2.tif')); 
    imwrite( seg_img_cyt, seg_n_file);
    
    seg_a_file = strrep( Index(i*3+2).name, '.tif', '_cytoSeg.png');
    seg_a_file = strcat( OutDir, '/', strrep(seg_a_file, '.TIF', '_cytoSeg.png')); 
    imwrite( seg_img_a, seg_a_file);  
    
    seg_t_file = strrep( Index(i*3+2).name, '.tif', '_tubSeg.png');
    seg_t_file = strcat( OutDir, '/', strrep(seg_t_file, '.TIF', '_tubSeg.png')); 
    imwrite( seg_img_t, seg_t_file);  
    
    else
        disp(OutDir);
    end
 end