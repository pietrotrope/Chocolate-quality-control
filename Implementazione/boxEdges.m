function output = boxEdges(I)
%Edges extraction
%
% I needs to be downscaled before invoking box_edges -> imresize(I, 1/FACTOR)

if size(I,3) == 3
    lab=rgb2lab(I);
    b=mat2gray(lab(:,:,3));
    
    output = imfilter(b,fspecial("laplacian", 0));
    output = output > graythresh(output)*0.85;
else
   output = -1; 
end
end