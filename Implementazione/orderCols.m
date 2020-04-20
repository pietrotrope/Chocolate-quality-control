function out = orderCols(rows)
%orderCols sorts the rows in the given matrix
%
% rows:       4x6x2 double (4x6 x,y coordinates)
% out:        4x6x2 double (4x6 x,y coordinates)

%In order to sort the rows, we compute the distance of each
%center of the first column to an arbitrary point on the linear regression
%of the points in the column

if isequal(size(rows),[4 6 2]) || isequal(size(rows),[6 4 2])
    Xcol = rows(:,1,1);
    Ycol = rows(:,1,2);
    
    yreg = [ones(length(Xcol),1) Xcol]\Ycol;
    
    xp = -5000;
    yp = yreg(2)*xp + yreg(1);
    
    for i = 1:size(rows,1)
        for j = i:size(rows,1)
            dist1 = sqrt((xp-rows(i,1,1))^2+(yp-rows(i,1,2))^2);
            dist2 = sqrt((xp-rows(j,1,1))^2+(yp-rows(j,1,2))^2);
            
            if dist1 > dist2
                tmp = rows(i,:,:);
                rows(i,:,:) = rows(j,:,:);
                rows(j,:,:) = tmp;
            end
        end
    end
    out = rows;
else
    out = -1;
end
end