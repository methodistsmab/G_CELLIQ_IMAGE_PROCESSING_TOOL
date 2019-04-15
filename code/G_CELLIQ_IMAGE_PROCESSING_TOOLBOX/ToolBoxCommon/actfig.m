%function actfig(fig=gcf+1)
%sets active figure without show
%if the figure does not exist, we will need to call figure, so the it will show.

function actfig(fig)

if (nargin<1)
	fig=gcf+1;
end

if (isempty(find(get(0,'Children')==fig)))
	figure(fig);
else
	set(0,'CurrentFigure',fig);
end