%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% extract gabor features for a cell
% Ning Liu
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function FGW = feature_gabor(img, N, freq, stage, orientation,flag)
%stage = 5;
%orientation = 7;
%freq = [0.05 0.4];
%flag = 0;


%generate the spatial domain of the Gabor wavelets
for s = 1:stage,
    for n = 1:orientation,
        [Gr,Gi] = Gabor(N,[s n],freq,[stage orientation],flag);
        F = fft2(Gr+j*Gi);
        F(1,1) = 0;
        GW(N*(s-1)+1:N*s,N*(n-1)+1:N*n) = F;
    end;
end;

%compute the image features
F = Fea_Gabor_brodatz(img,GW,N,stage,orientation);
FGW=[F(:,1); F(:,2)];
%FG = FG';

FGW=reshape(FGW,[length(FGW) 1]);