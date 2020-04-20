function config = rowsToConfig(box,rows,radius,classifier)
%rowsToConfig produces the representation of the box configuration
%
% config:       4x6 string (possible values {"b","d","n","r"})
% box:          the original box image (full scale)
% rows:         4x6x2 double (4x6 x,y coordinates)
% radius:
% classifier:   chocolate classifier

config = strings(4,6);
error = false;
if size(box,3) == 3 && isequal(size(rows),[4 6 2])
    for i = 1:4
        for j = 1:6
            center = [rows(i,j,1) rows(i,j,2)];
            if ~isnan(center(1)) && ~isnan(center(2))
                rowStart = ceil(center(1)-radius);
                rowEnd = ceil(center(1)+radius);
                colStart = ceil(center(2)-radius);
                colEnd = ceil(center(2)+radius);
                
                %Since radius is the result of a mode function, the sum of center
                %coordinates and radius might not stay within the image borders
                
                if rowStart < 0; rowStart = 1; end
                if rowEnd > size(box,2); rowEnd = size(box,2); end
                if colStart < 0; colStart = 1; end
                if colEnd > size(box,1); colEnd = size(box, 1); end
                
                chocolate = box(colStart:colEnd,rowStart:rowEnd,:);
                mask = createCircleMask([size(chocolate,1) size(chocolate,2)],[radius radius],radius);
                maskedChocolate = chocolate.*mask;
                
                type = classifyChocolate(maskedChocolate,classifier);
                if type == "b"; type = checkLogo(maskedChocolate); end
                config(i,j) = type;
            else
                error = true;
            end
        end
    end
end
if error
    config = -1;
end
end