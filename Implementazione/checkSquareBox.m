function errors = checkSquareBox(box,centers,radius,classifier)
%checkSquareBox locates the errors
% It extracts the chocolate slots from the box picture and
% checks whether they're valid or not
%
% errors:       m x 2 double (coordinates of the errors)
% box:          the original box image (full scale)
% centers:      24x2 double
% radius:       
% classifier:   chocolate classifier

errors = zeros(24,2);

for i = 1:24
    center = centers(i,:);
    rowStart = floor(center(1)-radius);
    rowEnd = floor(center(1)+radius);
    colStart = floor(center(2)-radius);
    colEnd = floor(center(2)+radius);
    
    %Since radius is the result of a mode function, the sum of center
    %coordinates and radius might not stay within the image borders
    
    if rowStart < 0; rowStart = 0; end
    if rowEnd > size(box,2); rowEnd = size(box,2); end
    if colStart < 0; colStart = 0; end
    if colEnd > size(box,1); colEnd = size(box, 1); end
    
    chocolate = box(colStart:colEnd,rowStart:rowEnd,:);
    maskedChocolate = chocolate.*createCircleMask([size(chocolate,1),size(chocolate,2)],[radius radius],radius);
    
    type = classifyChocolate(maskedChocolate, classifier);
    if type ~= "d" || countStickers(maskedChocolate)==0
        errors(i,:) = center;
    end
end
errors = errors(errors(:,1)~=0 & errors(:,2)~=0,:);
end

