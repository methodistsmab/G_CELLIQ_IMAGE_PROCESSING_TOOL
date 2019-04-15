function cell = crop_col_cell(number,Cells,actin)
            
%             actin = 255*mat2gray( actin);
            [X,Y] = find(Cells == number);
            x_max = max(X(:));
            x_min = min(X(:));
            y_max = max(Y(:));
            y_min = min(Y(:));
            x = y_min;
            y = x_min;
            width = y_max - y_min + 1;
            height = x_max - x_min + 1;
            I1 = zeros(height,width,3);
            L = Cells(y:y+height-1,x:x+width-1);
            logical_temp = (L == number);
            I1(:,:,1) = logical_temp .* actin(y:y+height-1,x:x+width-1,1);
            I1(:,:,2) = logical_temp .* actin(y:y+height-1,x:x+width-1,2);
            I1(:,:,3) = logical_temp .* actin(y:y+height-1,x:x+width-1,3);
            Lsize = max(width,height);
            d = abs(width - height);
            d1 = floor(d/2);
            
            
            %%% scale the size of the cells are odd length
            if mod( Lsize, 2) == 0
                cell = zeros(Lsize+1,Lsize+1,3);
                if width>height
                    cell(d1+1:d1+height,1:Lsize,:) = I1;
                else
                    cell(1:Lsize,d1+1:d1+width,:)  = I1;
                end            
            else                
                cell = zeros(Lsize +2, Lsize + 2,3);
                if width>height
                    cell(d1+2:d1+height+1,2:Lsize+1,:) = I1;
                else
                    cell(2:Lsize+1,d1+2:d1+width+1,:)  = I1;
                end
            end
%             cell = uint8( cell);
            %cell = uint16(cell);            