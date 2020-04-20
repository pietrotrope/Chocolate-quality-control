function out = mymode(lis,div)
%mymode returns the maximum value of the range where the most frequent
%values of the list are.
%
% out:           maximum value of the most frequent range
% lis:           m x 1 double
% div:           number of ranges to create              

if size(lis,1) > 0
    lis = sort(lis);
    
    %Removing the outliers
    
    nestmin = round(size(lis,1)*0.65);
    nestmax = round(size(lis,1)*0.25);
    
    lis = lis(nestmin:(size(lis,1)-nestmax));
    
    par = zeros(div, 1);
    massimo = max(lis);
    minimo = min(lis);
    
    if massimo ~= minimo
        sens = (massimo - minimo)/div;
        
        for i = 1:size(lis,1)
            index = ceil((lis(i)-minimo)/sens);
            if index == 0
                par(1) = par(1) + 1;
            else
                par(index) = par(index) + 1;
            end
        end
        
        [a,in] = max(par(:));
        out = in*sens + minimo;
    else
        out = lis(1);
    end
else
    out = -1;
end
end