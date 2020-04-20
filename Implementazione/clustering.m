function out = clustering(centers,radii,m)
%clustering splits the circumeferences in 4 or 6 clusters,
%depending on the edge used to compute m
%
% centers:    m x 2 double (centers of the circumferences)
% radii:      radius of each circumference
% m:          slope of an edge of the box
% out:        4x6x2 double (4x6 x,y coordinates)

tmpCenters = centers;
rows = zeros(6,6,2);
support = zeros(6,1);
count = 1;

for i = 1 : size(tmpCenters,1)
    dist = abs(m*tmpCenters(i,1) - tmpCenters(i,2) - 5000)/sqrt(m^2 + 1);
    notfound = true;
    counter = 0;
    while notfound && counter < count
        counter = counter + 1;
        if abs(dist - support(counter)) < radii(1)
            
            notfound = false;
        end
    end
    if notfound
        rows(count,1,:) = tmpCenters(i,:);
        support(count) = dist;
        if count < 6
            count = count + 1;
        end
    else
        support(counter) = (support(counter) + dist)/2;
        firstZeroIndex = find(rows(counter,:,1) == 0);
        if size(firstZeroIndex,2)>0
            rows(counter, firstZeroIndex(1),:) = tmpCenters(i,:);
        end
    end
end

if all(rows(5,1,:) == 0)
    rows = rows(1:4,:,:);
else
    rows = rows(:,1:4,:);
end
out = rows;
end