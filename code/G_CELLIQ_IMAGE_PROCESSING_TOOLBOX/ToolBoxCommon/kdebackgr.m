%function [backgr,iters]=kdebackgr(img,mode='auto',splinepoints=5,ploton=0);
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
% return val iters is number of iterations
%
% Copyright 2001 Joakim Lindblad

function [backgr,i]=kdebackgr(img,mode,splinepoints,ploton,scale); %scale is only used for the middle plotting of a line, to be removed

binsize=0.1;
thresholds=1;

if nargin<2
	mode='auto';
end;

if nargin<3
	splinepoints=5;
end;

if nargin<4
	ploton=0;
end;

if nargin<5
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

disp(sprintf('\n'));
if (mode<0)
	disp('Dark background mode');
elseif (mode>0)
	disp('Bright background mode');
else
	disp('Gray background mode');
end

minsigma=0;
maxiter=40;

stop_criterion=(max(img(:))-min(img(:)))/1000

[r,c]=size(img);

mask=ones(r,c);                     %start with mask = whole image

backgr=ones(r,c).*mean(img(:));		%new background, first guess
oldbackgr=ones(r,c).*-2;				%old background

for i=1:maxiter

	comp=img-backgr;

if (ploton)
	actfig(i+1);
	subplot(2,2,1);
	imagesc(comp);
	colorbar;
end

	mask=ones(r,c);                  %start with mask = whole image
		
	data=comp(:); %pick(comp,mask); %use only masked part of the image (ok this is reducule if we dont have any external mask)
	sigma=max(h_rot(data(:)),minsigma);
	disp(sprintf('Sigma=%.2f',sigma));

if (ploton)
	subplot(2,2,2);
	push_hold;
	hplot(data,sigma/2,'y');
	hold on;
	[l,n]=kdeplot(data,binsize,sigma,'b-');
	linewidth(l,3);
	[l,d2,x]=d2kdeplot(data,binsize,sigma,'r--');
	linewidth(l,3);
	relaxy;
	title(sprintf('Sigma=%.2f',sigma));
else %plot
	[n,x]=kde(data,x_interval(data,binsize),sigma);
	d2=d2kde(data,x,sigma);
end %plot
		
	peak=maxidx(n); %peak of histogram is believed to be background
	disp(sprintf('Peak=%d=%.2f',peak,x(peak)));
		
	if (mode<=0) %look above
		ofs=peak+firstval(find(d2(peak+1:length(d2))>0));
%		thresh=x(maxidx(d2(ofs:length(d2)))+ofs);
		thresh=x(first_max(d2(ofs:length(d2)))+ofs);
		disp(sprintf('Upper threshold=%.2f',thresh));
if (ploton)
	plot_thresh(thresh);
end
		mask=(comp<thresh);			
	end %no else here!
		
	if (mode>=0) %look below
		ofs=lastval(find(d2(1:peak-1)>0));
%		thresh=x(maxidx(d2(1:ofs)));
		thresh=x(last_max(d2(1:ofs)));
		disp(sprintf('Lower threshold=%.2f',thresh));
if (ploton)
	plot_thresh(thresh);
end
		mask=(comp>thresh);			
	end

if (ploton)
	pop_hold
	flush;
end

if (ploton)
	subplot(2,2,3);
	imagesc(mask.*(img+30));		     	%plot background
	colorbar;
end
	
	disp('Fitting spline...');
	[px,py,pz]=splineimage(img,splinepoints,mask);	%now with mask
	disp('Evaluating spline...');
	backgr=evalspline2d(1:c,1:r,px,py,pz);
	disp('..done');
	
if (ploton)
	subplot(2,2,4);
	imagesc(backgr);
	colorbar;
	flush;
	shg;
end
	
	diff=backgr-oldbackgr;
   stddiff=std(diff(:))
	if (stddiff<stop_criterion)
		disp(sprintf('Converged after %d iterations',i));
		break;
	elseif (i==maxiter)
		warning(sprintf('Background did not converge after %d iterations\nMake sure that the forground/background mode is correct',i));
	end

	if (nnz(mask) < 0.01*r*c)
		warning(sprintf('Less than 1%% of the pixels used for fitting,\ntry starting again with a larger threshold value'));
		break;
	end

	oldbackgr=backgr;

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

end

%splineplot(1:3:c,1:3:r,px,py,pz);
