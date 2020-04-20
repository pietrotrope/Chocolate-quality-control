function output = boxMask(edges)
%boxMask masks the box and cleans up the image (external objects are
%removed

    output = imdilate(edges, strel("disk", 2));
    output = imfill(output, 'holes');
    output = bwareafilt(output, 1);
    output = bwconvhull(output);
    
% output needs to be upscaled by FACTOR after invoking boxMask -> imresize(output,FACTOR);
end

