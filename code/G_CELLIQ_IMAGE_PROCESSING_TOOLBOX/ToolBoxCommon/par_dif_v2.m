function [value, bg_img] = par_dif_v2( u, v, Iter, bw)

Mat = double(ones( size( u)));

V1 = -[1,0];
V2 = -[sqrt(.5),sqrt(.5)];
V3 = -[0,1];
V4 = -[-sqrt(.5),sqrt(.5)];
V5 = -[-1,0];
V6 = -[-sqrt(.5),-sqrt(.5)];
V7 = -[0,-1];
V8 = -[sqrt(.5),-sqrt(.5)];
fx = u;
fy = v;
A1 = fx.*V1(1,1) + fy.*V1(1,2);
A1 = A1.*( A1>sqrt(.5)+abs(eps));
%A1 = A1.^2;
A2 = fx.*V2(1,1) + fy.*V2(1,2);
A2 = A2.*(A2>sqrt(.5)+abs(eps));
%A2 = A2.^2;
A3 = fx.*V3(1,1) + fy.*V3(1,2);
A3 = A3.*(A3>sqrt(.5)+abs(eps));
%A3 = A3.^2;
A4 = fx.*V4(1,1) + fy.*V4(1,2);
A4 = A4.*(A4>sqrt(.5)+abs(eps));
%A4 = A4.^2;
A5 = fx.*V5(1,1) + fy.*V5(1,2);
A5 = A5.*(A5>sqrt(.5)+abs(eps));
%A5 = A5.^2;
A6 = fx.*V6(1,1) + fy.*V6(1,2);
A6 = A6.*(A6>sqrt(.5)+abs(eps));
%A6 = A6.^2;
A7 = fx.*V7(1,1) + fy.*V7(1,2);
A7 = A7.*(A7>sqrt(.5)+abs(eps));
%A7 = A7.^2;
A8 = fx.*V8(1,1) + fy.*V8(1,2);
A8 = A8.*(A8>sqrt(.5)+abs(eps));
%A8 = A8.^2;

A = A1 + A2 + A3 + A4 + A5 + A6 + A7 + A8;

A1 = A1./(A+abs(eps));
A2 = A2./(A+abs(eps));
A3 = A3./(A+abs(eps));
A4 = A4./(A+abs(eps));
A5 = A5./(A+abs(eps));
A6 = A6./(A+abs(eps));
A7 = A7./(A+abs(eps));
A8 = A8./(A+abs(eps));

[rows, cols] = size(u);
value = zeros( size(u));
Mat = ones( size(u));
%bw = im2bw( img, graythresh( img));
%[bw, T] = fcmthresh( img,0);
%[bw, T] = log_fcmthresh( img,0);
% path( 'C:\fhl\RNAi_sys\backgrond_correction\', path);
% bg_img = bg_compensate_v2( img, 1.7);
% bw = bg_img>0;
% bw = medfilt2( bw, [5,5]);
% bw = medfilt2( bw, [5,5]);
% bg_img = bw.*double(bg_img);
%bw = bwmorph( bw, 'erode');
%bw =  img > log_fcmthresh( img);
Mat = bw.*Mat;

for i = 1:Iter
   
    temp1 = zeros( size(u));
    temp1(1:rows, 1:(cols -1)) = A1( 1:rows, 2:cols).*Mat( 1:rows, 2:cols);

    temp2 = zeros( size(u));
    temp2(1:(rows-1), 1:(cols -1)) = A2( 2:rows, 2:cols).*Mat( 2:rows, 2:cols);

    temp3 = zeros( size(u));
    temp3(1:(rows-1), 1:cols) = A3( 2:rows, 1:cols).*Mat( 2:rows, 1:cols);

    temp4 = zeros( size(u));
    temp4(1:(rows-1), 2:cols) = A4( 2:rows, 1:(cols-1)).*Mat( 2:rows, 1:(cols-1));

    temp5 = zeros( size(u));
    temp5(1:rows, 2:cols) = A5( 1:rows, 1:(cols-1)).*Mat( 1:rows, 1:(cols-1));

    temp6 = zeros( size(u));
    temp6(2:rows, 2:cols) = A6( 1:(rows-1), 1:(cols-1)).*Mat( 1:(rows-1), 1:(cols-1));

    temp7 = zeros( size(u));
    temp7(2:rows, 1:cols) = A7( 1:(rows-1), 1:cols).*Mat( 1:(rows-1), 1:cols);

    temp8 = zeros( size(u));
    temp8(2:rows, 1:(cols -1)) = A8(1:(rows-1), 2:cols).*Mat(1:(rows-1), 2:cols);

    value = temp1 + temp2 + temp3 + temp4 + temp5 + temp6 + temp7 + temp8;
    %Mat = (value - Mat).*((value-Mat)>0);
    Mat = value;
end


