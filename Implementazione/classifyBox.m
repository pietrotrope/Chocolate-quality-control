function type = classifyBox(rotatedMask,classifier)
%classifyBox
%
% square -> "q"
% rectangle -> "r"
%
% rotatedMask:  approximation of the box, previously masked and
% rotated on one side.
% classifier:   box shape classifier
% The features used area the elongation (ratio of the bounding box sides)
% and the compactness.

st = regionprops(rotatedMask, "BoundingBox");
perim = bwperim(rotatedMask,8).*rotatedMask;
perim = sum(perim, "all");

if perim > 0
    area = sum(rotatedMask, "all");
    compactness = 4*pi*area/perim^2;
    
    min_edge = min(st.BoundingBox(3),st.BoundingBox(4));
    max_edge = max(st.BoundingBox(3),st.BoundingBox(4));
    
    if min_edge > 0
        elongation = max_edge/min_edge;
        
        features = array2table([elongation compactness]);
        
        type = string(classifier.predictFcn(features));
    else
        type = -1;
    end
else
    type = -1;
    
end

