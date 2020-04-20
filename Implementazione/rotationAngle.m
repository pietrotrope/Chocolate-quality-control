function [angle,m]= rotationAngle(edges)
%rotationAngle returns the angle between the strongest edge detected and
%the horizontal axis
%
% angle:
% m:        slope of the edge detected

[H,T,R] = hough(edges);
P  = houghpeaks(H,1);
lines = houghlines(edges,T,R,P,'FillGap',5,'MinLength',7);

if size(lines,2) > 0
    m = (lines(1).point1(2)-lines(1).point2(2))/(lines(1).point1(1)-lines(1).point2(1));
    angle = -atan(m)*180/pi;
else
    angle = [];
    m = [];
end
end

