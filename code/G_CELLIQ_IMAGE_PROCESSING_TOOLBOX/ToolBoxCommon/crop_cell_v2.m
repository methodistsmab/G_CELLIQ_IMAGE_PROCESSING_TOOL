function cell = crop_cell_v2(number,Cells,actin)

[X,Y] = find(Cells == number);
x_max = max(X(:));
x_min = min(X(:));
y_max = max(Y(:));
y_min = min(Y(:));
x = y_min;
y = x_min;
width = y_max - y_min + 1;
height = x_max - x_min + 1;
I1 = zeros(height,width);
L = Cells(y:y+height-1,x:x+width-1);
logical_temp = (L == number);
I1 = logical_temp .* actin(y:y+height-1,x:x+width-1);
Lsize = max(width,height);
d = abs(width - height);
d1 = floor(d/2);
cell = zeros(Lsize+2,Lsize+2);
if width>height
    cell(d1+2:d1+height+1,2:Lsize+1) = I1;
else
    cell(2:Lsize+1,d1+2:d1+width+1)  = I1;
end
cell = uint8(cell);