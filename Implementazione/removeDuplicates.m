function [out1,out2] = removeDuplicates(centers,radii,sensi)
%removeDuplicates removes repeated occurrences of each circumference
%
% centers:       m x 2 double (coordinates of each circumference)
% radii:         m x 1 double (radius of each circumference)
% sensi:         maximum distance between centers to be considered as
%                repetead occurrence
% out1:          n x 2 double (coordinates of each distinct circumference)
% out2:          n x 1 double (radius of each distinct circumference)

if size(radii,1) == size(centers,1) && size(radii,1)>1
    tmpCenters = zeros(size(radii,1),2);
    tmpRadii = zeros(size(radii,1));
    count = 1;
    for i = 1:size(radii,1)
        bool = true;
        for  j = 1: count
            
            %If the distance between the 2 centers is < sensi the associated
            %circumferences are considered 2 different circumferences
            
            if sqrt((centers(i,1) -tmpCenters(j,1))^2 + (centers(i,2)-tmpCenters(j,2))^2) < sensi
                bool = false;
            end
        end
        if bool
            tmpCenters(count,1) = centers(i,1);
            tmpCenters(count,2) = centers(i,2);
            tmpRadii(count) = radii(i);
            count = count + 1;
        end
    end
    
    tmpCenters = tmpCenters(any(tmpCenters,2),:);
    tmpRadii = tmpRadii(tmpRadii~=0);
    
    out1 = tmpCenters;
    out2 = tmpRadii;
else
    out1 = centers;
    out2 = radii;
end
end