%%function y=reverse(x);
function y=reverse(x);

if (size(x,2)==1)
	y=flipud(x);
else
	y=fliplr(x);
end	

%[r,c]=size(x);
%rr=r:-1:1;
%y=x(:,rr);

%n=length(x);
%y=zeros(size(x));
%for i=1:n
%  y(i)=x(n-i+1);
%end


