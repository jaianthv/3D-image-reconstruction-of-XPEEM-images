%%
% To choose the points which moved from the reference image
h  = cpselect('fixed.png','moving.png');
%%
% Close the tool.
close(h)
%%
moving = imread('moving_image.png');
fixed = imread('fixed_image.png');
moving = im2double(moving);
fixed = im2double(fixed);


%%
%Perform appropriate transformation using fitgeotrans function
% Fot other types of transformation check the link
% https://ch.mathworks.com/help/images/ref/fitgeotrans.html
tform = fitgeotrans(fixedPoints,movingPoints,'affine');

% refers image coordinate into world coordinates
ref = imref2d(size(fixed));

% Transformed image resized in the same dimension as the world coordinates
moving_image_registered = imwarp(moving,tform,'OutputView',ref);

% Displays figure with distortion corrected image with reference image
figure, imshowpair(fortyfivedeg_registered,fixed,'blend')

%%

mkdir corrected
cd corrected




   baseFileName = sprintf('corrected_AVG_i170726_055_Corr_C+_90D.png');
   %fullFileName = fullfile(Resultados, baseFileName);
   %filename = sprintf('cropped image_srcFiles.name',i)
   imwrite(fortyfivedeg_registered,baseFileName);
   %imwrite(I,baseFileName);
   %imwrite(A,map,filename,'gif','LoopCount',Inf,'DelayTime',1)

cd ..
