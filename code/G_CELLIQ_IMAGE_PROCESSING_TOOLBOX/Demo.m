InputPath = 'Input';
OutputPath = 'Output';

RNAi_Seg_Fea(InputPath, OutputPath);

SegPath=[OutputPath,'/resSeg'];

Dir_SegPath=dir(SegPath);
for i=1:length(Dir_SegPath)
    this_name=Dir_SegPath(i).name;
    this_seg=strfind(this_name,'seg');
    if length(this_seg)>0
        this_path=[SegPath,'/',this_name];
        RNAi_FeaExt_col_skipExist(this_path, this_path);
    end
end