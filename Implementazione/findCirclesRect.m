function [centers,radii] = findCirclesRect(box)
%findCirclesRect finds the circumferences in a rectangular box
%
% box:        RGB image of the box
% centers:    m x 2 double (centers of each circumenference)
% radii:      m x 1 double (radius of each circumference)      

if size(box,3) == 3
    rh = rgb2hsv(box);
    ry = rgb2ycbcr(box);
    equalizedS = adapthisteq(rh(:,:,2));
    equalizedY = adapthisteq(ry(:,:,1));
    equalizedV = adapthisteq(rh(:,:,3));
    equalizedVmultiplied = adapthisteq(rh(:,:,3).*5);
    
    [centers,radii]   = imfindcircles(equalizedS,[11 25],'EdgeThreshold',0.16,'Sensitivity',0.84,'Method','TwoStage','ObjectPolarity','dark' );
    [centers2,radii2] = imfindcircles(equalizedY,[11 25],'EdgeThreshold',0.15,'Sensitivity',0.8,'Method','TwoStage');
    [centers3,radii3] = imfindcircles(equalizedV,[11 25],'EdgeThreshold',0.15,'Sensitivity',0.8,'Method','TwoStage','ObjectPolarity','dark');
    [centers4,radii4] = imfindcircles(equalizedVmultiplied,[11 25],'EdgeThreshold',0.15,'Sensitivity',0.8,'Method','TwoStage','ObjectPolarity','dark');
    centers = cat(1,centers,centers2);
    radii = cat(1,radii,radii2);
    
    centers = cat(1,centers,centers3);
    radii = cat(1,radii,radii3);
    
    centers = cat(1,centers,centers4);
    radii = cat(1,radii,radii4);
    
    if size(radii,1) > 4
        sensi = mymode(radii,5);
        radii(1:size(radii,1)) = sensi;
        [centers,radii] = removeDuplicates(centers,radii,sensi);
    else
        centers = -1;
        radii = -1;
    end
else
    centers = -1;
    radii = -1;
end
end