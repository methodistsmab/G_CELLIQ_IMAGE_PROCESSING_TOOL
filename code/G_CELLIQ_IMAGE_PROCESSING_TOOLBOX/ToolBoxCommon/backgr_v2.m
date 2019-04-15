%function [res,iters]=backgr(img,mode='auto',thresh=2,splinepoints=5,ploton=0);
% Iterative spline based background correction
% spline mesh is splinepoints x splinepoints
%
% Modes are defined by the background intensity:
%
% 'dark','low' or -1
% 'bright','high' or 1
% 'gray','grey','mid' or 0 (i.e. both dark and bright objects)
% 'auto' (autodetection of mode)
%
% thresh is threshold to cut at, in units of sigma
%  larger thresh -> slower but more stable convergence
%
% return val iters is number of iterations
%
% Copyright 2001 Joakim Lindblad

function [res,i, cut]=backgr_v2(img,mode,thresh,splinepoints,ploton,scale); %scale is only used for the middle plotting of a line, to be removed

if nargin<2
	mode='auto';
end;

if nargin<3
	thresh=2;
end;

if nargin<3
	splinepoints=5;
end;

if nargin<5
	ploton=0;
end;

if nargin<6
	scale=1;
end;

if strcmp(mode,'auto')
	mode=automode(img);
elseif strcmp(mode,'dark') | strcmp(mode,'low')
	mode=-1;
elseif strcmp(mode,'bright') | strcmp(mode,'high')
	mode=1;
elseif strcmp(mode,'gray') | strcmp(mode,'grey') | strcmp(mode,'mid')
	mode=0;
end;

% %disp(sprintf('\n'));
% if (mode<0)
% % 	disp('Dark background mode');
% elseif (mode>0)
% % 	disp('Bright background mode');
% else
% % 	disp('Gray background mode');
% end

maxiter=40;

stop_criterion=(max(img(:))-min(img(:)))/1000;

[r,c]=size(img);

mask=ones(r,c);                     %start with mask = whole image

oldres=zeros(r,c);						%old background

for i=1:maxiter

if (ploton)
	actfig(i);
	subplot(3,1,1);
	imagesc(mask.*(img+30));		     	%plot background
	colorbar;
end
	
	[px,py,pz]=splineimage(img,splinepoints,mask);	%now with mask
	res=evalspline2d(1:c,1:r,px,py,pz);
	
if (ploton)
	subplot(3,1,2);
	imagesc(res);
	colorbar;
end
	
	comp=img-res;

if (ploton)
	subplot(3,1,3);
	imagesc(comp);
	colorbar;
	flush;
	shg;
end

    diff=res-oldres;
    stddiff=std(diff(:));
	if (stddiff<stop_criterion)
% 		disp(sprintf('Converged after %d iterations',i));
		break;
	elseif (i==maxiter)
		warning(sprintf('Background did not converge after %d iterations\nMake sure that the forground/background mode is correct',i));
	end

	if (nnz(mask) < 0.01*r*c)
		warning(sprintf('Less than 1%% of the pixels used for fitting,\ntry starting again with a larger threshold value'));
		break;
	end

	oldres=res;

%/////////////////////////////////////////////////////////////////////////////
if 0
line=r/2-3;
nextfig
clf
fontsize(20);
linewidth(plot((1:c).*scale,img(line,:),'k-'),2);
hold on
%set(bar(find(mask(line,:)),ones(1,length(find(mask(line,:)))).*15),'EdgeColor','y','FaceColor','y');
bar(find(mask(line,:)).*scale,ones(1,length(find(mask(line,:)))).*15,1,'y');
linewidth(plot((1:c).*scale,res(line,:),'k--'),4);
fontsize(20);
hold off
xlim([1,c.*scale])
ylim([0,255]);
ylabel('Intensity');
xlabel('Pixels');
title(sprintf('Iteration %d',i));
bwepssave(sprintf('bg_it%d.eps',i));
end
%/////////////////////////////////////////////////////////////////////////////

%calc new mask
	backgr=comp(find(mask));
	sigma=std(backgr);
	cut=sigma*thresh;
%	cut=thresh

	if (mode<0)
		mask=comp<cut;
	elseif (mode>0)
		mask=comp>-cut;
	else
		mask=abs(comp)<cut;
	end

end

%splineplot(1:3:c,1:3:r,px,py,pz);
