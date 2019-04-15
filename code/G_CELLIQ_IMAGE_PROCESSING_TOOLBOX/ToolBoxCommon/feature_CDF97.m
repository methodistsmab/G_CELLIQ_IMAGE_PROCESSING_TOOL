function FECDF=feature_CDF97(I)

[m,n]=size(I);

if m~=n
    fprintf('Image size problem!\n');
    return;
end

imgsize=64;
featurelen=5;
I=imresize(I,[imgsize, imgsize]);

Levels=[3,4,5];

for i=1:length(Levels)
    X = WaveletCDF97(double(I)/255, Levels(i));
    Y = reshape(X,imgsize*imgsize, 1);
    [x y]=hist(Y);
    [max_x, ind_x]=max(x);
    CDF(i,1)=min(Y);
    CDF(i,2)=max(Y);
    CDF(i,3)=mean(Y);
    CDF(i,4)=std(Y);
    CDF(i,5)=y(ind_x);
end
FECDF=reshape(CDF',length(Levels)*featurelen,1);