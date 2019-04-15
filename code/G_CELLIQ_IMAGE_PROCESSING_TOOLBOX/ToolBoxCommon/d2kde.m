%function [n,x]=d2kde(data,x,sigma);
% one sigma per x allowed
%
% Copyright 2001 Joakim Lindblad

function [n,x]=d2kde(data,x,sigma);

data=data(:); %make vector

if length(sigma)==1 %%only one sigma, conv is much faster
  
  n = hist(data,x);
  xx= mirror(x);
  g = d2gauss(xx,x(1),sigma);
  n = conv2(n,g,'same');
  
else

	n = zeros(size(x));

	if (length(x)<length(data)) %%I guess this is the usual case (less exact though)

	  h = hist(data,x);
	  for i=1:length(x)
	    n=n+d2gauss(x,x(i),sigma(i)).*h(i);
	  end

   else

	  for i=1:length(data)
	    n=n+d2gauss(x,data(i),sigma(i));
	  end

	end

end


