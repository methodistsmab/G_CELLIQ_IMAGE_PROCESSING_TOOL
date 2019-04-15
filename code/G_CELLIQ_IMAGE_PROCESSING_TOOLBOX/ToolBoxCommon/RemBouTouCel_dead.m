function LabMat1 = RemBouTouCel_dead( LabMat)
        
        
        [rows, cols] = size( LabMat);
        MaxLab = ordfilt2( LabMat, 9, ones(3,3), 'symmetric');
        bou = MaxLab - LabMat;
%         Prop = regionprops( LabMat, 'area');
        Prop = regionprops( LabMat, 'Eccentricity', 'Area');
        Ecc = cat(1, Prop.Eccentricity);
        Area = cat(1, Prop.Area);
        
        T1 = unique( LabMat);
        T = find(Ecc > .75 | Area < 200);
        
        t1 = unique( LabMat(1:3,:));
        t2 = unique( LabMat(:,1:3));
        t3 = unique( LabMat(rows-2:rows,:));
        t4 = unique( LabMat( :, cols-2:cols));
        t5 = union( t1, t2);
        t6 = union( t3, t4);
        Tag = union( t5, t6);
        
        Tag = intersect(Tag, T); 
        
        Tag1 = setdiff( T1,Tag);
        LabMat1 = zeros( rows, cols);
        
        for i = 2:length( Tag1)
            LabMat1( LabMat == Tag1(i)) = i-1;
        end
       
       