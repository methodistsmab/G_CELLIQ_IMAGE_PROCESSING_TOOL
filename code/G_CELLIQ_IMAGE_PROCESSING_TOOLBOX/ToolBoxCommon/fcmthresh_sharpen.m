function [bw,level]=fcmthresh_sharpen(IM,sw)
%FCMTHRESH Thresholding by 3-class fuzzy c-means clustering
%  [bw,level]=fcmthresh(IM,sw) outputs the binary image bw and threshold level of
%  image IM using a 3-class fuzzy c-means clustering. It often works better
%  than Otsu's methold which outputs larger or smaller threshold on
%  fluorescence images.
%
%  sw is 0 or 1, a switch of cut-off position.
%  sw=0, cut between the small and middle class
%  sw=1, cut between the middle and large class
%
%  Contributed by Guanglei Xiong (xgl99@mails.tsinghua.edu.cn)
%  at Tsinghua University, Beijing, China.

% check the parameters
if (nargin<1)
    error('You must provide an image.');
elseif (nargin==1)
    sw=0;
elseif (sw~=0 && sw~=1)
    error('sw must be 0 or 1.');
end
IM = mat2gray( IM);
data=reshape(IM,[],1);
[center,member]=fcm(data,3);

[center,cidx]=sort(center);
member=member';
member=member(:,cidx);
member = sharpen( member, 2, .6);
[maxmember,label]=max(member,[],2);
if sw==0
    level=(max(data(label==1))+min(data(label==2)))/2;
else
    level=(max(data(label==2))+min(data(label==3)))/2;
end
bw=im2bw(IM,level);


%%% sub-functions 
function U1 = sharpen(U, class_n, T)

    U1 = U(class_n,:);
    U1 = U1>T;
    U(class_n,:) = U1;
    U1 = U;

