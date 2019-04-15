%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% read a sequence of images 
% store the names of the image sequence into a vector named "filename"
% if you want to open the ith image, just use "imread(filename(i,:))"
% please make sure there are no other files in the directory of the images!!!!!!
%
% input: directory_name -- the full name of directory in which the images stored on harddisk 
% output: filename -- a matrix of chars store the name of image sequence 
%         nframes -- number of images in this folder
% Jun Yan
% fuhai adjusted .. Dec, 3, 2006.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [filename, nframes] = imgseq_index(directory_name)

dirname = strcat(directory_name, '\'); 
open_dir = dir(strcat(dirname, '*.tif'));                % open a directory
n_images = length(open_dir);                   % the number of files in the directory
if n_images < 1
    open_dir = dir( strcat( dirname, '*.TIF'));
    n_images = length(open_dir);
    if n_images < 1
        open_dir = dir( strcat( dirname, '*.mat'));
        n_images = length(open_dir);
        if n_images < 1
            filename = [];
            nframes = 0;
            return;
    
        end
    end
end
nframes = 0;                                   % a temporary counter to count the number of tiff pictures in the directory

for i = 1:n_images
%           open_dir(i).name    ;                                  % display the file names in this directory
%       if strcmp(open_dir(i).name, '.')  continue; end       % make sure to read true files in this directory
%       if strcmp(open_dir(i).name, '..') continue; end       % make sure to read true files in this directory
      nframes = nframes+1;                                  % number of valid frames in this directory
      %dirname = strcat(directory_name, '\');               % combine the directory name with "\"
      filename(nframes,:) = strcat(dirname, open_dir(i).name);         % combine the directory name with the file name, then we get eg: c:\...\file.tif
end

