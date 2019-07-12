function [L] = getDistance(tetNeighbour,tetNeighbour2)
% Gets the distance between neighbouring tetrahedrons
% Tetrahedron 1
% Nodes
% Coordinates
load('mesh.mat');
Nodes1 = zeros(4,1);
Nodes2 = zeros(4,1);
coordsOfNodes1 = zeros(3,4);
coordsOfNodes2 = zeros(3,4);
if tetNeighbour == 0
    % tetrahedron is on the boundary
    L = 0;
    return;
else 
    Nodes1 = simp(tetNeighbour,:)';
    for i = 1:4
        coordsOfNodes1(:,i) = vtx(Nodes1(i,1),:);
    end
    x1 = coordsOfNodes1(1,1);y1 = coordsOfNodes1(2,1);z1 = coordsOfNodes1(3,1);
    x2 = coordsOfNodes1(1,2);y2 = coordsOfNodes1(2,2);z2 = coordsOfNodes1(3,2);
    x3 = coordsOfNodes1(1,3);y3 = coordsOfNodes1(2,3);z3 = coordsOfNodes1(3,3);
    x4 = coordsOfNodes1(1,4);y4 = coordsOfNodes1(2,4);z4 = coordsOfNodes1(3,4);
    
    % Find midpoint of tetrahedron 1
    mid1 = [(x1+x2+x3+x4)/4;(y1+y2+y3+y4)/4;(z1+z2+z3+z4)/4;];
    % Tetrahedron 2
    % Nodes
    % Coordinates
    Nodes2 = simp(tetNeighbour2,:)';
    for i = 1:4
        coordsOfNodes2(:,i) = vtx(Nodes2(i,1),:);
    end
    x1L = coordsOfNodes2(1,1);y1L = coordsOfNodes2(2,1);z1L = coordsOfNodes2(3,1);
    x2L = coordsOfNodes2(1,2);y2L = coordsOfNodes2(2,2);z2L = coordsOfNodes2(3,2);
    x3L = coordsOfNodes2(1,3);y3L = coordsOfNodes2(2,3);z3L = coordsOfNodes2(3,3);
    x4L = coordsOfNodes2(1,4);y4L = coordsOfNodes2(2,4);z4L = coordsOfNodes2(3,4);
    
    % Find midpoint of tetrahedron 1
    mid2 = [(x1L+x2L+x3L+x4L)/4;(y1L+y2L+y3L+y4L)/4;(z1L+z2L+z3L+z4L)/4;];
    
    xi = mid1(1);
    yi = mid1(2);
    zi = mid1(3);
    
    xj = mid2(1);
    yj = mid2(2);
    zj = mid2(3);
    
    % Find the distance between tetrahedrons
    L = sqrt((xi-xj)^2 + (yi-yj)^2 + (zi-zj)^2);
end
end

