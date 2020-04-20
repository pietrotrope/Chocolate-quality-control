function [rows,radius] = findBoxRows(box,m)
%findCirclesRect finds the circumferences in a rectangular box and
%arranges them in a matrix
%
% box:        rgb image of the box
% m:          slope of a border of the box
% rows:       4x6x2 double (4x6 x,y coordinates)
% radius:     radius of the circumferences   

[centers,radii] = findCirclesRect(box);
if numel(centers) ~= 1
    rows = clustering(centers,radii,m);

    if size(radii,1) ~= 24
        rows = reconstruction(rows, radii);
    end
    rows = orderRows(rows);
    rows = orderCols(rows);
    if  size(rows,2) == 4
        rows = rot90(rows);
    end
    
    radius = radii(1);
else
    rows = -1;
    radius = -1;
end
end