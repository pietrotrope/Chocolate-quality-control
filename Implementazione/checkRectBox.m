function errors = checkRectBox(box,rows,radius,boxConfig)
%checkRectBox locates the errors
% It works by checking whether the box configuration is valid or not
%
% errors:       m x 2 double (coordinates of the errors)
% box:          the original box image (full scale)
% rows:         4x6x2 double (4x6 x,y coordinates)
% centers:      24x2 double
% radius:
% boxConfig:    4x6 string (possible values {"b","d","n","r"})

%There can be two possible configurations, depending on the box orientation
%So we choose the one that minimizes the number of errors
if size(box,3) == 3 && ...
   isequal(size(rows),[4 6 2]) && isequal(size(boxConfig),[4 6])
    differences1 = boxConfig ~= ...
        ["b","b","b","b","b","b"; ...
        "d","d","d","d","d","d"; ...
        "d","d","d","d","d","d"; ...
        "n","n","n","n","n","n"];
    differences2 = boxConfig ~= ...
        ["n","n","n","n","n","n"; ...
        "d","d","d","d","d","d"; ...
        "d","d","d","d","d","d"; ...
        "b","b","b","b","b","b"];
    
    if sum(differences1, "all") < sum(differences2, "all")
        errors = differences1;
    else
        errors = differences2;
    end
    
    %The two central rows should be made of golden pieces, so it needs to check
    %whether they have the sticker upon them
    for i = 2:3
        for j = 1:6
            if errors(i,j) == 0
                center = [rows(i,j,1) rows(i,j,2)];
                rowStart = floor(center(1)-radius);
                rowEnd = floor(center(1)+radius);
                colStart = floor(center(2)-radius);
                colEnd = floor(center(2)+radius);
                chocolate = box(colStart:colEnd,rowStart:rowEnd,:);
                
                mask = createCircleMask([size(chocolate,1) size(chocolate,2)],[radius radius],radius);
                maskedChocolate = chocolate.*mask;
                
                if countStickers(maskedChocolate) == 0
                    errors(i,j) = 1;
                end
            end
        end
    end
    errors = reshape(errors.*rows,[24 2]);
    errors = errors(errors(:,1)~=0 & errors(:,2)~=0,:);
    if isempty(errors); errors = []; end
else
    errors = -1;
end
end