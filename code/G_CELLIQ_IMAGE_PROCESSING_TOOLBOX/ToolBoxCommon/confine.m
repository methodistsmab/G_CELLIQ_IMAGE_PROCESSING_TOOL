%function y=confine(x,low,high);
% confine x to [low,high]
% values outside are set to low/high
%
% See also restrict

function y=confine(x,low,high);

y=x;
y(find(x<low))=low;
y(find(x>high))=high;
