function result = checkLogo(I)
%checkLogo checks whether a white chocolate is upside down
%
% result
% "b" -> faced up white chocolate
% "r" -> reject
%
% I:        RGB image of a masked white chocolate

ycbcr = rgb2ycbcr(I);
cr = ycbcr(:,:,3);

upperThreshold = max(cr,[],"all");
lowerThreshold = 0.9*upperThreshold;

red = cr>lowerThreshold & cr<upperThreshold;

if sum(red, "all") > 500
    result = "b";
else
    result = "r";
end
end