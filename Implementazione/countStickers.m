function count = countStickers(I)
%countStickers gets the number of stickers attached to a golden piece of
%chocolate
%
% I: RGB image representing a piece of Ferrero Rocher after applying a
% circular mask.

if size(I,3) == 3
    I = im2double(I);
    
    % Stickers are clearly visible through the third lab channel, through
    % the saturation channel and the blue channel
    
    lab = rgb2lab(I);
    hsv = rgb2hsv(I);
    
    b = mat2gray(lab(:,:,3));
    b = b <= graythresh(b);
    
    s = hsv(:,:,2);
    s = s <= graythresh(s);
    
    blue = I(:,:,3);
    blue  = blue >= graythresh(blue);
    
    andChannels = b & s & blue;
    
    andChannels = imerode(andChannels, strel("disk",5));
    andChannels = imdilate(andChannels, strel("disk",20));
    andChannels = imerode(andChannels, strel("disk",4));
    
    %There might still be spurious objects which need not to be considered,
    %so we filter them by their area
    count = size(nonzeros([regionprops(andChannels,"area").Area]>800),1);
else
    count = -1;
end
end

