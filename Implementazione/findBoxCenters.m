function [centers,radius] = findBoxCenters(box)
%findBoxCenters finds the circumferences in a squared box
%
% box:        rgb image of the box
% centers:    m x 2 double (centers of each circumenference)
% radius:     radius of the circumferences     

if size(box,3) == 3
    first = imsharpen(adapthisteq(box(:,:,1)./0.4),'Amount',0.1);
    second = imsharpen(adapthisteq(box(:,:,2)./0.4),'Amount',0.1);
    third = 1 - box(:,:,2);
    third = adapthisteq(imadjust(third,[],[],1.5));
    
    [centers,radii] = imfindcircles(first,[11 30],'EdgeThreshold',0.2, 'Sensitivity',0.86, 'Method','TwoStage','ObjectPolarity','bright' );
    [centers2,radii2] = imfindcircles(second,[11 30],'EdgeThreshold',0.165,'Sensitivity',0.86,'Method','TwoStage','ObjectPolarity','bright');
    [centers3,radii3] = imfindcircles(third,[11 30],'EdgeThreshold',0.12,'Sensitivity',0.86,'Method','TwoStage','ObjectPolarity','dark');
    [centers4,radii4] = imfindcircles(third,[11 30],'EdgeThreshold',0.14,'Sensitivity',0.865,'Method','TwoStage','ObjectPolarity','bright');
    
    centers = cat(1,centers,centers2);
    radii = cat(1,radii,radii2);
    
    centers = cat(1,centers, centers3);
    radii = cat(1,radii,radii3);
    
    centers = cat(1,centers, centers4);
    radii = cat(1,radii,radii4);
    
    if size(radii,1) > 5
        sens = mymode(radii,6);
        radii(1:size(radii,1)) = sens;
        [centers,radii] = removeDuplicates(centers,radii,sens);
        radius = radii(1);
    else
        centers = -1;
        radius = -1;
    end
else
    centers = -1;
    radius = -1;
end