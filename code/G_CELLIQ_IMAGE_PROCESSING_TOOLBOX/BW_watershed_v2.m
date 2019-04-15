function LabMat = BW_watershed_v2( bw_img)

bg_marker = bw_img == 0;
disImg = bwdist( ~bw_img);


com_img = imcomplement( disImg);
LabMat = watershed( com_img);
        