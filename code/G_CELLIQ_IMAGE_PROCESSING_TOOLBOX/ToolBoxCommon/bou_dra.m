function bou_img = bou_dra(raw_img, seg_img)    
        
        Dim = size( raw_img);
        if length(Dim) == 2
            raw_img = mat2gray( raw_img);
            MaxCells = ordfilt2(seg_img,9,ones(3,3),'symmetric');
%         MaxCells = ordfilt2(MaxCells1,9,ones(3,3),'symmetric');
%         bou = (MaxCells - MaxCells1); 
            bou = (MaxCells - seg_img);
            [rows, cols] = size(seg_img);
            bou_img = zeros(rows,cols,3);
            tem_img = raw_img;
            bw = bou>0;
            bou_img(:,:,2) = raw_img.*~bw;            
            bou_img(:,:,1) = tem_img.*~bw + bw;
            bou_img(:,:,3) = raw_img.*~bw;
        elseif length(Dim) == 3            
%             raw_img = mat2gray( raw_img);
            MaxCells = ordfilt2(seg_img,9,ones(3,3),'symmetric');
            bou = (MaxCells - seg_img)>0;            
            [rows, cols] = size(seg_img);
            bou_img = zeros(rows,cols,3);
            bou_img(:,:,1) = raw_img(:,:,1).*~bou + bou;            
            bou_img(:,:,2) = raw_img(:,:,2).*~bou + bou;
            bou_img(:,:,3) = raw_img(:,:,3).*~bou + bou;
        end            
            