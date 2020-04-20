function [result,errors] = isBoxValid(I,FACTOR,boxClassifier,chocolateClassifier)
%isBoxValid checks whether the box is valid or not
% result
% 0         -> nonvalid box
% 1         -> valid box
% errors
% -1        -> an error occurred during the processing
% m x 2     -> centers of the anomalies
%
% I:                    RGB image of a box
% FACTOR:               downscaling factor (use FACTOR=8.
%                       It depends on the picture size, on the box size
%                       and on the perspective)
% boxClassifier:        box shape classifier
% chocolateClassifier:  chocolate classifier

result = -1;
errors = [];

if size(I,3) == 3 && FACTOR > 0 && ...
        mod(size(I,1),FACTOR) == 0 && mod(size(I,2),FACTOR) == 0
    I = im2double(I);
    
    %Downscaling the image results in cleaning the image from spurious
    %edges due to the background
    
    I_downscaled = imresize(I, 1/FACTOR);
    
    edges = boxEdges(I_downscaled);
    
    mask = boxMask(edges);
    
    maskedDownscaled = I_downscaled.*mask;
    mask = imresize(mask,FACTOR);
    
    [angle,m] = rotationAngle(edges);
    
    if ~isempty(angle) && ~isempty(m)
        rotatedMask = imrotate(mask,-angle,"nearest","loose");
        
        imshow(I);
        
        boxShape = classifyBox(rotatedMask,boxClassifier);
        if boxShape == "r"
            [rows, radius] = findBoxRows(maskedDownscaled,m);
            if numel(rows) ~= 1
                radius = radius*8;
                rows = rows*8;
                config = rowsToConfig(I,rows,radius,chocolateClassifier);
                if numel(config) ~= 1
                    errors = checkRectBox(I,rows,radius,config);
                else
                    errors = -1;
                end
            else
                errors = -1;
%                 disp("no rows scatola rett");
            end
        elseif boxShape == "q"
            [centers, radius] = findBoxCenters(maskedDownscaled);
            
            if size(centers,1) == 24
                centers = centers*FACTOR;
                radius= radius*FACTOR;
                errors = checkSquareBox(I,centers,radius,chocolateClassifier);
            else
                errors = -1;
%                 disp("no centers scatola q");
            end
        else
            errors = -1;
%             disp("error shape");
        end
        
        %Displaying errors
        if numel(errors) ~= 1
            for i=1:size(errors,1)
                viscircles(errors(i,:),radius, 'color', 'r');
            end
            if size(errors,1) > 0
                result = 0;
                disp("non conforme");
            else
                result = 1;
                disp("conforme");
            end
        end
    else
        errors = -1;
%         disp("empty angle empty m");
    end
else
   errors = -1;
%    disp("size o factor");
end
if errors == -1
%     disp(">Errors in finding chocolate");
    result = 0;
    disp("non conforme");
end
end