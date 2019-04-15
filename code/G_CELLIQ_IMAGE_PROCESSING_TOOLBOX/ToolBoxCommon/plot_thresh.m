% function line=plot_thresh(thresholds);

function line=plot_thresh(thresholds);

push_hold
hold on

yl=ylim;

line=zeros(0);
for i=1:length(thresholds)
	line(length(line)+1)=plot([thresholds(i),thresholds(i)],[0,yl(2)*0.9],'k');
	text(thresholds(i),yl(2)*0.9,sprintf('  %.2f',thresholds(i)));
end;

pop_hold
