% Fuhai Li, robert.fh.li@gmail.com  Mar,25, 2008.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [filename, nframes] = imgseq_index_v2(directory_name, imgType)

dirname = strcat(directory_name, '\'); 
if strcmp(imgType, '.tif')
    imgT1 = '.TIF';
elseif strcmp(imgType, '.jpg')
    imgT1 = '.JPG';
elseif strcmp(imgType, '.png')
    imgT1 = '.PNG';
elseif strcmp(imgType, '.bmp')
    imgT1 = '.BMP';
end

open_dir = dir(strcat(dirname, '*', imgType));                % open a directory
n_images = length(open_dir);                   % the number of files in the directory
if n_images < 1
    open_dir = dir( strcat( dirname, '*', imgT1));
    n_images = length(open_dir);
    if n_images < 1
            filename = [];
            nframes = 0;
            return;
    end
end
nframes = 0;       % a temporary counter to count the number of tiff pictures in the directory

lenNam = 0;

for i = 1:n_images
   lenNam = max(lenNam, length(open_dir(i).name));         % combine the directory name with the file name, then we get eg: c:\...\file.tif
end 
Renames = char(zeros(n_images, lenNam)+45); %%%we will pad '-' before image name to keep them have same length.

for i = 1:n_images   
    nameT = open_dir(i).name;
    lenT = length(nameT);
    if lenT < lenNam 
        %%%1. read image
        img = imread(strcat(dirname, nameT));
        %%%delete image
        delete(strcat(dirname, nameT));
        %%write image    
        Renames(i, (lenNam-lenT+1):lenNam) = nameT;
        imgFile = strcat(dirname, Renames(i,:));
        imwrite(img, imgFile);        
    else
%         Renames(i,:) = nameT;
        imgFile = strcat(dirname, nameT);
    end
%     filename(i, (lenNam-lenT+1):lenNam) = nameT;
    nframes = nframes+1;
    % number of valid frames in this directory
    % dirname = strcat(directory_name, '\');               % combine the directory name with "\"
    filename(nframes,:) = imgFile;         % combine the directory name with the file name, then we get eg: c:\...\file.tif
end


