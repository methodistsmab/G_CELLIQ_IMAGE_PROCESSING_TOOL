function features = mb_texture(I)

% [ZNAMES, ZVALUES] = MB_TEXTURE(I) Haralick co-ocurrence features
% returns 14 features abd the corresponding names 
% I is the imput gray image
%
% Reference:
% Haralick, R.M., K. Shanmugam, and I. Dinstein. 1973. Textural features
% for image classification.  IEEE Transactions on Systems, Man, and
% Cybertinetics, SMC-3(6):610-621.
%
% Xiaobo Zhou, Harvard Medical School, 02/08/05

znames = {} ;
zvalues = [] ;


%  features_used->ASM
%  features_used->contrast
%  features_used->correlation
%  features_used->variance
%  features_used->IDM
%  features_used->sum_avg
%  features_used->sum_var
%  features_used->sum_entropy
%  features_used->entropy
%  features_used->diff_var
%  features_used->diff_entropy
%  features_used->meas_corr1
%  features_used->meas_corr2
%  features_used->max_corr_coef

features = haralick(I);

%for n=1:14,
%	znames = [znames cellstr(sprintf('Texture_%i', n))] ;
%	zvalues = [zvalues features(i)] ;
%end
