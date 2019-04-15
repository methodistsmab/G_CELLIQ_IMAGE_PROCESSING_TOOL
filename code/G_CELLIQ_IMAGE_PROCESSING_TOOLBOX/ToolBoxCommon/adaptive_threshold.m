function [bwImg, Threshold] = adaptive_threshold( OrigImage)
    
    %path( 'C:\fhl\RNAi_sys\threshold\', path);
    %%% Choose the block size that best covers the original image in the sense
    %%% that the number of extra rows and columns is minimal.
    %%% Get size of image
    [m,n] = size(OrigImage);
    %%% Deduce a suitable block size based on the image size and the percentage of image
    %%% covered by objects. We want blocks to be big enough to contain both background and
    %%% objects. The more uneven the ratio between background pixels and object pixels the
    %%% larger the block size need to be. The minimum block size is about 50x50 pixels.
    %%% The line below divides the image in 10x10 blocks, and makes sure that the block size is
    %%% at least 50x50 pixels.
    BlockSize = max(30,min(round(m/10),round(n/10)));

    %%% Calculates a range of acceptable block sizes as plus-minus 10% of the sug gested block size.
    BlockSizeRange = floor(1.1*BlockSize):-1:ceil(0.9*BlockSize);
    [ignore,index] = min(ceil(m./BlockSizeRange).*BlockSizeRange-m + ceil(n./BlockSizeRange).*BlockSizeRange-n); %#ok Ignore MLint
    BestBlockSize = BlockSizeRange(index);
    
    %%% the bestblocksize is that add at least the rows and columns
    %%% Pads the image so that the blocks fit properly.
    RowsToAdd = BestBlockSize*ceil(m/BestBlockSize) - m;
    ColumnsToAdd = BestBlockSize*ceil(n/BestBlockSize) - n;
    RowsToAddPre = round(RowsToAdd/2);
    RowsToAddPost = RowsToAdd - RowsToAddPre;
    ColumnsToAddPre = round(ColumnsToAdd/2);
    ColumnsToAddPost = ColumnsToAdd - ColumnsToAddPre;
    PaddedImage = padarray(OrigImage,[RowsToAddPre ColumnsToAddPre],'replicate','pre');
    PaddedImage = padarray(PaddedImage,[RowsToAddPost ColumnsToAddPost],'replicate','post');

    %%% Calculates the threshold for each block in the image, and a global threshold used
    %%% to constrain the adaptive threshholds.
    
    %GlobalThreshold = CPgraythresh_1(OrigImage);
    %Threshold = blkproc(PaddedImage,[BestBlockSize BestBlockSize],@CPgraythresh);
    GlobalThreshold = graythresh(OrigImage);
    Threshold = blkproc(PaddedImage,[BestBlockSize BestBlockSize],@graythresh);
    %%% Resizes the block-produced image to be the size of the padded image.
    %%% Bilinear prevents dipping below zero. The crop the image
    %%% get rid of the padding, to make the result the same size as the original image.
    
    Threshold = imresize(Threshold, size(PaddedImage), 'bilinear');
    Threshold = Threshold(RowsToAddPre+1:end-RowsToAddPost,ColumnsToAddPre+1:end-ColumnsToAddPost);

    %%% For any of the threshold values that is lower than the user-specified
    %%% minimum threshold, set to equal the minimum threshold.  Thus, if there
    %%% are no objects within a block (e.g.6cells are very sparse), an
    %%% unreasonable threshold will be overridden by the minimum threshold.
    Threshold(Threshold <= 0.7*GlobalThreshold) = 0.7*GlobalThreshold;
    Threshold(Threshold >= 1.6*GlobalThreshold) = min( 1.6*GlobalThreshold, 1);
    
    bwImg = (OrigImage > Threshold);

    
   
    

function level = CPgraythresh(varargin)
%%% This is the Otsu method of thresholding.

if nargin == 1
    im = varargin{1};
else
    im = varargin{1};
    handles = varargin{2};
    ImageName = varargin{3};
    %%% If the image was produced using a cropping mask, we do not
    %%% want to include the Masked part in the calculation of the
    %%% proper threshold, because there will be many zeros in the
    %%% image.  So, we check to see whether there is a field in the
    %%% handles structure that goes along with the image of interest.
    fieldname = ['CropMask', ImageName];
    if isfield(handles.Pipeline,fieldname)
        %%% Retrieves previously selected cropping mask from handles
        %%% structure.
        BinaryCropImage = handles.Pipeline.(fieldname);
        if numel(im) == numel(BinaryCropImage)
            %%% Masks the image and I think turns it into a linear
            %%% matrix.
            im = im(logical(BinaryCropImage));
        end
    end
end

%%% The threshold is calculated using the matlab function graythresh
%%% but with our modifications that work in log space, and take into
%%% account the max and min values in the image.
im = double(im(:));
if max(im) == min(im),
    level = im(1);
else
    %%% We want to limit the dynamic range of the image to 256.
    %%% Otherwise, an image with almost all values near zero can give a
    %%% bad result.
    minval = max(im)/256;
    im(im < minval) = minval;
    im = log(im);
    minval = min (im);
    maxval = max (im);
    im = (im - minval) / (maxval - minval);
    level = exp(minval + (maxval - minval) * graythresh(im));
    %disp(strcat('level',num2str(level)));
end