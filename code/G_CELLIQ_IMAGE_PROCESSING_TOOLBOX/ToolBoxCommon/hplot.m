%function hplot(data,binsize,str);
function hplot(data,binsize,str);

[n,x]=hist(data,x_interval(data,binsize));
bar(x,n./binsize,str); %normalize JL 2000-10-19
xlim([min(x),max(x)]);

