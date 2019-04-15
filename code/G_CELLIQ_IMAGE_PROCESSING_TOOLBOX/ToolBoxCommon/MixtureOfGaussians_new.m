function Threshold = MixtureOfGaussians_new(OrigImage,pObject)
%%% This function finds a suitable threshold for the input image
%%% OrigImage. It assumes that the pixels in the image belong to either
%%% a background class or an object class. 'pObject' is an initial guess
%%% of the prior probability of an object pixel, or equivalently, the fraction
%%% of the image that is covered by objects. Essentially, there are two steps.
%%% First, a number of Gaussian distributions are estimated to match the
%%% distribution of pixel intensities in OrigImage. Currently 3 Gaussian
%%% distributions are fitted, one corresponding to a background class, one
%%% corresponding to an object class, and one distribution for an intermediate
%%% class. The distributions are fitted using the Expectation-Maximization (EM)
%%% algorithm, a procedure referred to as Mixture of Gaussians modeling. When
%%% the 3 Gaussian distributions have been fitted, it's decided whether the
%%% intermediate class models background pixels or object pixels based on the
%%% probability of an object pixel 'pObject' given by the user.

%%% If the image was produced using a cropping mask, we do not
%%% want to include the Masked part in the calculation of the
%%% proper threshold, because there will be many zeros in the
%%% image.  So, we check to see whether there is a field in the
%%% handles structure that goes along with the image of interest.

%%% The number of classes is set to 3
NumberOfClasses = 3;

%%% Transform the image into a vector. Also, if the image is (larger than 512x512),
%%% select a subset of 512^2 pixels for speed. This should be enough to capture the
%%% statistics in the image.
Intensities = OrigImage(:);
if length(Intensities) > 512^2
    indexes = randperm(length(Intensities));
    Intensities = Intensities(indexes(1:512^2));
end

%%% Get the probability for a background pixel
pBackground = 1 - pObject;

%%% Initialize mean and standard deviations of the three Gaussian distributions
%%% by looking at the pixel intensities in the original image and by considering
%%% the percentage of the image that is covered by object pixels. Class 1 is the
%%% background class and Class 3 is the object class. Class 2 is an intermediate
%%% class and we will decide later if it encodes background or object pixels.
%%% Also, for robustness the we remove 1% of the smallest and highest intensities
%%% in case there are any quantization effects that have resulted in unaturally many
%%% 0:s or 1:s in the image.
Intensities = sort(Intensities);
Intensities = Intensities(round(length(Intensities)*0.01):round(length(Intensities)*0.99));
ClassMean(1) = Intensities(round(length(Intensities)*pBackground/2));                      %%% Initialize background class
ClassMean(3) = Intensities(round(length(Intensities)*(1 - pObject/2)));                    %%% Initialize object class
ClassMean(2) = (ClassMean(1) + ClassMean(3))/2;                                            %%% Initialize intermediate class
%%% Initialize standard deviations of the Gaussians. They should be the same to avoid problems.
ClassStd(1:3) = 0.15;
%%% Initialize prior probabilities of a pixel belonging to each class. The intermediate
%%% class is gets some probability from the background and object classes.
pClass(1) = 3/4*pBackground;
pClass(2) = 1/4*pBackground + 1/4*pObject;
pClass(3) = 3/4*pObject;

%%% Apply transformation.  a < x < b, transform to log((x-a)/(b-x)).
%a = - 0.000001;
%b = 1.000001;
%Intensities = log((Intensities-a)./(b-Intensities));
%ClassMean = log((ClassMean-a)./(b - ClassMean))
%ClassStd(1:3) = [1 1 1];

%%% Expectation-Maximization algorithm for fitting the three Gaussian distributions/classes
%%% to the data. Note, the code below is general and works for any number of classes.
%%% Iterate until parameters don't change anymore.
delta = 1;
while delta > 0.001
    %%% Store old parameter values to monitor change
    oldClassMean = ClassMean;

    %%% Update probabilities of a pixel belonging to the background or object1 or object2
    for k = 1:NumberOfClasses
        pPixelClass(:,k) = pClass(k)* 1/sqrt(2*pi*ClassStd(k)^2) * exp(-(Intensities - ClassMean(k)).^2/(2*ClassStd(k)^2));
    end
    pPixelClass = pPixelClass ./ repmat(sum(pPixelClass,2) + eps,[1 NumberOfClasses]);

    %%% Update parameters in Gaussian distributions
    for k = 1:NumberOfClasses
        pClass(k) = mean(pPixelClass(:,k));
        ClassMean(k) = sum(pPixelClass(:,k).*Intensities)/(length(Intensities)*pClass(k));
        ClassStd(k)  = sqrt(sum(pPixelClass(:,k).*(Intensities - ClassMean(k)).^2)/(length(Intensities)*pClass(k))) + sqrt(eps);    % Add sqrt(eps) to avoid division by zero
    end

    %%% Calculate change
    delta = sum(abs(ClassMean - oldClassMean));
end

%%% Now the Gaussian distributions are fitted and we can describe the histogram of the pixel
%%% intensities as the sum of these Gaussian distributions. To find a threshold we first have
%%% to decide if the intermediate class 2 encodes background or object pixels. This is done by
%%% choosing the combination of class probabilities 'pClass' that best matches the user input 'pObject'.
Threshold = linspace(ClassMean(1),ClassMean(3),10000);
Class1Gaussian = pClass(1) * 1/sqrt(2*pi*ClassStd(1)^2) * exp(-(Threshold - ClassMean(1)).^2/(2*ClassStd(1)^2));
Class2Gaussian = pClass(2) * 1/sqrt(2*pi*ClassStd(2)^2) * exp(-(Threshold - ClassMean(2)).^2/(2*ClassStd(2)^2));
Class3Gaussian = pClass(3) * 1/sqrt(2*pi*ClassStd(3)^2) * exp(-(Threshold - ClassMean(3)).^2/(2*ClassStd(3)^2));
if abs(pClass(2) + pClass(3) - pObject) < abs(pClass(3) - pObject)
    %%% Intermediate class 2 encodes object pixels
    BackgroundDistribution = Class1Gaussian;
    ObjectDistribution = Class2Gaussian + Class3Gaussian;
else
    %%% Intermediate class 2 encodes background pixels
    BackgroundDistribution = Class1Gaussian + Class2Gaussian;
    ObjectDistribution = Class3Gaussian;
end

%%% Now, find the threshold at the intersection of the background distribution
%%% and the object distribution.
[ignore,index] = min(abs(BackgroundDistribution - ObjectDistribution)); %#ok Ignore MLint
Threshold = Threshold(index);
