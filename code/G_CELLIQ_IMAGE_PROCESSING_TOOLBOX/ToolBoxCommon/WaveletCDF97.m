function X = WaveletCDF97(X, Level)
%WAVELETCDF97  Cohen-Daubechies-Fauraue 9-7 Wavelet Transforms
%   Y = WaveletCDF97(X, N) performs N decomposition stages on image
%   X and produces wavelet transform Y.  Use negative N for inverse
%   transform.  Boundaries are handled with symmetric extension.  
%
%   The image dimensions must be divisible by 2^N.  Rectangular
%   images are allowed.
%
%   Example:
%   Y = WaveletCDF97(X, 5);  % transform image X to Y using 5 stages
%   R = WaveletCDF97(Y, -5); % reconstruct Y

% Pascal Getreuer 2004

error(nargchk(2,2,nargin));

N = size(X);

if ndims(X) ~= 2, error('2D array expected.'); end
if any(rem(N,pow2(Level))), error('Invalid image size.'); end
if any(N-1 < pow2(Level)), error('Image size too small for transform level.'); end

if Level >= 0	% forward transform
   for i = 1:Level
      X(1:N(1),1:N(2)) = Stage(Stage(X(1:N(1),1:N(2)),1)',1)';
      N = 0.5*N;
   end
else  			% inverse transform
   N = N*pow2(Level+1);
   
   for i = 1:-Level
      X(1:N(1),1:N(2)) = Stage(Stage(X(1:N(1),1:N(2)),-1)',-1)';
      N = 2*N;   
   end
end

return;


function X = Stage(X, Dir)
% perform one 1D stage 

[N2,num] = size(X);
N = 0.5*N2;
FiltIRep = ones(1,num);		% for filtering 
PadExt = [2:N,N];

% CDF 9/7 lifting scheme filter sequence coefficients
Seq = [-1.58613432,-0.05298011854,0.8829110762,0.4435068522;
   -1.58613432,-0.05298011854,0.8829110762,0.4435068522];
ScaleFactor = 1.149604398;

if Dir > 0		% decomposition stage
	Approx = X(1:2:N2,:);
   Detail = X(2:2:N2,:) + filter(Seq(:,1),1,Approx(PadExt,:),...
      Approx(1,:).*Seq(1,FiltIRep));
   Approx = Approx + filter(Seq(:,2),1,Detail,...
      Detail(1,:).*Seq(1,2*FiltIRep));
	Detail = Detail + filter(Seq(:,3),1,Approx(PadExt,:),...
  	   Approx(1,:).*Seq(1,3*FiltIRep));	        
   X = [(Approx + filter(Seq(:,4),1,Detail,...
         Detail(1,:).*Seq(1,4*FiltIRep)))*ScaleFactor;
      Detail/ScaleFactor];
else				% synthesis stage
	Detail = X(N+1:N2,:)*ScaleFactor;         
   Approx = (X(1:N,:)/ScaleFactor) - filter(Seq(:,4),1,Detail,...
      Detail(1,:).*Seq(1,4*FiltIRep));
	Detail = Detail - filter(Seq(:,3),1,Approx(PadExt,:),...
  	   Approx(1,:).*Seq(1,3*FiltIRep));	        
   Approx = Approx - filter(Seq(:,2),1,Detail,...
      Detail(1,:).*Seq(1,2*FiltIRep));   
   X([1:2:N2,2:2:N2],:) = [Approx;    
      Detail - filter(Seq(:,1),1,Approx(PadExt,:),...
      Approx(1,:).*Seq(1,FiltIRep))];
end
return;

