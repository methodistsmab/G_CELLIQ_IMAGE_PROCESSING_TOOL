%function out=ext_cut(in)
%cut a string at the last '.' (removing the dot)

function out=ext_cut(in)

pos=findstr('.',in);
if isempty(pos)
	out=in;
else
	out=in(1:pos(length(pos))-1);
end
