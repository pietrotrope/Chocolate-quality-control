function out = reconstruction(rows,radii)
%reconstruction estimates the position of the missing circumferences.
%A circumference is considered missing if it's centered in the origin.
%The intersection between the linear regression of the points of the row
%and the line perpendicular to it passing through a center of the
%other rows gives us a good approximation of the missing center coordinates
%
% rows:     4x6x2 double (4x6 x,y coordinates)
% radii:    m x 1 double (radius of each circumference)
% out:      4x6x2 double (4x6 x,y coordinates)

for i = 1 : size(rows,1)
    %Perform linear regression of the centers of the
    %row whose missing elements we want to reconstruct
    
    Xrow = rows(i,:,1);
    Xrow = Xrow(Xrow ~= 0);
    Yrow = rows(i,:,2);
    Yrow = Yrow(Yrow ~= 0);
    yreg = [ones(length(Xrow),1) Xrow.']\Yrow.';
    
    %For each other row, for each center, find the perpendicular line
    %passing through the center and perpendicular to the previously 
    %computed line to get the point resulting from the intersection of
    %the two lines
    
    for k = 1 : size(rows,1)
        if k ~= i
            for j = 1 : size(rows,2)
                xreg = [0 0];
                xreg(1) = rows(k,j,2) + (1/yreg(2))*rows(k,j,1);
                xreg(2) = -(1/yreg(2));
                point = [0 0];
                point(1) = (yreg(1) - xreg(1))/(xreg(2)-yreg(2));
                point(2) = xreg(2) * point(1) + xreg(1);
                
                %If there isn't yet any center near the point, add it
                %to the list of centers of the cluster
                
                found = false;
                for z = 1 : size(rows,2)
                    dist = sqrt((point(1)-rows(i,z,1))^2+(point(2)-rows(i,z,2))^2);
                    if dist < radii(1) && ~found
                        found = true;
                    end
                end
                if ~found
                    tmp = rows(i,:,1);
                    if ~ isnan(tmp)
                        fz = find(~logical(tmp));
                        if size(fz,2) > 0
                            rows(i,fz(1),:) = [point(1); point(2)];
                        end
                    end
                end
            end
        end
    end
end
out = rows;
end