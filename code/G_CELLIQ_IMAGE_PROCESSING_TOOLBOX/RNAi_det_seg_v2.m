function RNAi_det_seg_v2( InputPath, OutputPath)

%%% inputpath is the path of the input images
%%% outputpath is where you want to put the segmentation result
%%% two solutions: I. use the nuclei as the seeds of the following
%%% segmentation. II. segment the cells directly. We can test it firstly
%%% and then get the conclusions. You conclusion should include the error
%%% rate. The other question is that how about segment the cytoplasm from
%%% the background?

%%% set path
path('ToolBoxCommon\BgCorrection', path);
path( 'ToolBoxCommon\Propagate', path);
path( 'ToolBoxCommon\Self', path);
path( 'ToolBoxCommon\snake', path);
 
%%% file information Index_n (nuclei channel), Index_a (actin channel),
%%% Index_r (rac channel)
Index = dir( strcat( InputPath, '\', '*.tif'));
% Index_a = dir( strcat( InputPath, '\', '*14.tif'));
% Index_r = dir( strcat( InputPath, '\', '*15.tif'));
% N = floor(length(Index)/3)-2;
N = floor( length(Index)/3) - 1;
SE1 = strel( 'disk', 10);
mu = .1;
ITER = 0;

%%% processing images -- detect them first and then segment cells
for i = 0:1:N
%     TimeB = cputime; 
%%% load images ----------------------------------------------------------
%     img_r = mat2gray(imread( strcat( InputPath, '\', Index(i*3+1).name)));
    img_a = mat2gray(imread( strcat( InputPath, '\', Index(i*3+2).name)));
    img_n = mat2gray(imread( strcat( InputPath, '\', Index(i*3+3).name)));
    
%     img_cyto = .5*(img_a + img_r);
    img_cyto = mat2gray(img_a+img_n);    
    [rows, cols] = size( img_n);
%%%% background correction ----------------------------------------------- 
%     %%% cytometry channel 
%     Mean = mean2(img_cyto);
%     imgt = (img_cyto - Mean).^2;
%     Std = sqrt(mean2(imgt));    
    
%     [bg_img_cyto, temp, cut_cyto] = bg_compensate_v2( img_cyto, 1.7);
    %%% nuclei channel
    [bg_img_n, temp, cut_n] = bg_compensate_v2( img_n, 1.7);
    %%% segment the cytometry from the back ground by the data driven
    %%% background correction method. 
%     bw_cyto = bg_img_cyto>.8*cut_cyto;
    bw_cyto = im2bw( img_cyto, .6*graythresh( img_cyto));
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
    bw_n = im2bw( bg_img_n, graythresh(bg_img_n));
    %%% scale space theory -- gaussian filtering
    Sigma = 3;
    HSize = ceil( Sigma * 3) *2 + 1;
    H = fspecial( 'gaussian', HSize, Sigma);
    img_n1 = imfilter( img_n, H);
    
    %%% if you want to use the distance image
%     img_n1 = bwdist(~bw_n);
    
%%% compute the gradient vector flow -------------------------------------
   
    [u_t, v_t] = GVF_v3( img_n1, mu, ITER);
% %%% compute convergence (central) point image --------------------------------------
    flux_img = par_dif_v2( u_t, v_t, 15, bw_n);
    
%%% Detect nuclei with different radii R_bright and R_dark ---------------    
    Noise = rand(size(img_n))./600;
    img_n2 = img_n1 + Noise;
    
    seeds_1 = flux_img>20;
%     img_t1_n1 = seeds_1.*img_n2;
%     
%     %%%local region noises suppression r = 10
%     SE = strel( 'disk', 10);
%     seeds_2 = img_t1_n1 >= ordfilt2( img_t1_n1, 321, getnhood(SE), 'symmetric');
% %     seeds_2 = img_t1_n1 >= ordfilt2( img_t1_n1, 445, getnhood(SE), 'symmetric');
%     seeds_3 = seeds_2.*(img_t1_n1>0);
    
    
    Seeds = imdilate( seeds_1, SE1);
    Seeds = bwmorph( Seeds, 'shrink', Inf);
    Seeds = imdilate( Seeds, SE1);
    Seeds = BW_watershed_v2( Seeds);
    Seeds = im2bw( Seeds, .5);
    
    %%%%
%     [Seeds, sed_img] = SNR_thresh_2( Seeds, img_t1, .35);
%%% segmentation with seeded watershed method ----------------------------
    %%% segment the nuclei channel.
    LabMat_n = seeded_watershed_v2( bw_n.*Seeds,bw_n.*double(img_n1));
    Prop = regionprops(LabMat_n, 'area', 'Eccentricity' );
    Area = cat(1, Prop.Area);
    Ecc = cat(1, Prop.Eccentricity);
    indext = find(Area < 50| (Area < 200 & Ecc >.7 ));
    for k = 1:length( indext)
        LabMat_n(LabMat_n == indext(k)) = 0;
    end
    LabMat_n = bwlabel( im2bw(LabMat_n, .5));
%     Seeds_a = im2bw(LabMat_n);
    Seeds = ordfilt2( LabMat_n, 9, ones(3,3));
    Seeds_a = ordfilt2( Seeds, 9, ones(3,3));
    bou = Seeds_a - Seeds;
    Seeds_a(bou>0) = 0;
    Seeds_a = im2bw( Seeds_a, .5);
   
%     SE = strel( 'disk', 13);
%     Seeds = bwmorph( Seeds_a, 'shrink', Inf);
%     Seeds = imdilate( Seeds, SE);
%     Seeds = BW_watershed_v2( Seeds);
%     Seeds_a = im2bw( Seeds, .5);
    %%% segment the actin channel
    LabMat_cyto = seeded_watershed_v2( bw_cyto.*Seeds_a,bw_cyto.*double(img_cyto));
    
    LabMatEdit = RemBouTouCel_v2( LabMat_cyto);
    %%% draw results
    seg_img_n = bou_dra( img_n, LabMat_n);
    seg_img_a = bou_dra( img_a, LabMat_cyto);
       
%%% draw result ----------------------------------------------------------   
    
    output_file = strrep(Index(i*3+2).name, '.tif', '_labMat.mat'); 
    output_file = strcat( OutputPath, '\', strrep(output_file, '.TIF', '_labMat.mat')); 
    save( output_file, 'LabMatEdit');
%     
    seg_n_file = strrep( Index(i*3+3).name, '.tif', '_nucSeg.png');
    seg_n_file = strcat( OutputPath, '\', strrep(seg_n_file, '.TIF', '_nucSeg.png')); 
    imwrite( seg_img_n, seg_n_file);
    
    seg_a_file = strrep( Index(i*3+2).name, '.tif', '_cytoSeg.png');
    seg_a_file = strcat( OutputPath, '\', strrep(seg_a_file, '.TIF', '_cytoSeg.png')); 
    imwrite( seg_img_a, seg_a_file); 
%     cputime - TimeB
 end
%     TimeE = cputime - TimeB;
%     disp(num2str(TimeE));
