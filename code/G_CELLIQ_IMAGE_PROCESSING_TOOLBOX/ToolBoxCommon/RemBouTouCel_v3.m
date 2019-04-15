function LabMat = RemBouTouCel_v3( LabMat)
        
        [rows, cols] = size( LabMat);
        Prop = regionprops( LabMat);
        Area = cat( 1, Prop.Area);
        
        MaxLab = ordfilt2( LabMat, 9, ones(3,3), 'symmetric');
        bou = MaxLab - LabMat;
        t0 = find(Area < 700);
        
        t1 = unique( LabMat(1:2,:));
        t2 = unique( LabMat(:,1:2));
        t3 = unique( LabMat(rows-2:rows,:));
        t4 = unique( LabMat( :, cols-2:cols));
        t5 = union( t1, t2);
        t6 = union( t3, t4);
        Tag = union( t5, t6);
        Tag = intersect( Tag, t0);
        
        for i = 2:length( Tag)
            LabMat( LabMat == Tag(i)) = 0;
        end

        LabMat = im2bw( LabMat, .5);
        LabMat( bou > 0) = 0;
        LabMat = bwlabel( LabMat);