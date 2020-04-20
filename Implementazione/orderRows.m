function out = orderRows(rows)
%orderRows sorts the elements of the rows in the given matrix
%
% rows:       4x6x2 double (4x6 x,y coordinates)
% out:        4x6x2 double (4x6 x,y coordinates)

%In order to sort the centers, we compute the distance of each
%center to an arbitrary point on the linear regression of
%the points in the row

if isequal(size(rows),[4 6 2]) || isequal(size(rows),[6 4 2])
    for count = 1:size(rows,1)
        Xrows = rows(count,:,1);
        Xrows = Xrows(Xrows ~= 0);
        
        Yrows = rows(count,:,2);
        Yrows = Yrows(Yrows ~= 0);
        
        yreg = [ones(length(Xrows),1) Xrows.']\Yrows.';
        
        xp = -5000;
        yp = yreg(2)*xp + yreg(1);
        
        for i = 1:size(rows,2)
            for j = i : size(rows,2)
                dist1 = sqrt((xp-rows(count,i,1))^2+(yp-rows(count,i,2))^2);
                dist2 = sqrt((xp-rows(count,j,1))^2+(yp-rows(count,j,2))^2);
                
                if dist1 > dist2
                    tmp = rows(count,i,:);
                    rows(count,i,:) = rows(count,j,:);
                    rows(count,j,:) = tmp;
                end
            end
        end
    end
    out = rows;
else
    out = -1;
end
end