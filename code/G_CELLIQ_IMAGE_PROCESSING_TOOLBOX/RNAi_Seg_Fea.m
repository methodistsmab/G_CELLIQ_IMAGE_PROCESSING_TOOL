function RNAi_Seg_Fea( InputPath, OutputPath)
warning off;
%%% set path
path('ToolBoxCommon/BgCorrection', path);
path( 'ToolBoxCommon/Propagate', path);
path( 'ToolBoxCommon/Self', path);
path( 'ToolBoxCommon/snake', path);
path( 'ToolBoxCommon/threshold', path);
path( 'ToolBoxCommon/RNAi_recognition/', path);

%% create a directory to store the segmentation results.
resSegPath = strcat( OutputPath, '/', 'resSeg');
mkdir(resSegPath);
resSegPhePath = strcat( OutputPath, '/', 'resSegPhe');
mkdir(resSegPhePath);
%% create a directory to store the combined images: tubilin + actin.
% CytImgPath = strcat( OutputPath, '\', 'CytImg');
% mkdir(CytImgPath);
% 
% resFea = strcat( OutputPath, '\', 'Feature');
% mkdir(resFea);

% resCelImg = strcat( OutputPath, '\', 'CelImg');
% mkdir(resCelImg);

% RNAi_det_seg_60X_v4( InputPath, resSegPath);
RNAi_MoreNuc_det_seg_60X( InputPath, resSegPath, resSegPhePath);
% RNAi_FeaExt( resSegPath, CytImgPath, resFea);

