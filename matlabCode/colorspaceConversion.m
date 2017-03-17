clear all
close all;


%% all conversion matrices we need

LINEAR2XYZ = [[0.4125, 0.3576, 0.1804] 
              [0.2127, 0.7152, 0.0722] 
              [0.0193, 0.1192, 0.9502]];
          
XYZ2LINEAR = [[ 3.2405, -1.5372, -0.4985] 
              [-0.9693,  1.8760,  0.0416] 
              [ 0.0556, -0.2040,  1.0573]];  %%alt: take inverse with matlab
          
%normalized to D65 (from Wikipedia article LMS color space)
XYZ2LMS = [[ 0.4002, 0.7076, -0.0808]
           [-0.2263, 1.1653,  0.0457]
           [ 0     , 0     ,  0.9182]];

LMS2XYZ = inv(XYZ2LMS);

LINEAR2LMS = XYZ2LMS * LINEAR2XYZ ;
LMS2LINEAR = XYZ2LINEAR * LMS2XYZ ;



%% do the conversion
%read img to double
rgb_img = im2double(imread('apples.jpg'));

%srbg to linear
linear_rgb = srgb2linear(rgb_img);

%%%%%%%%%%%% THIS IS FOR THE PROTANOPE CASE %%%%%%%%%%%%%%%%%%%
% here do r_hat = M^(-1)* S * M *r -  M^(-1) *t

% user position in the range [-3, 3]
x = 2;
y = 2;

%shear matrix
S = [[ 1, 0, 0]
     [ x, 1, 0]
     [ y, 0, 1]];
 
t = [0 sl*x sl*y]'; % sl to be defined!

%transorm the resulting linear rgb back to (nonlinear) srgb
srgb = linear2srgb(linear_rgb);


%% small sanity check
figure
subplot 311
imshow(rgb_img)
subplot 312
imshow(srgb2linear(rgb_img))
subplot 313
imshow(linear2srgb(srgb2linear(rgb_img)))

